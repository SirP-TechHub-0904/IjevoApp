import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/bill_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/back_circle_button.dart';

class BillsHubScreen extends StatelessWidget {
  const BillsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Pay Bills in Nigeria', style: AppTextStyles.h3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildCategoryCard(
            context: context,
            category: BillCategory.airtimeData,
            title: 'Airtime & Internet Data',
            subtitle: 'MTN, Airtel, Glo, 9mobile instant top-up',
            icon: Icons.phone_android,
            color: const Color(0xFF10B981),
          ),
          const SizedBox(height: 14),
          _buildCategoryCard(
            context: context,
            category: BillCategory.electricity,
            title: 'Electricity Prepaid & Postpaid',
            subtitle: 'IKEDC, EKEDC, AEDC, IBEDC instant meter token',
            icon: Icons.bolt,
            color: const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 14),
          _buildCategoryCard(
            context: context,
            category: BillCategory.tvBroadband,
            title: 'Cable TV & Home Internet',
            subtitle: 'DStv, GOtv, StarTimes, Showmax',
            icon: Icons.tv,
            color: const Color(0xFF6366F1),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required BillCategory category,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        context.push('/bills/purchase', extra: category);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
