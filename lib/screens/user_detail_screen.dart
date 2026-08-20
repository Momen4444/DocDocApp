import 'package:flutter/material.dart';
import '../../models/doctor_user.dart';
import '../../services/api_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/user/profile_details_card.dart';
import '../../widgets/user/role_badge.dart';
import '../../widgets/user/user_avatar.dart';
import 'edit_user_screen.dart';

class UserDetailScreen extends StatefulWidget {
  final DoctorUser user;
  final int currentUserId;
  final String currentRole;

  const UserDetailScreen({
    super.key,
    required this.user,
    required this.currentUserId,
    required this.currentRole,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late DoctorUser _user;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  bool get _canEdit =>
      widget.currentRole == 'Admin' || widget.currentUserId == _user.id;

  bool get _canDelete => widget.currentRole == 'Admin';

  Future<void> _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${_user.name}? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textGrey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isDeleting = true);

    final res = await ApiService.deleteUser(_user.id);
    
    if (mounted) {
      setState(() => _isDeleting = false);
      if (res['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully'), backgroundColor: AppColors.success),
        );
        Navigator.pop(context, true); // Return true to signal a refresh is needed
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Failed to delete'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  void _handleEdit() async {
    final didUpdate = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditUserScreen(
          user: _user,
          currentRole: widget.currentRole,
        ),
      ),
    );

    if (didUpdate == true && mounted) {
      // Refresh the profile data
      final res = await ApiService.getUserById(_user.id);
      if (res['success'] && mounted) {
        setState(() {
          _user = DoctorUser.fromJson(res['data']);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_canEdit)
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: AppColors.primary),
              onPressed: _handleEdit,
            ),
          if (_canDelete)
            IconButton(
              icon: _isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.danger))
                  : const Icon(Icons.delete_rounded, color: AppColors.danger),
              onPressed: _isDeleting ? null : _handleDelete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            UserAvatar(
              user: _user,
              size: 120.0,
            ),
            const SizedBox(height: 24),
            // Name
            Text(
              _user.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            RoleBadge(role: _user.role),
            const SizedBox(height: 32),
            // Details Card
            ProfileDetailsCard(user: _user),
          ],
        ),
      ),
    );
  }
}
