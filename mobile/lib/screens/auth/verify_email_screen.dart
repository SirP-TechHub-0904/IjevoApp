import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/back_circle_button.dart';
import '../../widgets/ijevo_button.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String email;

  const VerifyEmailScreen({
    super.key,
    this.email = 'ijeoma.uche@example.com',
  });

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _otpController = TextEditingController(text: '384920');
  bool _isLoading = false;
  int _timerSeconds = 45;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    setState(() => _timerSeconds = 45);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _onVerify() async {
    final code = _otpController.text.trim();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit verification code')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    // Log the user in and transition to Dashboard
    await ref.read(authProvider.notifier).login(email: widget.email);

    // Trigger system alert for account verification
    ref.read(notificationProvider.notifier).addNotification(
      title: 'Account Verified! ✅',
      message: 'Your email (${widget.email}) has been verified successfully. Welcome to Ijevo!',
      type: 'security',
    );

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.primary,
          content: Text('Email verified successfully! Welcome to Ijevo.'),
        ),
      );
      context.go('/home');
    }
  }

  void _onResend() {
    if (_timerSeconds > 0) return;
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        content: Text('New 6-digit code sent to ${widget.email}!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Email Verification', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Mail Icon Badge
              Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  color: AppColors.primary,
                  size: 34,
                ),
              ),

              const SizedBox(height: 24),
              Text('Verify Your Email', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'We sent a 6-digit verification code to:\n${widget.email}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 36),
              Text('ENTER 6-DIGIT CODE', style: AppTextStyles.label),
              const SizedBox(height: 10),

              // OTP Input Field
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: AppTextStyles.h1.copyWith(
                  letterSpacing: 14,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '••••••',
                  hintStyle: AppTextStyles.h1.copyWith(
                    letterSpacing: 14,
                    color: AppColors.border,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceSecondary,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Resend Code Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  InkWell(
                    onTap: _timerSeconds == 0 ? _onResend : null,
                    child: Text(
                      _timerSeconds > 0 ? 'Resend in ${_timerSeconds}s' : 'Resend Code',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _timerSeconds > 0 ? AppColors.textSecondary : AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Verify Button
              IjevoButton(
                text: 'Verify & Continue',
                isLoading: _isLoading,
                onPressed: _onVerify,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
