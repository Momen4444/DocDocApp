import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class RoleBadge extends StatelessWidget {
  final String role;

  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'Admin';
    final roleBg = isAdmin ? AppColors.roleAdminBg : AppColors.roleUserBg;
    final roleText = isAdmin ? AppColors.roleAdminText : AppColors.roleUserText;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: roleBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: roleText,
        ),
      ),
    );
  }
}
