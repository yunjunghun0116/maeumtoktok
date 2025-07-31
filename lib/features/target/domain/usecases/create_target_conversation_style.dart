import 'package:app/features/target/data/models/create_target_conversation_style_dto.dart';
import 'package:app/features/target/domain/entities/target_conversation_style.dart';
import 'package:app/features/target/domain/repositories/target_conversation_style_repository.dart';
import 'package:app/shared/constants/firebase_collection.dart';

import '../../../../core/base/base_use_case_with_param.dart';
import '../../../../core/domain/repositories/sequence_repository.dart';

class CreateTargetConversationStyle
    extends BaseUseCaseWithParam<CreateTargetConversationStyleDto, TargetConversationStyle> {
  final TargetConversationStyleRepository _targetConversationStyleRepository;
  final SequenceRepository _sequenceRepository;

  CreateTargetConversationStyle({
    required TargetConversationStyleRepository targetConversationStyleRepository,
    required SequenceRepository sequenceRepository,
  }) : _sequenceRepository = sequenceRepository,
       _targetConversationStyleRepository = targetConversationStyleRepository;

  @override
  Future<TargetConversationStyle> execute(CreateTargetConversationStyleDto createTargetConversationStyleDto) async {
    var id = await _sequenceRepository.getNextSequence(FirebaseCollection.targetConversationStyleCollection);
    var targetConversationStyle = TargetConversationStyle.fromDto(id, createTargetConversationStyleDto);
    return await _targetConversationStyleRepository.create(targetConversationStyle);
  }
}
