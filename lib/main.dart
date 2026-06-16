import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smwkp_culinary_tourism/core/theme/app_theme.dart';
import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';
import 'package:smwkp_culinary_tourism/providers/app_providers.dart';
import 'package:smwkp_culinary_tourism/screens/auth/login_screen.dart';
import 'package:smwkp_culinary_tourism/services/push_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      print('FlutterError: ${details.exceptionAsString()}');
      print(details.stack ?? 'No stack trace available');
    }
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Text(
          'Error: ${details.exceptionAsString()}',
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  };

  runZonedGuarded(
    () => runApp(const MyApp()),
    (error, stackTrace) {
      if (kDebugMode) {
        print('Unhandled error: $error');
        print(stackTrace);
      }
    },
  );

  // Initialize push notifications after app launch.
  // This avoids startup blocking if Firebase Messaging isn't configured yet.
  PushNotificationService.initialize().catchError((error, stackTrace) {
    if (kDebugMode) {
      print('PushNotificationService failed: $error');
      print(stackTrace);
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getAppProviders(),
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: AppTheme.lightTheme,
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate initialization
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Check if user is logged in (you can add actual auth check here)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: 80,
              color: AppColors.white,
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: AppFontSize.xxxl,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Sistem Manajemen Wisata Kuliner',
              style: TextStyle(
                fontSize: AppFontSize.md,
                color: AppColors.white,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: AppSpacing.xxl),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}

