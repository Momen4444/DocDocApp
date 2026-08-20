import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_colors.dart';

/// The "Or sign in with" divider + Google / Facebook / Apple circles,
/// shared by the Sign In and Sign Up screens.
///
/// Uses font_awesome_flutter for recognizable brand marks instead of
/// Material's generic icons. Run `flutter pub add font_awesome_flutter`
/// if it isn't already in your pubspec.yaml.
class SocialAuthRow extends StatelessWidget {
  final VoidCallback? onGoogleTap;
  final VoidCallback? onFacebookTap;
  final VoidCallback? onAppleTap;

  const SocialAuthRow({
    super.key,
    this.onGoogleTap,
    this.onFacebookTap,
    this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider(color: AppColors.fieldBorder)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Or sign in with',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
            ),
            Expanded(child: Divider(color: AppColors.fieldBorder)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialCircle(icon: FontAwesomeIcons.google, onTap: onGoogleTap),
            const SizedBox(width: 16),
            _SocialCircle(icon: FontAwesomeIcons.facebookF, onTap: onFacebookTap),
            const SizedBox(width: 16),
            _SocialCircle(icon: FontAwesomeIcons.apple, onTap: onAppleTap),
          ],
        ),
      ],
    );
  }
}

class _SocialCircle extends StatelessWidget {
  final dynamic icon;
  final VoidCallback? onTap;

  const _SocialCircle({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap ?? () {},
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          side: const BorderSide(color: AppColors.fieldBorder),
        ),
        child: FaIcon(icon, size: 18, color: AppColors.textDark),
      ),
    );
  }
}
