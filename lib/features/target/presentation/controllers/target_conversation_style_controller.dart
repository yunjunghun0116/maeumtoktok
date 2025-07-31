import 'package:app/features/target/data/models/create_target_conversation_style_dto.dart';
import 'package:app/features/target/domain/entities/target_conversation_style.dart';
import 'package:app/features/target/domain/usecases/create_target_conversation_style.dart';
import 'package:app/features/target/domain/usecases/delete_target_conversation_style.dart';
import 'package:app/features/target/domain/usecases/read_all_target_conversation_style.dart';

import '../../../../core/base/base_controller.dart';

class TargetConversationStyleState extends BaseState {
  final List<TargetConversationStyle> conversationStyles;

  const TargetConversationStyleState({required this.conversationStyles, super.isLoading});

  bool contains(String keyword) {
    return conversationStyles.any((conversationStyle) => conversationStyle.value == keyword);
  }

  @override
  TargetConversationStyleState copyWith({List<TargetConversationStyle>? conversationStyles, bool? isLoading}) {
    return TargetConversationStyleState(
      conversationStyles: conversationStyles ?? this.conversationStyles,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TargetConversationStyleController extends BaseController<TargetConversationStyleState> {
  final CreateTargetConversationStyle _createTargetConversationStyleUseCase;
  final DeleteTargetConversationStyle _deleteTargetConversationStyleUseCase;
  final ReadAllTargetConversationStyle _readAllTargetConversationStyleUseCase;

  TargetConversationStyleController({
    required CreateTargetConversationStyle createTargetConversationStyleUseCase,
    required DeleteTargetConversationStyle deleteTargetConversationStyleUseCase,
    required ReadAllTargetConversationStyle readAllTargetConversationStyleUseCase,
  }) : _createTargetConversationStyleUseCase = createTargetConversationStyleUseCase,
       _deleteTargetConversationStyleUseCase = deleteTargetConversationStyleUseCase,
       _readAllTargetConversationStyleUseCase = readAllTargetConversationStyleUseCase,
       super(TargetConversationStyleState(conversationStyles: []));

  Future<void> initialize(String targetId) async {
    var conversationStyles = await callMethod<List<TargetConversationStyle>>(
      () => _readAllTargetConversationStyleUseCase.call(targetId),
    );
    state = state.copyWith(conversationStyles: conversationStyles);
  }

  Future<void> create(CreateTargetConversationStyleDto createTargetConversationStyleDto) async {
    await callMethod<TargetConversationStyle>(
      () => _createTargetConversationStyleUseCase.call(createTargetConversationStyleDto),
    );
    await initialize(createTargetConversationStyleDto.targetId);
  }

  Future<void> delete(TargetConversationStyle targetConversationStyle) async {
    await callVoidMethod(() => _deleteTargetConversationStyleUseCase.call(targetConversationStyle.id));
    await initialize(targetConversationStyle.targetId);
  }
}
