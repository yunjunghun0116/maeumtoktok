import 'package:app/features/member/data/models/create_member_personality_dto.dart';
import 'package:app/features/member/domain/entities/member_personality.dart';
import 'package:app/features/member/domain/usecases/create_member_personality.dart';
import 'package:app/features/member/domain/usecases/delete_member_personality.dart';
import 'package:app/features/member/domain/usecases/read_all_member_personality.dart';

import '../../../../core/base/base_controller.dart';

class MemberPersonalityState extends BaseState {
  final List<MemberPersonality> personalities;

  const MemberPersonalityState({required this.personalities, super.isLoading});

  bool contains(String keyword) {
    return personalities.any((personality) => personality.value == keyword);
  }

  @override
  MemberPersonalityState copyWith({List<MemberPersonality>? personalities, bool? isLoading}) {
    return MemberPersonalityState(
      personalities: personalities ?? this.personalities,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MemberPersonalityController extends BaseController<MemberPersonalityState> {
  final CreateMemberPersonality _createMemberPersonalityUseCase;
  final DeleteMemberPersonality _deleteMemberPersonalityUseCase;
  final ReadAllMemberPersonality _readAllMemberPersonalityUseCase;

  MemberPersonalityController({
    required CreateMemberPersonality createMemberPersonalityUseCase,
    required DeleteMemberPersonality deleteMemberPersonalityUseCase,
    required ReadAllMemberPersonality readAllMemberPersonalityUseCase,
  }) : _createMemberPersonalityUseCase = createMemberPersonalityUseCase,
       _deleteMemberPersonalityUseCase = deleteMemberPersonalityUseCase,
       _readAllMemberPersonalityUseCase = readAllMemberPersonalityUseCase,
       super(MemberPersonalityState(personalities: []));

  Future<void> initialize(String memberId) async {
    var personalities = await callMethod<List<MemberPersonality>>(
      () => _readAllMemberPersonalityUseCase.call(memberId),
    );
    state = state.copyWith(personalities: personalities);
  }

  Future<void> create(CreateMemberPersonalityDto createMemberPersonalityDto) async {
    await callMethod<MemberPersonality>(() => _createMemberPersonalityUseCase.call(createMemberPersonalityDto));
    await initialize(createMemberPersonalityDto.memberId);
  }

  Future<void> delete(MemberPersonality memberPersonality) async {
    await callVoidMethod(() => _deleteMemberPersonalityUseCase.call(memberPersonality.id));
    await initialize(memberPersonality.memberId);
  }
}
