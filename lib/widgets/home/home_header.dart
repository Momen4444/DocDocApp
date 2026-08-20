import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onNotificationTap;
  final VoidCallback onLogout;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.onNotificationTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, $userName! 👋',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'How are you today?',
                  style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          _CircleButton(
              icon: Icons.notifications_none_rounded,
              onTap: onNotificationTap,
              badge: true),
          const SizedBox(width: 8),
          _CircleButton(icon: Icons.logout_rounded, onTap: onLogout),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool badge;

  const _CircleButton(
      {required this.icon, required this.onTap, this.badge = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadowMedium,
                    blurRadius: 10,
                    offset: Offset(0, 4)),
              ],
            ),
            child: Icon(icon, color: AppColors.textGrey, size: 22),
          ),
        ),
        if (badge)
          const Positioned(
            top: 6,
            right: 8,
            child: SizedBox(
              width: 9,
              height: 9,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: AppColors.danger, shape: BoxShape.circle),
              ),
            ),
          ),
      ],
    );
  }
}
