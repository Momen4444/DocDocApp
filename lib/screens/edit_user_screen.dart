import 'package:flutter/material.dart';
import '../../models/doctor_user.dart';
import '../../services/api_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/loading_button.dart';
import '../../widgets/user/role_dropdown.dart';
import '../../widgets/user/user_form_fields.dart';

class EditUserScreen extends StatefulWidget {
  final DoctorUser user;
  final String currentRole;

  const EditUserScreen({
    super.key,
    required this.user,
    required this.currentRole,
  });

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _ageCtrl;
  late final TextEditingController _phoneCtrl;

  String _selectedRole = 'User';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.name);
    _emailCtrl = TextEditingController(text: widget.user.email);
    _ageCtrl = TextEditingController(text: widget.user.age.toString());
    _phoneCtrl = TextEditingController(text: widget.user.mobileNumber);
    _selectedRole = widget.user.role;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _ageCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final ageStr = _ageCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();

    if (name.isEmpty || email.isEmpty || ageStr.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final age = int.tryParse(ageStr);
    if (age == null || age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid age')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final Map<String, dynamic> body = {
      'id': widget.user.id,
      'name': name,
      'email': email,
      'age': age,
      'mobileNumber': phone,
      'role': _selectedRole,
    };

    final res = await ApiService.updateUser(widget.user.id, body);

    if (mounted) {
      setState(() => _isLoading = false);
      if (res['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: AppColors.success),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(res['message'] ?? 'Failed to update profile'),
              backgroundColor: AppColors.danger),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = widget.currentRole == 'Admin';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserFormFields(
              nameCtrl: _nameCtrl,
              emailCtrl: _emailCtrl,
              ageCtrl: _ageCtrl,
              phoneCtrl: _phoneCtrl,
            ),
            const SizedBox(height: 16),
            if (isAdmin) ...[
              RoleDropdown(
                value: _selectedRole,
                onChanged: (val) {
                  if (val != null) setState(() => _selectedRole = val);
                },
              ),
            ],
            const SizedBox(height: 32),
            LoadingButton(
              text: 'Save Changes',
              isLoading: _isLoading,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
