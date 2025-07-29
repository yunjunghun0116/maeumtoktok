import 'package:app/core/exceptions/exception_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../exceptions/custom_exception.dart';

abstract class BaseController<S extends BaseState> extends StateNotifier<S> {
  BaseController(super.state);

  Future<T> callMethod<T>(Future<T> Function() method) async {
    try {
      if (state.isLoading) throw CustomException(ExceptionMessage.progressing);
      state = state.copyWith(isLoading: true) as S;
      return await method();
    } on CustomException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false) as S;
    }
  }

  Future<void> callVoidMethod(Future<void> Function() method) async {
    try {
      if (state.isLoading) throw CustomException(ExceptionMessage.progressing);
      state = state.copyWith(isLoading: true) as S;
      await method();
    } on CustomException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false) as S;
    }
  }

  Stream<T> callStream<T>(Stream<T> Function() method) {
    return method();
  }
}

class BaseState {
  final bool isLoading;

  const BaseState({this.isLoading = false});

  BaseState copyWith({bool? isLoading}) {
    return BaseState(isLoading: isLoading ?? this.isLoading);
  }
}
