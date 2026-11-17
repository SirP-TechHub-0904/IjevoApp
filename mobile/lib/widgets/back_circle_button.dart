import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BackCircleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;

  const BackCircleButton({
    super.key,
    this.onPressed,
    this.icon = Icons.arrow_back,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () => Navigator.of(context).maybePop(),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.surfaceSecondary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
