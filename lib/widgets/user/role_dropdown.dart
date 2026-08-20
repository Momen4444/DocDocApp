import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class RoleDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const RoleDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          'Role',
          style: TextStyle(
            color: AppColors.textGrey,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.fieldBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'User', child: Text('User')),
                DropdownMenuItem(value: 'Admin', child: Text('Admin')),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
