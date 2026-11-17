import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class IjevoButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Widget? icon;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;

  const IjevoButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.height = 54,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border, width: 1.5),
          minimumSize: Size.fromHeight(height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          foregroundColor: textColor ?? AppColors.textPrimary,
        ),
        child: _buildChild(),
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: textColor ?? Colors.white,
        elevation: 0,
        minimumSize: Size.fromHeight(height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
      ),
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    final effectiveTextColor = textColor ?? (isOutlined ? AppColors.textPrimary : Colors.white);

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
            data: IconThemeData(color: effectiveTextColor, size: 18),
            child: icon!,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: AppTextStyles.button.copyWith(color: effectiveTextColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: AppTextStyles.button.copyWith(color: effectiveTextColor),
    );
  }
}
