import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/ijevo_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isNavigating = false;

  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'Fast & Borderless\nMoney Transfers',
      'subtitle':
          'Send money to Nigeria, Ghana, Kenya, and worldwide with zero hidden fees and unbeatable live exchange rates.',
      'icon': Icons.send_rounded,
      'color': AppColors.primary,
    },
    {
      'title': 'Multi-Currency Wallets\nin Your Pocket',
      'subtitle':
          'Hold, convert, and manage GBP, NGN, EUR, and CAD in one place. Swap currencies instantly at real-time rates.',
      'icon': Icons.account_balance_wallet_rounded,
      'color': AppColors.navy,
    },
    {
      'title': '1-Tap Bank & Card\nDebit Payments',
      'subtitle':
          'Link your UK bank account with Open Banking or link your debit card to fund transfers in seconds with 3D Secure.',
      'icon': Icons.credit_card_rounded,
      'color': const Color(0xFF1E40AF),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).completeOnboarding();
              if (mounted) {
                context.go('/login');
              }
            },
            child: Text(
              'Skip',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // PageView Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (idx) {
                  setState(() => _currentPage = idx);
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Graphic Icon Container
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: (slide['color'] as Color).withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: (slide['color'] as Color).withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: slide['color'] as Color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (slide['color'] as Color).withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                slide['icon'] as IconData,
                                color: Colors.white,
                                size: 44,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Title
                        Text(
                          slide['title'] as String,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h1.copyWith(
                            fontSize: 26,
                            height: 1.25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Subtitle
                        Text(
                          slide['subtitle'] as String,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  IjevoButton(
                    text: _currentPage == _slides.length - 1 ? 'Get Started' : 'Continue',
                    isLoading: _isNavigating,
                    onPressed: _isNavigating
                        ? null
                        : () async {
                            if (_currentPage < _slides.length - 1) {
                              await _pageController.nextPage(
                                duration: const Duration(milliseconds: 280),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              setState(() => _isNavigating = true);
                              await ref.read(authProvider.notifier).completeOnboarding();
                              if (mounted) {
                                context.go('/signup');
                              }
                            }
                          },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                      InkWell(
                        onTap: () async {
                          await ref.read(authProvider.notifier).completeOnboarding();
                          if (mounted) {
                            context.go('/login');
                          }
                        },
                        child: Text(
                          'Log In',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
