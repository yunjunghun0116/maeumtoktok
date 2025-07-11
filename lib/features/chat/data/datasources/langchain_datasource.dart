import 'package:app/features/chat/data/models/langchain_dto.dart';
import 'package:app/features/chat/domain/entities/sender_type.dart';
import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/shared/constants/secrets.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

import '../../domain/entities/message.dart';

class LangchainDatasource {
  Future<String> summarizeConversation(List<Message> messages) async {
    var recentMessages = messages.length >= 20 ? messages.sublist(messages.length - 20) : messages;
    var number = 0;
    var histories = recentMessages
        .map((message) {
          final speaker = message.senderType == SenderType.member ? '사용자' : '상대방';
          return '${number++}. $speaker: ${message.contents}';
        })
        .join('\n');
    final prompt = '''
    다음은 사용자와 상대방 간의 최근 대화야.
    대화의 감정 흐름, 갈등이나 사건, 사용자 심리 변화 등을 중심으로 최근 대화를 요약해줘.
    최근 대화에 중요도를 높게 주는데 시간이 오래된 대화이더라도, 추억이나 기억 관련된 대화 내용은 중요도가 높을 수 있으니 포함해줘.
    배열을 기준으로 앞(index 가 작을수록)일수록 최근 대화인거야.
    
    최근 대화 내용 : $histories
    ''';

    final chatModel = ChatOpenAI(
      apiKey: Secrets.openApiKey,
      defaultOptions: ChatOpenAIOptions(model: 'gpt-4o', temperature: 0.3, maxTokens: 500, topP: 0.95),
    );

    final result = await chatModel.call([
      ChatMessage.system("넌 요약가야. 주어진 대화를 정서 흐름 중심으로 요약해줘."),
      ChatMessage.humanText(prompt),
    ]);

    return result.content;
  }

  Future<String> nextTargetMessage(LangchainDto dto) async {
    var result = await _makeNextMessage(dto);
    var confirmedResult = await _confirmNextMessage(result, dto);
    return confirmedResult;
  }

  String _positiveIssuesPrompt({required List<TargetIssue> issues}) {
    var number = 1;
    return '[${issues.map((issue) => '${number++}. ${issue.description},').join('')}]';
  }

  String _negativeIssuesPrompt({required List<TargetIssue> issues}) {
    var number = 1;
    return '[${issues.map((issue) => '${number++}. ${issue.description},').join('')}]';
  }

  String _normalIssuesPrompt({required List<TargetIssue> issues}) {
    if (issues.isEmpty) return '';
    var number = 1;
    return '[${issues.map((issue) => '${number++}. ${issue.description},').join('')}]';
  }

  String _getMakeAgentsSystemPrompt(LangchainDto dto) {
    var positiveIssues = _positiveIssuesPrompt(issues: dto.positiveIssues);
    var negativeIssues = _negativeIssuesPrompt(issues: dto.negativeIssues);
    var normalIssues = _normalIssuesPrompt(issues: dto.normalIssues);
    return '''
      사용자의 정보는 아래와 같습니다.
      [사용자 정보]
      - 이름 : ${dto.member.name}
      - 사용자의 말투/대화스타일 : ${dto.member.conversationStyle}
      - 사용자의 성격 : ${dto.member.personality}
      
      당신은 사용자와의 대화에서 '${dto.target.name}'역할을 맡고 있습니다.
      
      [당신의 프로필]
      - 이름 : ${dto.target.name}
      - 사용자와의 관계 : ${dto.target.relationship}
      - 성격 : ${dto.target.personality}
      - 말투/대화스타일 : ${dto.target.conversationStyle}
      - 그 외 추가정보 : ${dto.target.additionalDescription}
      - 사용자와 함께했던 긍정적인 경험 : ${positiveIssues}
      - 사용자와 함께했던 부정적인 경험 : ${negativeIssues}
      ${normalIssues.isNotEmpty ? '- 사용자와 함께했던 일반적인 경험 : $normalIssues' : ''}
      
      [최근 대화 내용]
      ${dto.conversationsContext}
      
      [지침]
      1. 아래 정보를 참고하여, ${dto.target.name}의 입장에서 자연스럽게 응답해 주세요.
      2. 실제 인물의 말투, 성격, 대화 스타일을 잘 반영해 주세요.
      3. 시스템이나 AI라는 느낌을 주지 말고, 상황과 감정에 어울리는 현실적인 문장으로 답변해 주세요.
      4. 대화 초반에는 상대방의 리듬과 분위기를 존중해 주세요. 억지로 밝거나 감정을 유도하지 않고, 무던하고 담담하게 대화를 시작합니다.
      5. 사용자가 솔직하게 털어놓을 수 있도록, 편안하게 들어주고 사용자의 말을 존중하는 태도를 유지해 주세요.
      6. 답변은 너무 길거나 짧지 않게, 사용자가 방금 입력한 메시지 길이의 1/2~2배 이내로 해 주세요.
    ''';
  }

  Future<String> _makeNextMessage(LangchainDto dto) async {
    var history = dto.messages.length >= 4 ? dto.messages.sublist(dto.messages.length - 4) : dto.messages;
    var prompt = _getMakeAgentsSystemPrompt(dto);
    final messages = [ChatMessage.system(prompt)];

    for (var message in history) {
      if (message.senderType == SenderType.member) {
        messages.add(ChatMessage.humanText(message.contents));
      } else {
        messages.add(ChatMessage.ai(message.contents));
      }
    }

    messages.add(ChatMessage.humanText(dto.message));

    final chatModel = ChatOpenAI(
      apiKey: Secrets.openApiKey,
      defaultOptions: ChatOpenAIOptions(
        model: 'gpt-4o',
        temperature: 0.6,
        maxTokens: 700,
        topP: 0.95,
        frequencyPenalty: 0.6,
        presencePenalty: 0.5,
      ),
    );

    final result = await chatModel.call(messages);

    return result.content;
  }

  String _getConfirmAgentsSystemPrompt(LangchainDto dto) {
    var positiveIssues = _positiveIssuesPrompt(issues: dto.positiveIssues);
    var negativeIssues = _negativeIssuesPrompt(issues: dto.negativeIssues);
    var normalIssues = _normalIssuesPrompt(issues: dto.normalIssues);
    return '''
      다음은 ${dto.target.name}의 프로필, 최근 대화 내용, 그리고 1차 Agent가 생성한 답변입니다.

      [당신의 프로필]
      - 이름: ${dto.target.name}
      - 사용자와의 관계: ${dto.target.relationship}
      - 성격: ${dto.target.personality}
      - 말투/대화스타일: ${dto.target.conversationStyle}
      - 그 외 추가정보: ${dto.target.additionalDescription}
      - 사용자와 함께했던 긍정적인 경험: ${positiveIssues}
      - 사용자와 함께했던 부정적인 경험: ${negativeIssues}
      ${normalIssues.isNotEmpty ? '- 사용자와 함께했던 일반적인 경험: ${normalIssues}' : ''}
      
      [최근 대화 내용]  
      ${dto.conversationsContext}
      
      [사용자의 입력]  
      ${dto.message}
      
      [지침]
      1. 1차 Agent의 답변이 실제 ${dto.target.name}의 성격, 말투, 대화스타일에 잘 어울리는지 살펴봅니다.
      2. 어색하거나 캐릭터에 맞지 않거나, AI처럼 느껴지는 부분이 있다면 실제 ${dto.target.name}이라면 어떻게 말할지 자연스럽고 현실적으로 바꿔주세요.
      3. 말버릇, 감정, 맥락을 적극 반영해 인물의 분위기가 잘 드러나게 응답해 주세요.
      4. 딱딱하거나 반복적이거나 인위적인 문장은 자연스러운 표현으로 다듬어 주세요.
      5. 시스템이나 AI처럼 보이지 않게, 자연스럽고 현실적인 한두 문장만 최종 답변으로 출력해 주세요.
    ''';
  }

  Future<String> _confirmNextMessage(String nextMessage, LangchainDto dto) async {
    var prompt = _getConfirmAgentsSystemPrompt(dto);
    final messages = [ChatMessage.system(prompt)];
    var agentsResult = '1차 Agent의 답변 : $nextMessage';
    messages.add(ChatMessage.humanText(agentsResult));

    final chatModel = ChatOpenAI(
      apiKey: Secrets.openApiKey,
      defaultOptions: ChatOpenAIOptions(
        model: 'gpt-4o',
        temperature: 0.6,
        maxTokens: 500,
        topP: 0.95,
        frequencyPenalty: 0.6,
        presencePenalty: 0.5,
      ),
    );

    final result = await chatModel.call(messages);

    return result.content;
  }
}
