import 'package:app/core/providers.dart';
import 'package:app/features/member/data/repositories/member_conversation_style_repository_impl.dart';
import 'package:app/features/member/data/repositories/member_personality_repository_impl.dart';
import 'package:app/features/member/data/repositories/member_repository_impl.dart';
import 'package:app/features/member/domain/repositories/member_conversation_style_repository.dart';
import 'package:app/features/member/domain/repositories/member_personality_repository.dart';
import 'package:app/features/member/domain/repositories/member_repository.dart';
import 'package:app/features/member/domain/usecases/create_member_conversation_style.dart';
import 'package:app/features/member/domain/usecases/create_member_personality.dart';
import 'package:app/features/member/domain/usecases/delete_member_conversation_style.dart';
import 'package:app/features/member/domain/usecases/delete_member_personality.dart';
import 'package:app/features/member/domain/usecases/read_all_member_conversation_style.dart';
import 'package:app/features/member/domain/usecases/read_all_member_personality.dart';
import 'package:app/features/member/domain/usecases/update_member.dart';
import 'package:app/features/member/presentation/controllers/member_controller.dart';
import 'package:app/features/member/presentation/controllers/member_conversation_style_controller.dart';
import 'package:app/features/member/presentation/controllers/member_personality_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Repository Providers ---
final memberRepositoryProvider = Provider<MemberRepository>((ref) => MemberRepositoryImpl());
final memberPersonalityRepositoryProvider = Provider<MemberPersonalityRepository>(
  (ref) => MemberPersonalityRepositoryImpl(),
);
final memberConversationStyleRepositoryProvider = Provider<MemberConversationStyleRepository>(
  (ref) => MemberConversationStyleRepositoryImpl(),
);

// --- UseCases Providers ---
final updateMemberUseCaseProvider = Provider<UpdateMember>((ref) {
  var memberRepository = ref.watch(memberRepositoryProvider);
  return UpdateMember(memberRepository: memberRepository);
});

final createMemberPersonalityUseCaseProvider = Provider<CreateMemberPersonality>((ref) {
  var sequenceRepository = ref.watch(sequenceRepositoryProvider);
  var memberPersonalityRepository = ref.watch(memberPersonalityRepositoryProvider);
  return CreateMemberPersonality(
    sequenceRepository: sequenceRepository,
    memberPersonalityRepository: memberPersonalityRepository,
  );
});

final deleteMemberPersonalityUseCaseProvider = Provider<DeleteMemberPersonality>((ref) {
  var memberPersonalityRepository = ref.watch(memberPersonalityRepositoryProvider);
  return DeleteMemberPersonality(memberPersonalityRepository: memberPersonalityRepository);
});

final readAllMemberPersonalityUseCaseProvider = Provider<ReadAllMemberPersonality>((ref) {
  var memberPersonalityRepository = ref.watch(memberPersonalityRepositoryProvider);
  return ReadAllMemberPersonality(memberPersonalityRepository: memberPersonalityRepository);
});

final createMemberConversationStyleUseCaseProvider = Provider<CreateMemberConversationStyle>((ref) {
  var sequenceRepository = ref.watch(sequenceRepositoryProvider);
  var memberConversationStyleRepository = ref.watch(memberConversationStyleRepositoryProvider);
  return CreateMemberConversationStyle(
    sequenceRepository: sequenceRepository,
    memberConversationStyleRepository: memberConversationStyleRepository,
  );
});

final deleteMemberConversationStyleUseCaseProvider = Provider<DeleteMemberConversationStyle>((ref) {
  var memberConversationStyleRepository = ref.watch(memberConversationStyleRepositoryProvider);
  return DeleteMemberConversationStyle(memberConversationStyleRepository: memberConversationStyleRepository);
});

final readAllMemberConversationStyleUseCaseProvider = Provider<ReadAllMemberConversationStyle>((ref) {
  var memberConversationStyleRepository = ref.watch(memberConversationStyleRepositoryProvider);
  return ReadAllMemberConversationStyle(memberConversationStyleRepository: memberConversationStyleRepository);
});

// --- Controller Providers ---
final memberControllerProvider = StateNotifierProvider<MemberController, MemberState>((ref) {
  var updateMember = ref.watch(updateMemberUseCaseProvider);
  return MemberController(updateMemberUseCase: updateMember);
});

final memberPersonalityControllerProvider = StateNotifierProvider<MemberPersonalityController, MemberPersonalityState>((
  ref,
) {
  var createMemberPersonality = ref.watch(createMemberPersonalityUseCaseProvider);
  var deleteMemberPersonality = ref.watch(deleteMemberPersonalityUseCaseProvider);
  var readAllMembertPersonality = ref.watch(readAllMemberPersonalityUseCaseProvider);
  return MemberPersonalityController(
    createMemberPersonalityUseCase: createMemberPersonality,
    deleteMemberPersonalityUseCase: deleteMemberPersonality,
    readAllMemberPersonalityUseCase: readAllMembertPersonality,
  );
});

final memberConversationStyleControllerProvider =
    StateNotifierProvider<MemberConversationStyleController, MemberConversationStyleState>((ref) {
      var createMemberConversationStyle = ref.watch(createMemberConversationStyleUseCaseProvider);
      var deleteMemberConversationStyle = ref.watch(deleteMemberConversationStyleUseCaseProvider);
      var readAllMemberConversationStyle = ref.watch(readAllMemberConversationStyleUseCaseProvider);
      return MemberConversationStyleController(
        createMemberConversationStyleUseCase: createMemberConversationStyle,
        deleteMemberConversationStyleUseCase: deleteMemberConversationStyle,
        readAllMemberConversationStyleUseCase: readAllMemberConversationStyle,
      );
    });
