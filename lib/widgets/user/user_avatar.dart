import 'package:flutter/material.dart';
import '../../models/doctor_user.dart';
import '../../services/api_service.dart';
import '../../theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final DoctorUser user;
  final double size;

  const UserAvatar({
    super.key,
    required this.user,
    this.size = 54.0, // Default size used in cards
  });

  Widget _buildInitials() {
    final i = user.id % AppColors.avatarBg.length;
    return Container(
      width: size,
      height: size,
      color: AppColors.avatarBg[i],
      alignment: Alignment.center,
      child: Text(
        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: size * 0.45,
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
      borderRadius: BorderRadius.circular(size * 0.22), // Scale border radius with size
      child: url.isNotEmpty
          ? Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, p) => p == null ? child : _buildInitials(),
              errorBuilder: (_, __, ___) => _buildInitials(),
            )
          : _buildInitials(),
    );
  }
}
