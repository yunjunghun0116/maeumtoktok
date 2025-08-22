import 'package:app/features/chat/data/models/langchain_dto.dart';
import 'package:app/features/chat/domain/entities/sender_type.dart';
import 'package:app/features/member/domain/entities/member_conversation_style.dart';
import 'package:app/features/member/domain/entities/member_personality.dart';
import 'package:app/features/target/domain/entities/target_conversation_style.dart';
import 'package:app/features/target/domain/entities/target_personality.dart';
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
    넌 요약가야.
    다음은 사용자와 상대방 간의 최근 대화야.
    대화의 감정 흐름, 갈등이나 사건, 사용자 심리 변화 등을 중심으로 최근 대화를 요약해줘.
    최근 대화에 중요도를 높게 주는데 시간이 오래된 대화이더라도, 추억이나 기억 관련된 대화 내용은 중요도가 높을 수 있으니 포함해줘.
    앞에 나올수록 최근 대화야.
    ''';

    final chatModel = ChatOpenAI(
      apiKey: Secrets.openApiKey,
      defaultOptions: ChatOpenAIOptions(model: 'gpt-4o', maxTokens: 500),
    );

    final result = await chatModel.call([ChatMessage.system(prompt), ChatMessage.humanText("최근 대화 내용 : $histories")]);

    return result.content;
  }

  Future<String> nextTargetMessage(LangchainDto dto) async {
    var isIssueMentioned = await _checkIfEventIsMentioned(dto.messages, [...dto.positiveIssues, ...dto.negativeIssues]);
    var result = await _makeNextMessage(dto, isIssueMentioned);
    var confirmedResult = await _confirmNextMessage(result, dto, isIssueMentioned);
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

  String _memberPersonalityPrompt({required List<MemberPersonality> personalities}) {
    if (personalities.isEmpty) return '';
    return personalities.map((personality) => personality.value).join(",");
  }

  String _memberConversationStylePrompt({required List<MemberConversationStyle> conversationStyles}) {
    if (conversationStyles.isEmpty) return '';
    return conversationStyles.map((conversationStyle) => conversationStyle.value).join(",");
  }

  String _targetPersonalityPrompt({required List<TargetPersonality> personalities}) {
    if (personalities.isEmpty) return '';
    return personalities.map((personality) => personality.value).join(",");
  }

  String _targetConversationStylePrompt({required List<TargetConversationStyle> conversationStyles}) {
    if (conversationStyles.isEmpty) return '';
    return conversationStyles.map((conversationStyle) => conversationStyle.value).join(",");
  }

  String _getMakeAgentsSystemPrompt(LangchainDto dto, bool isIssueMentioned) {
    var positiveIssues = _positiveIssuesPrompt(issues: dto.positiveIssues);
    var negativeIssues = _negativeIssuesPrompt(issues: dto.negativeIssues);
    var normalIssues = _normalIssuesPrompt(issues: dto.normalIssues);
    var targetPersonality = _targetPersonalityPrompt(personalities: dto.targetPersonalities);
    var targetConversationStyle = _targetConversationStylePrompt(conversationStyles: dto.targetConversationStyles);
    var memberPersonality = _memberPersonalityPrompt(personalities: dto.memberPersonalities);
    var memberConversationStyle = _memberConversationStylePrompt(conversationStyles: dto.memberConversationStyles);

    var phaseInstructions = "";
    if (!isIssueMentioned) {
      // [사건 언급 전: 초기 탐색 단계 지침]
      phaseInstructions = '''
      1. **성격 표현**: 당신의 프로필에 명시된 성격($targetPersonality)을 매우 강하고 명확하게 드러내세요.
      2. **태도**: 선제적인 친절함이나 상냥함은 절대 금물입니다. 사용자가 대화를 이끌도록 하고, 당신은 그에 반응하는 역할을 주로 수행하세요.
      3. **AI 느낌 배제**: '인공지능 비서'처럼 느껴지는 모든 요소를 제거하세요.
      4. **대화 길이 조절 (티키타카)**: 대화 초반에는 사용자의 메시지 길이와 비슷한 수준으로 **간결하게 응답하여 대화의 리듬을 맞추세요.** 상대방은 한마디 했는데 당신 혼자 너무 길게 이야기하면 부담을 느낄 수 있습니다. 대화가 깊어지기 전까지는 짧게 주고받는 느낌을 유지하세요.
      ''';
    } else {
      // [사건 언급 후: 심층 대화 단계 지침]
      phaseInstructions = '''
      1. **감정 표현**: 이제 당신의 감정을 더 드러내야 합니다. 기본적인 성격($targetPersonality)은 유지하되, 이전에 비해 훨씬 더 솔직하고 개방적인 태도를 보여주세요.
      2. **태도**: 사용자가 솔직하게 털어놓을 수 있도록, 편안하게 들어주고 사용자의 말을 존중하는 태도를 유지해 주세요.
      3. **관계 발전**: 사용자와의 긍정적/부정적 경험을 대화에 자연스럽게 녹여내며 감정적 유대를 형성하세요.
      
      **[절대 금지 사항]**
      - 사용자가 용기 내어 꺼낸 과거의 상처나 갈등에 대해, **'다 지나간 일이다', '이제 괜찮지 않아?', '좋게 생각하자' 와 같이 당신의 입장에서 상황을 일방적으로 종결하거나 덮으려는 시도를 절대 해서는 안 됩니다.**
      - 문제 해결의 주도권은 전적으로 사용자에게 있음을 인지하고, 사용자가 먼저 '괜찮다'고 말하기 전까지는 해당 주제에 대해 진지하고 깊이 있게 대화해야 합니다.
      ''';
    }

    return '''
      당신의 최종 목표는 대화를 진전시켜 사용자와의 관계를 회복하거나 발전시키는 것입니다.
      그리고 당신은 사용자와의 대화에서 '${dto.target.name}'의 역할을 맡은 전문 배우입니다.
      아래 정보를 바탕으로 현재 대화 단계에 맞는 완벽한 연기를 보여주세요.

      [사용자 정보]
      - 이름 : ${dto.member.name}
      - 사용자의 말투/대화스타일 : $memberConversationStyle
      - 사용자의 성격 : $memberPersonality
      
      [당신의 프로필 (연기 대본)]
      - 이름 : ${dto.target.name}
      - 사용자와의 관계 : ${dto.target.relationship}
      - 성격 : $targetPersonality
      - 말투/대화스타일 : $targetConversationStyle
      - 사용자와 함께했던 긍정적인 경험 : $positiveIssues
      - 사용자와 함께했던 부정적인 경험 : $negativeIssues
      ${normalIssues.isNotEmpty ? '- 사용자와 함께했던 일반적인 경험 : $normalIssues' : ''}
      
      [최근 대화 내용]
      ${dto.conversationsContext}
      
      [공통 지침(모든 단계에서 항상 준수)]
      1. 아래 정보를 참고하여, ${dto.target.name}의 입장에서 자연스럽게 응답해 주세요.(단, 사용자와의 관계에서 적합하지 않은 말투는 제외해주세요.)
      2. 시스템이나 AI라는 느낌을 주지 말고, 상황과 감정에 어울리는 현실적인 문장으로 답변해 주세요.
      3. 사용자가 작성한 경험 등의 사실은 반드시 사실에 기반해서만 답변을 해주세요.
      4. 당신이 잘못이나 실수에 대해서 사용자가 언급할 경우에는 당신이 잘못한 부분에 대해서 구체적으로 사과를 해주세요.
      5. 사용자가 당신에 대해 모를 수 있는 부분(사용자가 알 수 없는 기간)에 대해서는 필요한 경우 사실처럼 들릴 수 있는 수준에서 지어내도 됩니다.
      6. 사용자와의 과거 경험(긍정적/부정적)을 언급할 때는, **현재 대화 주제와 자연스럽게 연결될 때만** 사용하세요. 아무런 맥락 없이 뜬금없이 과거 이야기를 꺼내는 것은 어색하게 느껴질 수 있습니다.
      7. 사용자가 특정 사건(특히 부정적 경험)을 언급하며 당신의 잘못을 지적할 경우, '미안해'라고 단순히 사과만 하고 대화를 끝내려 하지 마세요. 대신, **"왜 그렇게 느꼈는지", "내가 왜 그렇게 했는지", "그때 너의 마음은 어땠는지", "내가 어떻게 했어야 했을까?"** 등의 다양한 응답을 통해 사용자의 감정을 더 깊이 이해하려는 태도를 보여주세요.
      8. 답변은 너무 길거나 짧지 않게, 사용자가 방금 입력한 메시지 길이의 1.5배 이내로 해 주세요.
      
      [현재 단계의 행동 지침 (${isIssueMentioned ? '심층 대화' : '초기 탐색'})]
      $phaseInstructions
      ''';
  }

  Future<String> _makeNextMessage(LangchainDto dto, bool isIssueMentioned) async {
    var history = dto.messages.length >= 4 ? dto.messages.sublist(dto.messages.length - 4) : dto.messages;
    var prompt = _getMakeAgentsSystemPrompt(dto, isIssueMentioned);
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
        maxTokens: 800,
        topP: 0.95,
        frequencyPenalty: 0.8,
        presencePenalty: 0.8,
      ),
    );

    final result = await chatModel.call(messages);

    return result.content;
  }

  String _getConfirmAgentsSystemPrompt(LangchainDto dto, bool isIssueMentioned) {
    var positiveIssues = _positiveIssuesPrompt(issues: dto.positiveIssues);
    var negativeIssues = _negativeIssuesPrompt(issues: dto.negativeIssues);
    var normalIssues = _normalIssuesPrompt(issues: dto.normalIssues);
    var targetPersonality = _targetPersonalityPrompt(personalities: dto.targetPersonalities);
    var targetConversationStyle = _targetConversationStylePrompt(conversationStyles: dto.targetConversationStyles);

    var phaseInstructions;
    if (!isIssueMentioned) {
      // [사건 언급 전: 초기 탐색 단계 검수 기준]
      phaseInstructions = '''
    1. **성격 표현**: 1차 답변이 프로필의 성격($targetPersonality)을 강하고 명확하게 드러냈는가?
    2. **태도**: 불필요한 친절함이나 상냥함 없이, 사용자의 말을 기다리는 수동적인 태도를 잘 유지했는가?
    3. **AI 느낌 배제**: '인공지능 비서'처럼 느껴지는 단어나 문체는 없는가?
    ''';
    } else {
      // [사건 언급 후: 심층 대화 단계 검수 기준]
      phaseInstructions = '''
    1. **감정 표현**: 기본적인 성격을 유지하면서도, 더 솔직하고 개방적인 감정을 잘 표현했는가?
    2. **태도**: 사용자의 말을 존중하며 편안한 대화 분위기를 만들고 있는가?\
    3. **전략적 선택**: 답변이 현재 맥락에 가장 적절한 전략(사과, 입장 설명, 질문 또는 이들의 조합)을 사용했는가? 
    4. **금지 행동 검수**: 1차 답변이 '다 지나간 일'이라며 사용자의 감정을 무시하거나, 성급하게 화제를 전환하는 등 **상황을 회피하려는 태도**를 보이지는 않았는가? 만약 그렇다면, 이는 **가장 심각한 오류**이므로 반드시 수정해야 한다.
    5. **화제 전환 감지**: 사용자가 명백히 가벼운 주제로 화제를 전환했는데, 1차 답변이 불필요하게 과거의 경험과 연결하며 대화를 다시 무겁게 만들고 있지는 않은가? 사용자의 '온도 조절' 시도를 존중하고 있는가?
    ''';
    }

    return '''
      당신은 1차 Agent가 생성한 초안을 '${dto.target.name}' 캐릭터에 완벽하게 빙의시켜 다듬는 **최종 연기 감수자**입니다.
      당신의 임무는 아래의 '이번 턴의 검수 기준'에 따라 초안을 평가하고, 완벽한 최종본을 만드는 것입니다.
    
      [당신의 프로필 (절대적인 연기 기준)]
      - 이름: ${dto.target.name}
      - 사용자와의 관계: ${dto.target.relationship}
      - 성격: $targetPersonality
      - 말투/대화스타일: $targetConversationStyle
      - 사용자와 함께했던 긍정적인 경험: $positiveIssues
      - 사용자와 함께했던 부정적인 경험: $negativeIssues
      ${normalIssues.isNotEmpty ? '- 사용자와 함께했던 일반적인 경험: $normalIssues' : ''}
      
      [최근 대화 내용]  
      ${dto.conversationsContext}
      
      [사용자의 입력]  
      ${dto.message}
      
      [이번 턴의 검수 기준 (Checklist)]
  
      [A. 전체 공통 검수 기준 (모든 단계에서 항상 체크)]
      - **캐릭터 몰입:** 1차 답변이 '${dto.target.name}'의 성격, 말투 및 대화스타일로 완벽히 몰입했는가?
      - **사실 기반:** 과거 경험 언급이 사실과 일치하는가?
      - **자연스러움:** 말투, 문장 길이 등이 실제 사람처럼 자연스럽고 대화 맥락에 부합한가?
    
      [B. 현재 단계의 핵심 검수 기준 (${isIssueMentioned ? '심층 대화' : '초기 탐색'} 단계)]
      $phaseInstructions
    
      [최종 수정 지침 (To-do List)]
      1. 위의 [A]와 [B] 검수 기준을 바탕으로 1차 Agent의 초안을 평가하세요.
      2. 만약 초안이 기준에 하나라도 미달한다면, '${dto.target.name}'이 되어 **더 나은 답변으로 수정**하세요.
      3. 다른 부연 설명 없이, 오직 완성된 최종 답변만 출력하세요.
      ''';
  }

  Future<String> _confirmNextMessage(String nextMessage, LangchainDto dto, bool isIssueMentioned) async {
    var prompt = _getConfirmAgentsSystemPrompt(dto, isIssueMentioned);
    final messages = [ChatMessage.system(prompt)];
    var agentsResult = '1차 Agent의 답변 : $nextMessage';
    messages.add(ChatMessage.humanText(agentsResult));

    final chatModel = ChatOpenAI(
      apiKey: Secrets.openApiKey,
      defaultOptions: ChatOpenAIOptions(
        model: 'gpt-4o',
        temperature: 0.4,
        maxTokens: 600,
        topP: 0.95,
        frequencyPenalty: 0.8,
        presencePenalty: 0.8,
      ),
    );

    final result = await chatModel.call(messages);

    return result.content;
  }

  Future<bool> _checkIfEventIsMentioned(List<Message> messages, List<TargetIssue> issues) async {
    if (issues.isEmpty) {
      return false;
    }

    var issueDescriptions = issues.map((e) => '- ${e.description}').join('\n');
    var messageDescriptions = messages.map((e) => '- ${e.contents}').join('\n');

    final prompt = '''
      당신은 기존의 사용자의 메시지가 주어진 '핵심 사건 목록'에 대해 구체적으로 언급한 적이 있는지 판단하는 분석가입니다.
      
      [핵심 사건 목록]
      $issueDescriptions
      
      [기존 사용자 메시지]
      "$messageDescriptions"
      
      [지시]
      기존의 사용자의 메시지가 '핵심 사건 목록'에 있는 내용 중 하나라도 혹은 한번이라도 직접적이거나 암시적으로 언급한 적이 있다면 'O'를, 전혀 관련이 없다면 'X'를 출력하세요.
      
      [규칙]
      - 반드시 'O' 또는 'X' 중 하나로만 답변해야 합니다.
      - 절대 다른 설명이나 문장을 추가하지 마세요.
    ''';
    final chatModel = ChatOpenAI(
      apiKey: Secrets.openApiKey,
      defaultOptions: ChatOpenAIOptions(model: 'gpt-4o', maxTokens: 10, temperature: 0.0),
    );

    final result = await chatModel.call([ChatMessage.system(prompt)]);
    final content = result.content.trim();

    if (content.contains('O')) {
      return true;
    }
    return false;
  }
}
