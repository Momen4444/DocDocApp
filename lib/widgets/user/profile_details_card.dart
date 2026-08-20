import 'package:flutter/material.dart';
import '../../models/doctor_user.dart';
import '../../theme/app_colors.dart';

class ProfileDetailsCard extends StatelessWidget {
  final DoctorUser user;

  const ProfileDetailsCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: AppColors.shadowLight, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(icon: Icons.email_outlined, label: 'Email', value: user.email),
          const Divider(height: 32, color: AppColors.fieldBorder),
          _InfoRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: user.mobileNumber),
          const Divider(height: 32, color: AppColors.fieldBorder),
          _InfoRow(
              icon: Icons.cake_outlined,
              label: 'Age',
              value: '${user.age} years old'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textGrey)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
