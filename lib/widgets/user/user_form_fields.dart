import 'package:flutter/material.dart';
import '../custom_text_field.dart';
import '../phone_text_field.dart';

class UserFormFields extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController ageCtrl;
  final TextEditingController phoneCtrl;

  const UserFormFields({
    super.key,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.ageCtrl,
    required this.phoneCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: nameCtrl,
          hintText: 'Full Name',
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: emailCtrl,
          hintText: 'Email Address',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: ageCtrl,
          hintText: 'Age',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        PhoneTextField(controller: phoneCtrl),
      ],
    );
  }
}
