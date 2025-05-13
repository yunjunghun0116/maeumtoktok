import 'dart:async';

import 'package:app/shared/utils/di_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/exceptions/exception_handler.dart';
import 'core/firebase/firebase_options.dart';
import 'features/main/screens/splash_screen.dart';

final rootStateKey = GlobalKey<NavigatorState>();

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    ExceptionHandler().handleException(details.exception, details.stack, rootStateKey.currentContext);
  };
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    runApp(const MainApp());
  }, (error, stackTrace) => ExceptionHandler().handleException(error, stackTrace, rootStateKey.currentContext));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: DiUtil.dependencyInjection(),
      builder: (context, child) {
        return MaterialApp(
          title: "마음톡톡",
          navigatorKey: rootStateKey,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            if (child == null) return Container();
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
              child: child,
            );
          },
          home: SplashScreen(),
        );
      },
    );
  }
}
