import 'package:app/features/member/data/models/create_member_personality_dto.dart';
import 'package:app/features/member/domain/entities/member_personality.dart';
import 'package:app/features/member/domain/repositories/member_personality_repository.dart';
import 'package:app/shared/constants/firebase_collection.dart';

import '../../../../core/base/base_use_case_with_param.dart';
import '../../../../core/domain/repositories/sequence_repository.dart';

class CreateMemberPersonality extends BaseUseCaseWithParam<CreateMemberPersonalityDto, MemberPersonality> {
  final MemberPersonalityRepository _memberPersonalityRepository;
  final SequenceRepository _sequenceRepository;

  CreateMemberPersonality({
    required MemberPersonalityRepository memberPersonalityRepository,
    required SequenceRepository sequenceRepository,
  }) : _sequenceRepository = sequenceRepository,
       _memberPersonalityRepository = memberPersonalityRepository;

  @override
  Future<MemberPersonality> execute(CreateMemberPersonalityDto createMemberPersonalityDto) async {
    var id = await _sequenceRepository.getNextSequence(FirebaseCollection.memberPersonalityCollection);
    var memberPersonality = MemberPersonality.fromDto(id, createMemberPersonalityDto);
    return await _memberPersonalityRepository.create(memberPersonality);
  }
}
