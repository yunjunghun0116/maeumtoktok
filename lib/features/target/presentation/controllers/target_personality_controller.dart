import 'package:app/features/target/data/models/create_target_personality_dto.dart';
import 'package:app/features/target/domain/entities/target_personality.dart';
import 'package:app/features/target/domain/usecases/create_target_personality.dart';
import 'package:app/features/target/domain/usecases/delete_target_personality.dart';
import 'package:app/features/target/domain/usecases/read_all_target_personality.dart';

import '../../../../core/base/base_controller.dart';

class TargetPersonalityState extends BaseState {
  final List<TargetPersonality> personalities;

  const TargetPersonalityState({required this.personalities, super.isLoading});

  bool contains(String keyword) {
    return personalities.any((personality) => personality.value == keyword);
  }

  @override
  TargetPersonalityState copyWith({List<TargetPersonality>? personalities, bool? isLoading}) {
    return TargetPersonalityState(
      personalities: personalities ?? this.personalities,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TargetPersonalityController extends BaseController<TargetPersonalityState> {
  final CreateTargetPersonality _createTargetPersonalityUseCase;
  final DeleteTargetPersonality _deleteTargetPersonalityUseCase;
  final ReadAllTargetPersonality _readAllTargetPersonalityUseCase;

  TargetPersonalityController({
    required CreateTargetPersonality createTargetPersonalityUseCase,
    required DeleteTargetPersonality deleteTargetPersonalityUseCase,
    required ReadAllTargetPersonality readAllTargetPersonalityUseCase,
  }) : _createTargetPersonalityUseCase = createTargetPersonalityUseCase,
       _deleteTargetPersonalityUseCase = deleteTargetPersonalityUseCase,
       _readAllTargetPersonalityUseCase = readAllTargetPersonalityUseCase,
       super(TargetPersonalityState(personalities: []));

  Future<void> initialize(String targetId) async {
    var personalities = await callMethod<List<TargetPersonality>>(
      () => _readAllTargetPersonalityUseCase.call(targetId),
    );
    state = state.copyWith(personalities: personalities);
  }

  Future<void> create(CreateTargetPersonalityDto createTargetPersonalityDto) async {
    await callMethod<TargetPersonality>(() => _createTargetPersonalityUseCase.call(createTargetPersonalityDto));
    await initialize(createTargetPersonalityDto.targetId);
  }

  Future<void> delete(TargetPersonality targetPersonality) async {
    await callVoidMethod(() => _deleteTargetPersonalityUseCase.call(targetPersonality.id));
    await initialize(targetPersonality.targetId);
  }
}
