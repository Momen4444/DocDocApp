import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_auth_row.dart';
import '../widgets/phone_text_field.dart';
import '../widgets/loading_button.dart';
import '../widgets/auth_redirect_text.dart';
import '../services/api_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text('Create Account', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Sign up now and start exploring all that our app has to '
                "offer. We're excited to welcome you to our community!",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 28),
              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                isPassword: true,
              ),
              const SizedBox(height: 14),
              PhoneTextField(controller: _phoneController),
              const SizedBox(height: 24),
              LoadingButton(
                text: 'Create Account',
                isLoading: _isLoading,
                onPressed: () async {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text;
                  final phone = _phoneController.text.trim();

                  if (email.isEmpty || password.isEmpty || phone.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all fields')),
                    );
                    return;
                  }

                  if (!RegExp(r'^\d{11}$').hasMatch(phone)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Phone number must be exactly 11 digits')),
                    );
                    return;
                  }

                  setState(() => _isLoading = true);

                  final result = await ApiService.register(
                    email: email, 
                    password: password, 
                    phone: phone
                  );

                  if (context.mounted) {
                    setState(() => _isLoading = false);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message']),
                        backgroundColor: result['success'] ? Colors.green : Colors.red,
                      ),
                    );

                    if (result['success']) {
                      Navigator.pushReplacementNamed(context, '/sign-in');
                    }
                  }
                },
              ),
              const SizedBox(height: 28),
              const SocialAuthRow(),
              const SizedBox(height: 24),
              AuthRedirectText(
                text: 'Already have an account? ',
                actionText: 'Sign In',
                onTap: () => Navigator.pushReplacementNamed(context, '/sign-in'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}


