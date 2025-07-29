import 'package:app/features/member/data/repositories/member_repository_impl.dart';
import 'package:app/features/member/domain/repositories/member_repository.dart';
import 'package:app/features/member/domain/usecases/update_member.dart';
import 'package:app/features/member/presentation/controllers/member_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Repository Providers ---
final memberRepositoryProvider = Provider<MemberRepository>((ref) => MemberRepositoryImpl());

// --- UseCases Providers ---
final updateMemberUseCaseProvider = Provider<UpdateMember>((ref) {
  var memberRepository = ref.watch(memberRepositoryProvider);
  return UpdateMember(memberRepository: memberRepository);
});

// --- Controller Providers ---
final memberControllerProvider = StateNotifierProvider<MemberController, MemberState>((ref) {
  var updateMember = ref.watch(updateMemberUseCaseProvider);
  return MemberController(updateMemberUseCase: updateMember);
});
