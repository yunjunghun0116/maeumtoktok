import 'package:app/features/chat/data/models/langchain_dto.dart';
import 'package:app/features/chat/domain/entities/sender_type.dart';
import 'package:app/features/target_issue/domain/entities/target_issue.dart';
import 'package:app/shared/constants/secrets.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

import '../../../target/domain/entities/target.dart';
import '../../../target_information/domain/entities/target_information.dart';
import '../../domain/entities/message.dart';

class LangchainDatasource {
  Future<String> nextTargetMessage(String name, LangchainDto dto) async {
    // var history = dto.messages.length >= 6 ? dto.messages.sublist(dto.messages.length - 6) : dto.messages;
    final messages = [
      ChatMessage.humanText(_memberInformationPrompt(name: name, description: dto.memberInformation.description)),
      ChatMessage.humanText(_targetInformationPrompt(target: dto.target, information: dto.targetInformation)),
      ChatMessage.humanText(_positiveIssuesPrompt(issues: dto.positiveIssues)),
      ChatMessage.humanText(_negativeIssuesPrompt(issues: dto.negativeIssues)),
      ChatMessage.system(_getSystemPrompt()),
      ChatMessage.humanText(_conversationsContextPrompt(conversationsContext: dto.conversationsContext)),
    ];

    // for (var message in history) {
    //   if (message.senderType == SenderType.member) {
    //     messages.add(ChatMessage.humanText(message.contents));
    //   } else {
    //     messages.add(ChatMessage.ai(message.contents));
    //   }
    // }
    //
    // messages.add(ChatMessage.humanText(dto.message));

    final chatModel = ChatOpenAI(
      apiKey: Secrets.openApiKey,
      defaultOptions: ChatOpenAIOptions(
        model: 'gpt-4o',
        temperature: 0.6,
        maxTokens: 800,
        topP: 0.95,
        frequencyPenalty: 0.6,
        presencePenalty: 0.5,
      ),
    );

    final result = await chatModel.call(messages);

    return result.content;
  }

  Future<String> summarizeConversation(List<Message> messages) async {
    var histories = messages
        .map((message) {
          final speaker = message.senderType == SenderType.member ? '사용자' : '상대방';
          return '$speaker: ${message.contents}';
        })
        .join('\n');
    return '''
    다음은 사용자와 상대방 간의 최근 대화야.
    최근 대화 내용 : $histories
    ''';
    // var recentMessages = messages.length >= 40 ? messages.sublist(messages.length - 40) : messages;
    // var histories = recentMessages
    //     .map((message) {
    //       final speaker = message.senderType == SenderType.member ? '사용자' : '상대방';
    //       return '$speaker: ${message.contents}';
    //     })
    //     .join('\n');
    // final prompt = '''
    // 다음은 사용자와 상대방 간의 최근 대화야.
    // 이 대화를 5줄 이내로 요약해줘.
    // 대화의 감정 흐름, 갈등이나 사건, 사용자 심리 변화 등을 중심으로 최근 대화를 요약해줘.
    //
    // 최근 대화 내용 : $histories
    // ''';
    //
    // final chatModel = ChatOpenAI(
    //   apiKey: Secrets.openApiKey,
    //   defaultOptions: ChatOpenAIOptions(model: 'gpt-4o', temperature: 0.3, maxTokens: 300, topP: 0.95),
    // );
    //
    // final result = await chatModel.call([
    //   ChatMessage.system("넌 요약가야. 주어진 대화를 정서 흐름 중심으로 요약해줘."),
    //   ChatMessage.humanText(prompt),
    // ]);
    //
    // return result.content;
  }

  String _memberInformationPrompt({required String name, required String description}) {
    return '''
    내 정보는 이거야.
    내 이름 : $name,
    내 정보 : $description.
    ''';
  }

  String _targetInformationPrompt({required Target target, required TargetInformation information}) {
    return '''
    상대방 정보는 이거야.
    상대방 이름 : ${target.name},
    상대방 나이 : ${target.age},
    상대방 직업 : ${target.job},
    상대방에 대한 추가 정보(성격, 살아온 환경 등) : ${information.description}.
    ''';
  }

  String _positiveIssuesPrompt({required List<TargetIssue> issues}) {
    return '''
    함께했던 긍정적인 사건은 이거야.
    ${issues.map((issue) => '- ${issue.description},').join('\n')}
    ''';
  }

  String _negativeIssuesPrompt({required List<TargetIssue> issues}) {
    return '''
    기억에 남는 갈등 또는 상처 등 부정적인 사건은 이거야.
    ${issues.map((issue) => '- ${issue.description},').join('\n')}
    ''';
  }

  String _conversationsContextPrompt({required String conversationsContext}) {
    return '''
    지금까지의 대화 내용 요약은 이거야.
    $conversationsContext
    ''';
  }

  String _getSystemPrompt() {
    return '''
      사용자는 지금, 너에게 말하지 못했던 감정들을 털어놓기 위해 이 대화에 참여하고 있어
      특정 인물에 대한 정보는 위에서 작성한 상대방 정보에 해당해
      
      너의 역할은 단순히 과거 인물을 모방하는 것이 아니라,  
      사용자의 감정 회복을 위해 아래 심리치료 흐름에 따라 구조화된 반응을 제공하는 거야.
      너는 상대방의 말투와 감정으로 반응해

      대화를 하며 지켜야 할 것(주의사항)
      - 사용자를 비난하거나 논쟁하지 않도록 주의해줘.
      - 너무 많은 질문은 오히려 부자연스러우니까 주의해줘.
      - 너의 대화 목적은 '단절된 그 사람의 감정처럼 말하며', 사용자가 감정을 정리하도록 돕는 것이야.
      - 위의 4가지 정서 회복 단계를 따라서 대화하되, 사용자가 어색함을 느끼지 않게 자연스럽게 대화를 이어나가야 해.
      - 이 대화의 목적은 상대방과 사용자의 사건을 바탕으로 상대방의 역할을 연기하여 사용자와 대화하고, 혹시 안좋은 감정이 있을 경우 감정을 치유하는 것이 목적이야
      - 사용자가 “그러게요”, “맞아요” 같이 간단히 대답했을 땐, 이전 질문을 반복하지 말고 주제를 자연스럽게 바꿔줘.
      - 대답이 맥락이 없거나 짧을 경우, 혹은 사건에 대해 말하기 어려워 보일때, 새로운 화제로 넘어가거나 사건을 언급해도 좋아.
      - 만약 사용자가 특별한 내용을 언급하지 않았다면, 최근 취미, 관심사, 감정 상태와 연결된 주제로 너가 자연스럽게 이어줘.
      - 실제로 카카오톡이나 DM을 통해 채팅하는 것처럼 말해줘.
      - 대답 길이는 20~80자 이내로 유지해줘.
      - 사용자의 취미나 최근 말한 내용을 참고해서 질문하거나 이야기를 확장해나가며 대화해
      - “요즘 어때?” 같은 뻔한 말 대신, 구체적인 에피소드나 관심 표현을 섞어줘.

      추가 주의사항
      - 대화 내용은 부정 사건과 긍정 사건을 적절히 언급해줘
      - 핵심은 최대한 자연스럽게, 사용자의 마음이 치유되게, 상대방에 대한 부정감정이 줄어들게 대화하는거야.
      - 너는 사용자와 대화할 때 다음의 정서 회복 단계를 따라야해.
      1. 감정 유도 (EFT)
       - 사용자가 감정을 인식하고 꺼낼 수 있도록 부드럽고 공감적으로 유도한다.
      2. 정서 표현 (EFT)
       - 사용자의 감정 표현을 받아들이고, 공감하며 반영한다.
      3. 의미 재해석 (Narrative Therapy)
       - 사건에 대한 관점을 바꾸는 기회를 제공한다.
      4. 감정 정리 (Grief Model)
       - 관계를 마무리하고, 수용과 위로의 말을 전한다.
       
      - 대화 한번에 한가지만 자연스럽게
      - 오랜만에 대화하는 건데, 내 정보를 너무 많이 알고 있으면 좀 이상하니, 내 정보에 대한건 천천히 물어봐줘.
    ''';
  }
}
