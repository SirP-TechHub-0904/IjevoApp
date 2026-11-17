import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final UserProfile user;
  final double size;
  final bool showEditBadge;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    required this.user,
    this.size = 56,
    this.showEditBadge = false,
    this.onTap,
  });

  static IconData getIconData(String name) {
    switch (name) {
      case 'shield':
        return Icons.shield_rounded;
      case 'diamond':
        return Icons.diamond_rounded;
      case 'rocket':
        return Icons.rocket_launch_rounded;
      case 'savings':
        return Icons.savings_rounded;
      case 'public':
        return Icons.public_rounded;
      case 'star':
        return Icons.stars_rounded;
      case 'bolt':
        return Icons.bolt_rounded;
      case 'credit_card':
        return Icons.credit_card_rounded;
      case 'badge':
        return Icons.workspace_premium_rounded;
      case 'crown':
        return Icons.military_tech_rounded;
      case 'person':
      default:
        return Icons.person_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Color(user.avatarBgColor);

    Widget avatarContent;

    if (user.avatarType == 'icon') {
      avatarContent = Icon(
        getIconData(user.avatarIconName),
        color: Colors.white,
        size: size * 0.55,
      );
    } else if (user.avatarType == 'photo' && user.avatarPhotoPath != null) {
      avatarContent = ClipOval(
        child: Image.network(
          user.avatarPhotoPath!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.person,
            color: Colors.white,
            size: size * 0.55,
          ),
        ),
      );
    } else {
      // Default: Initials
      avatarContent = Text(
        user.initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.38,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final avatarWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: avatarContent,
    );

    if (!showEditBadge && onTap == null) {
      return avatarWidget;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatarWidget,
          if (showEditBadge)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.35,
                height: size * 0.35,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: size * 0.2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
