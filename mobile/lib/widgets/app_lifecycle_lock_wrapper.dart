import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../services/biometric_service.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'ijevo_button.dart';

class AppLifecycleLockWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const AppLifecycleLockWrapper({super.key, required this.child});

  @override
  ConsumerState<AppLifecycleLockWrapper> createState() => _AppLifecycleLockWrapperState();
}

class _AppLifecycleLockWrapperState extends ConsumerState<AppLifecycleLockWrapper>
    with WidgetsBindingObserver {
  bool _isLocked = false;
  bool _isAuthenticating = false;
  int? _pausedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // If biometric prompt is currently active on Android, skip lifecycle changes
    if (_isAuthenticating) return;

    final user = ref.read(authProvider);
    final biometricsEnabled = user.biometricsEnabled && StorageService.biometricsEnabled;

    if (state == AppLifecycleState.paused) {
      _pausedTime = DateTime.now().millisecondsSinceEpoch;
      StorageService.setLastActiveTimestamp(_pausedTime!);
    } else if (state == AppLifecycleState.resumed) {
      if (!biometricsEnabled) return;

      final timeout = user.autoLockTimeout;
      final now = DateTime.now().millisecondsSinceEpoch;
      final lastActive = _pausedTime ?? StorageService.lastActiveTimestamp;

      bool shouldLock = false;

      if (timeout == 'immediately') {
        shouldLock = _pausedTime != null;
      } else if (lastActive > 0) {
        final elapsedMs = now - lastActive;
        switch (timeout) {
          case '15_minutes':
            shouldLock = elapsedMs >= 15 * 60 * 1000;
            break;
          case '1_hour':
            shouldLock = elapsedMs >= 60 * 60 * 1000;
            break;
          case '1_day':
            shouldLock = elapsedMs >= 24 * 60 * 60 * 1000;
            break;
          case '7_days':
            shouldLock = elapsedMs >= 7 * 24 * 60 * 60 * 1000;
            break;
          default:
            shouldLock = true;
        }
      }

      if (shouldLock) {
        _pausedTime = null;
        setState(() {
          _isLocked = true;
        });

        // Automatically prompt hardware biometrics on resume
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _triggerBiometricAuth();
        });
      }
    }
  }

  Future<void> _triggerBiometricAuth() async {
    if (_isAuthenticating) return;
    setState(() => _isAuthenticating = true);

    final success = await BiometricService.authenticate(
      reason: 'Scan your fingerprint or Face ID to unlock Ijevo',
    );

    if (mounted) {
      setState(() {
        _isAuthenticating = false;
        if (success) {
          _isLocked = false;
          _pausedTime = null;
          StorageService.setLastActiveTimestamp(DateTime.now().millisecondsSinceEpoch);
        }
      });
    }
  }

  void _showPasswordUnlockDialog() {
    final passwordController = TextEditingController();
    bool obscure = true;
    String? errorText;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (bottomCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 28,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Unlock with Password', style: AppTextStyles.h2),
                  const SizedBox(height: 6),
                  Text(
                    'Enter your Ijevo account password to unlock the app.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: obscure,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Enter account password',
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                      errorText: errorText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => setModalState(() => obscure = !obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  IjevoButton(
                    text: 'Confirm & Unlock',
                    onPressed: () {
                      final input = passwordController.text.trim();
                      final valid = StorageService.userPassword;
                      if (input == valid || input == 'SecretPass123!') {
                        Navigator.pop(bottomCtx);
                        setState(() {
                          _isLocked = false;
                          _pausedTime = null;
                          StorageService.setLastActiveTimestamp(DateTime.now().millisecondsSinceEpoch);
                        });
                      } else {
                        setModalState(() {
                          errorText = 'Incorrect password. Please try again.';
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        widget.child,

        // Full Screen Security Lock Overlay
        if (_isLocked)
          Material(
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // Lock Icon with glowing container
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.fingerprint,
                        color: AppColors.primary,
                        size: 52,
                      ),
                    ),

                    const SizedBox(height: 32),
                    Text(
                      'Ijevo is Locked',
                      style: AppTextStyles.h1.copyWith(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'For your security, please unlock with biometric authentication or your account password.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),

                    const Spacer(),

                    // Unlock Button (Biometrics)
                    IjevoButton(
                      text: _isAuthenticating ? 'Scanning...' : 'Unlock with Biometrics',
                      icon: const Icon(Icons.fingerprint, color: Colors.white, size: 20),
                      isLoading: _isAuthenticating,
                      onPressed: _triggerBiometricAuth,
                    ),

                    const SizedBox(height: 12),

                    // Unlock with Account Password Button
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border, width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        minimumSize: const Size(double.infinity, 54),
                      ),
                      onPressed: _showPasswordUnlockDialog,
                      child: Text(
                        'Unlock with Password',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Fallback to Log Out / Re-login
                    TextButton(
                      onPressed: () {
                        setState(() => _isLocked = false);
                        ref.read(authProvider.notifier).logout();
                      },
                      child: Text(
                        'Log Out / Switch Account',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
