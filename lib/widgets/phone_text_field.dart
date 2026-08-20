import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Country-code + phone number compound field.
class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🇬🇧', style: TextStyle(fontSize: 18)),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textGrey),
              ],
            ),
          ),
          Container(width: 1, height: 24, color: AppColors.fieldBorder),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Your number',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
