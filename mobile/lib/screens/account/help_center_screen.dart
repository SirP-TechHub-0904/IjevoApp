import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/back_circle_button.dart';
import '../../widgets/ijevo_button.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _faqs = [
    {
      'q': 'How long does a transfer take?',
      'a': 'Transfers to Nigerian and African bank accounts or mobile wallets are delivered within 5 minutes directly via our instant clearing rails.'
    },
    {
      'q': 'Are there any hidden fees?',
      'a': 'Never. Ijevo charges £0.00 transfer fees. You only pay the guaranteed live exchange rate displayed before you confirm.'
    },
    {
      'q': 'How do I add a new recipient?',
      'a': 'Tap "Send Money", pick the destination country, and select "Add a new recipient". You can enter a bank account or mobile money phone number.'
    },
    {
      'q': 'How does the £20 referral bonus work?',
      'a': 'Share your unique invite code with friends. When they register and complete their first transfer of £50 or more, you automatically receive £20 in your GBP wallet.'
    },
    {
      'q': 'Is my money safe with Ijevo?',
      'a': 'Yes. All customer funds are safeguarded in dedicated Tier-1 bank accounts and fully protected.'
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Help & Support', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search help articles...',
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
              ),
            ),

            const SizedBox(height: 24),
            Text('FREQUENTLY ASKED QUESTIONS', style: AppTextStyles.label),
            const SizedBox(height: 12),

            ..._faqs.map((faq) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    shape: const Border(),
                    collapsedShape: const Border(),
                    iconColor: AppColors.primary,
                    collapsedIconColor: AppColors.textSecondary,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: Text(
                      faq['q']!,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          faq['a']!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),
            Text('STILL NEED HELP?', style: AppTextStyles.label),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Text('Our 24/7 customer support team is always here for you.', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 16),
                  IjevoButton(
                    text: 'Chat on WhatsApp',
                    backgroundColor: const Color(0xFF25D366),
                    icon: const Icon(Icons.chat, color: Colors.white, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening WhatsApp support chat...')),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  IjevoButton(
                    text: 'Email support@ijevo.com',
                    isOutlined: true,
                    icon: const Icon(Icons.email_outlined, color: AppColors.textPrimary, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email support triggered: support@ijevo.com')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    ),
  );
  }
}
