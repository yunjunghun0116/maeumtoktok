import 'package:app/features/chat/data/models/exists_chat_dto.dart';
import 'package:app/features/chat/domain/repositories/chat_repository.dart';
import 'package:app/shared/base/base_use_case_with_param.dart';

class ExistsChat extends BaseUseCaseWithParam<ExistsChatDto, bool> {
  final ChatRepository chatRepository;

  ExistsChat({required this.chatRepository});

  @override
  Future<bool> call(ExistsChatDto existsChatDto) async {
    return await chatRepository.existsByMemberIdAndTargetId(existsChatDto.memberId, existsChatDto.targetId);
  }
}
