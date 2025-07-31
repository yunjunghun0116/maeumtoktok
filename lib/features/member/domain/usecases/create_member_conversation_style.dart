import 'package:app/features/member/domain/repositories/member_conversation_style_repository.dart';
import 'package:app/shared/constants/firebase_collection.dart';

import '../../../../core/base/base_use_case_with_param.dart';
import '../../../../core/domain/repositories/sequence_repository.dart';
import '../../data/models/create_member_conversation_style_dto.dart';
import '../entities/member_conversation_style.dart';

class CreateMemberConversationStyle
    extends BaseUseCaseWithParam<CreateMemberConversationStyleDto, MemberConversationStyle> {
  final MemberConversationStyleRepository _memberConversationStyleRepository;
  final SequenceRepository _sequenceRepository;

  CreateMemberConversationStyle({
    required MemberConversationStyleRepository memberConversationStyleRepository,
    required SequenceRepository sequenceRepository,
  }) : _sequenceRepository = sequenceRepository,
       _memberConversationStyleRepository = memberConversationStyleRepository;

  @override
  Future<MemberConversationStyle> execute(CreateMemberConversationStyleDto createMemberConversationStyleDto) async {
    var id = await _sequenceRepository.getNextSequence(FirebaseCollection.memberConversationStyleCollection);
    var memberConversationStyle = MemberConversationStyle.fromDto(id, createMemberConversationStyleDto);
    return await _memberConversationStyleRepository.create(memberConversationStyle);
  }
}
