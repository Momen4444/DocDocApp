import 'package:flutter/material.dart';
import '../../models/doctor_user.dart';
import '../../services/api_service.dart';
import '../../theme/app_colors.dart';

/// Displays a user card with data from GET /api/Users only.
class UserCard extends StatelessWidget {
  final DoctorUser user;

  const UserCard({super.key, required this.user});

  Color get _roleText =>
      user.role == 'Admin' ? AppColors.roleAdminText : AppColors.roleUserText;
  Color get _roleBg =>
      user.role == 'Admin' ? AppColors.roleAdminBg : AppColors.roleUserBg;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            _Avatar(user: user),
            const SizedBox(width: 14),
            Expanded(
                child:
                    _Details(user: user, roleText: _roleText, roleBg: _roleBg)),
          ],
        ),
      ),
    );
  }
}

// Avatar
class _Avatar extends StatelessWidget {
  final DoctorUser user;
  const _Avatar({required this.user});

  Widget _initials() {
    final i = user.id % AppColors.avatarBg.length;
    return Container(
      width: 54,
      height: 54,
      color: AppColors.avatarBg[i],
      alignment: Alignment.center,
      child: Text(
        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.avatarFg[i],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = ApiService.buildImageUrl(user.profileImagePath);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: url.isNotEmpty
          ? Image.network(
              url,
              width: 54,
              height: 54,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, p) => p == null ? child : _initials(),
              errorBuilder: (_, __, ___) => _initials(),
            )
          : _initials(),
    );
  }
}

// Details
class _Details extends StatelessWidget {
  final DoctorUser user;
  final Color roleText;
  final Color roleBg;
  const _Details(
      {required this.user, required this.roleText, required this.roleBg});

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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: roleBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            user.role,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: roleText),
          ),
        ),
      ],
    );
  }
}
