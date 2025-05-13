import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../../shared/constants/app_colors.dart';
import 'custom_exception.dart';

class ExceptionHandler {
  static final ExceptionHandler _instance = ExceptionHandler._internal();

  factory ExceptionHandler() => _instance;

  ExceptionHandler._internal();

  void handleException(Object error, StackTrace? stackTrace, BuildContext? context) {
    log("StackTrace : ${stackTrace.toString()}");
    if (error.runtimeType == CustomException) {
      var customException = error as CustomException;
      log("에러 발생(${customException.exception.statusCode}) : ${customException.exception.description}");
      if (context != null) {
        showException(context, message: customException.exception.description);
      }
      return;
    }
    log("시스템 내부 에러 발생 : $error, StackTrace : $stackTrace");
  }

  void showException(BuildContext context, {required String message}) {
    var flushBar = Flushbar(
      backgroundColor: AppColors.flushBarBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      flushbarPosition: FlushbarPosition.TOP,
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.whiteColor, fontSize: 14),
      ),
      duration: const Duration(seconds: 2),
    );
    Future.delayed(Duration.zero, () {
      if (!context.mounted) return;
      flushBar.show(context);
    });
  }
}
