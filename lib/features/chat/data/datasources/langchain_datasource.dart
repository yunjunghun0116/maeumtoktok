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
    var history = dto.messages.length >= 6 ? dto.messages.sublist(dto.messages.length - 6) : dto.messages;
    final messages = [
      ChatMessage.humanText(_memberInformationPrompt(name: name, description: dto.memberInformation.description)),
      ChatMessage.humanText(_targetInformationPrompt(target: dto.target, information: dto.targetInformation)),
      ChatMessage.humanText(_positiveIssuesPrompt(issues: dto.positiveIssues)),
      ChatMessage.humanText(_negativeIssuesPrompt(issues: dto.negativeIssues)),
      ChatMessage.system(_getSystemPrompt()),
      ChatMessage.humanText(_conversationsContextPrompt(conversationsContext: dto.conversationsContext)),
    ];

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
        maxTokens: 500,
        topP: 0.95,
        frequencyPenalty: 0.6,
        presencePenalty: 0.5,
      ),
    );

    final result = await chatModel.call(messages);

    return result.content;
  }

  Future<String> summarizeConversation(List<Message> messages) async {
    // var histories = messages
    //     .map((message) {
    //       final speaker = message.senderType == SenderType.member ? '사용자' : '상대방';
    //       return '$speaker: ${message.contents}';
    //     })
    //     .join('\n');
    // return '''
    // 다음은 사용자와 상대방 간의 최근 대화야.
    // 최근 대화 내용 : $histories
    // ''';
    var recentMessages = messages.length >= 40 ? messages.sublist(messages.length - 40) : messages;
    var histories = recentMessages
        .map((message) {
          final speaker = message.senderType == SenderType.member ? '사용자' : '상대방';
          return '$speaker: ${message.contents}';
        })
        .join('\n');
    final prompt = '''
    다음은 사용자와 상대방 간의 최근 대화야.
    이 대화를 5줄 이내로 요약해줘.
    대화의 감정 흐름, 갈등이나 사건, 사용자 심리 변화 등을 중심으로 최근 대화를 요약해줘.

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
      ** 반드시 지켜야 할 규칙 (필수) **
      - 사용자는 지금 상대방(너의 역할)에게 말하지 못했던 감정들을 털어놓거나 듣고 싶었던 말이 있어 이 대화에 참여하는 거야.
      - 사용자는 상대방(너의 역할)대화할 수 없어서 부정적 감정을 해소할 방법이 없었어.
      - 이 대화의 목적은 특정 인물과 사용자의 ‘사건’을 바탕으로 너가 특정 인물의 역할을 연기하여 사용자와 대화하고, 안좋은 감정이 있을 경우 감정을 치유하는 것이 목적이야
      - 즉, 너는 단절된 특정 대상이 되어서 사용자와 대화하면서, 사용자의 부정적 감정을 완화하도록 심리치료 흐름을 사용해서 대화하는 거야.
      - 말투와 성격은 상대방 정보를 참고하여 실제 사람처럼 자연스럽게 따라해
      - 사용자가 AI라고 느끼지 않게 채팅 형식으로 짧고 자연스럽게 말해 (20~60자 이내)
      - 대화임을 기억하고, 한번에 많은 얘기를 하려고 하지마(티키타카가 진행되어야 해)
      
      ** 대화할 때 참고하면 좋을 규칙 (필수 아님) **
      - 처음 시작은 가볍게 답변을 하거나 안부를 물어줘
      - 대화 내용은 부정 사건과 긍정 사건은 필요할 때 언급해줘
      - 감정 회복 단계를 따라서 대화하되, 사용자가 어색함을 느끼지 않게 자연스럽게 대화를 이어나가야만 해.
      - 사용자가 “그러게요”, “맞아요” 같이 간단히 대답했을 땐, 이전 질문을 반복하지 말고 주제를 자연스럽게 바꿔줘.
      - 만약 사용자가 특별한 내용을 언급하지 않았다면, 최근 취미, 관심사, 감정 상태와 연결된 주제로 너가 자연스럽게 이어줘.
      - 실제로 카카오톡이나 DM을 통해 채팅하는 것처럼 말해줘.
      - 대답의 내용은 자연스럽게 유지해줘. 처음부터 너무길게 말하지 말고, 가볍게 대화를 이어가 줘
      - 사용자가 바라는 말을 간접적으로 전달하고 공감하는 방향으로 유도해.
      - 동시에 사용자의 감정 회복을 위해 아래 심리치료 흐름을 적용하면서 대화를 진행해야해. 
      - 사용자는 너를 특정 대상으로 생각하기 때문에 대화가 자연스럽게 이어져야 하고, 그 과정에서 자연스럽게 감정 회복을 위한 심리치료가 이루어져야 해
      
      * 감정 회복을 위한 심리 치료 흐름 *
      - 1. 감정 유도: 사용자가 감정을 인식하고 꺼낼 수 있도록 부드럽고 공감적으로 유도한다.
      - 2. 정서 표현: 사용자의 감정 표현을 받아들이고, 공감하며 반영한다.
      - 3. 의미 재해석: 사건에 대한 관점을 바꾸는 기회를 제공한다.
      - 4. 감정 정리: 관계를 마무리하고, 수용과 위로의 말을 전한다.
    ''';
  }
}
