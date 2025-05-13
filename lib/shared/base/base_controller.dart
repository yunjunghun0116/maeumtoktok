import 'dart:developer';

import 'package:flutter/material.dart';

import '../../core/exceptions/custom_exception.dart';

abstract class BaseController extends ChangeNotifier {
  bool isLoading = false;

  Future<T> callMethod<T>(Future<T> Function() method) async {
    try {
      isLoading = true;
      notifyListeners();
      return await method();
    } on CustomException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> callVoidMethod(Future<void> Function() method) async {
    try {
      isLoading = true;
      notifyListeners();
      await method();
    } on CustomException catch (e) {
      rethrow;
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Stream<T> callStream<T>(Stream<T> Function() method) {
    return method();
  }
}
