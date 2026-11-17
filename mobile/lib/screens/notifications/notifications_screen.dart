import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/notification_model.dart';
import '../../providers/notification_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/back_circle_button.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  int _selectedFilter = 0; // 0: All, 1: Unread, 2: Read

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'transfer':
        return Icons.check_circle_rounded;
      case 'referral':
        return Icons.card_giftcard_rounded;
      case 'card':
        return Icons.credit_card_rounded;
      case 'security':
        return Icons.shield_rounded;
      case 'rate':
        return Icons.trending_up_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'transfer':
        return AppColors.primary; // Emerald green
      case 'referral':
        return const Color(0xFF8B5CF6); // Purple
      case 'card':
        return const Color(0xFF2563EB); // Royal Blue
      case 'security':
        return const Color(0xFFF59E0B); // Amber
      case 'rate':
        return const Color(0xFF0D9488); // Teal
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifState = ref.watch(notificationProvider);
    final unreadCount = notifState.unreadCount;

    List<AppNotification> displayedItems;
    if (_selectedFilter == 1) {
      displayedItems = notifState.unreadItems;
    } else if (_selectedFilter == 2) {
      displayedItems = notifState.readItems;
    } else {
      displayedItems = notifState.items;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Notifications', style: AppTextStyles.h3),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () {
                ref.read(notificationProvider.notifier).markAllAsRead();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications marked as read'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Mark all read',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Tabs (All / Unread / Read)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    _buildTabButton(
                      index: 0,
                      label: 'All (${notifState.items.length})',
                    ),
                    _buildTabButton(
                      index: 1,
                      label: 'Unread ($unreadCount)',
                      highlight: unreadCount > 0,
                    ),
                    _buildTabButton(
                      index: 2,
                      label: 'Read (${notifState.readItems.length})',
                    ),
                  ],
                ),
              ),
            ),

            // Notification List or Empty State
            Expanded(
              child: displayedItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
                      itemCount: displayedItems.length,
                      itemBuilder: (context, index) {
                        final notif = displayedItems[index];
                        return _buildNotificationCard(notif);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required String label,
    bool highlight = false,
  }) {
    final isSelected = _selectedFilter == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFilter = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.navy : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isSelected
                  ? Colors.white
                  : (highlight ? AppColors.primary : AppColors.textSecondary),
              fontWeight: isSelected || highlight ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notif) {
    final color = _getTypeColor(notif.type);
    final icon = _getTypeIcon(notif.type);

    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 26),
      ),
      onDismissed: (_) {
        ref.read(notificationProvider.notifier).deleteNotification(notif.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification dismissed'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: notif.isRead ? Colors.white : const Color(0xFFF9FBFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notif.isRead ? AppColors.border : AppColors.primary.withOpacity(0.4),
            width: notif.isRead ? 1 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            ref.read(notificationProvider.notifier).markAsRead(notif.id);
            if (notif.route != null && notif.route!.isNotEmpty) {
              context.push(notif.route!);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 14),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notif.title,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            _formatTime(notif.timestamp),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif.message,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: notif.isRead ? AppColors.textSecondary : AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Unread indicator dot
                if (!notif.isRead) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read_rounded,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _selectedFilter == 1 ? 'You\'re All Caught Up!' : 'No Notifications',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 8),
            Text(
              _selectedFilter == 1
                  ? 'There are no unread notifications right now.'
                  : 'You will receive alerts here about transfers, card updates, and exchange rates.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
