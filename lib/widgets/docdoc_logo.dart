import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The "Docdoc" wordmark (icon + text) used on the splash and
/// onboarding screens. Pulled into its own widget because it's a
/// component instance in Figma, not a one-off — the same rule applies
/// in Flutter: anything reused across frames becomes a reusable widget,
/// not copy-pasted markup.
class DocdocLogo extends StatelessWidget {
  final double fontSize;
  final double iconSize;

  const DocdocLogo({super.key, this.fontSize = 24, this.iconSize = 28});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/Logo.png', height: iconSize, fit: BoxFit.contain),
        const SizedBox(width: 8),
        Text(
          'Docdoc',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
