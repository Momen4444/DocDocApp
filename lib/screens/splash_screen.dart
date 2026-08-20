import 'package:flutter/material.dart';
import '../widgets/docdoc_logo.dart';
import '../services/local_storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Give the splash screen a 2 second delay for branding
    await Future.delayed(const Duration(seconds: 2));

    final token = await LocalStorageService.getToken();

    if (mounted) {
      if (token != null) {
        // User has a valid token, skip login!
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // No token, send to onboarding
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: DocdocLogo(fontSize: 28, iconSize: 32),
      ),
    );
  }
}
