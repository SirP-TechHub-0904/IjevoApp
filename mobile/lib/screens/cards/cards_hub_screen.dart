import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/back_circle_button.dart';
import '../../widgets/ijevo_button.dart';

class CardsHubScreen extends StatefulWidget {
  const CardsHubScreen({super.key});

  @override
  State<CardsHubScreen> createState() => _CardsHubScreenState();
}

class _CardsHubScreenState extends State<CardsHubScreen> {
  bool _isFrozen = false;
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Ijevo Cards', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
          children: [
            // Realistic Ijevo Visa Card Mockup
            Container(
              height: 210,
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isFrozen
                      ? [const Color(0xFF64748B), const Color(0xFF475569)]
                      : [const Color(0xFF00D084), const Color(0xFF0B192C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (_isFrozen ? Colors.grey : AppColors.primary).withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.credit_card, color: Colors.white, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            'ijevo',
                            style: AppTextStyles.h2.copyWith(color: Colors.white, letterSpacing: 1),
                          ),
                        ],
                      ),
                      const Icon(Icons.contactless, color: Colors.white, size: 28),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withOpacity(0.85),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        _showDetails ? '4532  8901  2345  9021' : '••••  ••••  ••••  9021',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CARDHOLDER',
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.white70, fontSize: 10),
                          ),
                          Text(
                            'IJEOMA UCHE',
                            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EXPIRES',
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.white70, fontSize: 10),
                          ),
                          Text(
                            _showDetails ? '09/28' : '••/••',
                            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Text(
                        'VISA',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Card Quick Controls
            Row(
              children: [
                Expanded(
                  child: _buildQuickControl(
                    icon: _isFrozen ? Icons.lock_open : Icons.lock_outline,
                    label: _isFrozen ? 'Unfreeze' : 'Freeze Card',
                    onTap: () {
                      setState(() => _isFrozen = !_isFrozen);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isFrozen ? 'Card has been frozen.' : 'Card is now active.'),
                          backgroundColor: _isFrozen ? AppColors.navy : AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickControl(
                    icon: _showDetails ? Icons.visibility_off : Icons.visibility,
                    label: _showDetails ? 'Hide' : 'View Details',
                    onTap: () => setState(() => _showDetails = !_showDetails),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickControl(
                    icon: Icons.pin_outlined,
                    label: 'Card PIN',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Your Card PIN is: 8492')),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Order Card Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Need a Physical Card?', style: AppTextStyles.h3),
                  const SizedBox(height: 6),
                  Text(
                    'Get a sleek matte-finish debit card delivered to your UK address in 3-5 business days. Spend anywhere Visa is accepted worldwide with zero foreign transaction fees.',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  IjevoButton(
                    text: 'Order Physical Card (£5.99)',
                    isOutlined: true,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Physical card order initiated! Delivery to 42 Highfield Road, London.'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildQuickControl({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 6),
            Text(label, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
