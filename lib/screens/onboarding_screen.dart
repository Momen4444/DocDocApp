import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/docdoc_logo.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const DocdocLogo(),
              const SizedBox(height: 20),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/Doctor.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Best Doctor\nAppointment App',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              Text(
                'Manage and schedule all of your medical appointments '
                'easily with Docdoc to get a new experience.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/sign-in'),
                child: const Text('Get Started'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
