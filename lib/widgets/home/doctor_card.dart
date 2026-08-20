import 'package:flutter/material.dart';
import '../../models/doctor_user.dart';
import '../../theme/app_colors.dart';
import '../user/role_badge.dart';
import '../user/user_avatar.dart';
import '../../screens/user_detail_screen.dart';

/// Displays a user card with data from GET /api/Users only.
class UserCard extends StatelessWidget {
  final DoctorUser user;
  final int currentUserId;
  final String currentRole;

  const UserCard({
    super.key, 
    required this.user,
    required this.currentUserId,
    required this.currentRole,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserDetailScreen(
              user: user,
              currentUserId: currentUserId,
              currentRole: currentRole,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowCard,
                blurRadius: 12,
                offset: Offset(0, 4)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              UserAvatar(user: user),
              const SizedBox(width: 14),
              Expanded(child: _Details(user: user)),
            ],
          ),
        ),
      ),
    );
  }
}

// Details
class _Details extends StatelessWidget {
  final DoctorUser user;
  const _Details({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Text(
          user.email,
          style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        RoleBadge(role: user.role),
      ],
    );
  }
}
