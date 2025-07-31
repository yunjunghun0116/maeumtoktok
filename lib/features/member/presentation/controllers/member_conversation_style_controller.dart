import 'package:app/features/member/data/models/create_member_conversation_style_dto.dart';
import 'package:app/features/member/domain/entities/member_conversation_style.dart';
import 'package:app/features/member/domain/usecases/create_member_conversation_style.dart';
import 'package:app/features/member/domain/usecases/delete_member_conversation_style.dart';
import 'package:app/features/member/domain/usecases/read_all_member_conversation_style.dart';

import '../../../../core/base/base_controller.dart';

class MemberConversationStyleState extends BaseState {
  final List<MemberConversationStyle> conversationStyles;

  const MemberConversationStyleState({required this.conversationStyles, super.isLoading});

  bool contains(String keyword) {
    return conversationStyles.any((conversationStyle) => conversationStyle.value == keyword);
  }

  @override
  MemberConversationStyleState copyWith({List<MemberConversationStyle>? conversationStyles, bool? isLoading}) {
    return MemberConversationStyleState(
      conversationStyles: conversationStyles ?? this.conversationStyles,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MemberConversationStyleController extends BaseController<MemberConversationStyleState> {
  final CreateMemberConversationStyle _createMemberConversationStyleUseCase;
  final DeleteMemberConversationStyle _deleteMemberConversationStyleUseCase;
  final ReadAllMemberConversationStyle _readAllMemberConversationStyleUseCase;

  MemberConversationStyleController({
    required CreateMemberConversationStyle createMemberConversationStyleUseCase,
    required DeleteMemberConversationStyle deleteMemberConversationStyleUseCase,
    required ReadAllMemberConversationStyle readAllMemberConversationStyleUseCase,
  }) : _createMemberConversationStyleUseCase = createMemberConversationStyleUseCase,
       _deleteMemberConversationStyleUseCase = deleteMemberConversationStyleUseCase,
       _readAllMemberConversationStyleUseCase = readAllMemberConversationStyleUseCase,
       super(MemberConversationStyleState(conversationStyles: []));

  Future<void> initialize(String memberId) async {
    var conversationStyles = await callMethod<List<MemberConversationStyle>>(
      () => _readAllMemberConversationStyleUseCase.call(memberId),
    );
    state = state.copyWith(conversationStyles: conversationStyles);
  }

  Future<void> create(CreateMemberConversationStyleDto createMemberConversationStyleDto) async {
    await callMethod<MemberConversationStyle>(
      () => _createMemberConversationStyleUseCase.call(createMemberConversationStyleDto),
    );
    await initialize(createMemberConversationStyleDto.memberId);
  }

  Future<void> delete(MemberConversationStyle memberConversationStyle) async {
    await callVoidMethod(() => _deleteMemberConversationStyleUseCase.call(memberConversationStyle.id));
    await initialize(memberConversationStyle.memberId);
  }
}
