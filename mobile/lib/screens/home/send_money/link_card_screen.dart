import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../models/card_model.dart';
import '../../../providers/card_provider.dart';
import '../../../providers/transfer_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/back_circle_button.dart';
import '../../../widgets/ijevo_button.dart';

class LinkCardScreen extends ConsumerStatefulWidget {
  const LinkCardScreen({super.key});

  @override
  ConsumerState<LinkCardScreen> createState() => _LinkCardScreenState();
}

class _LinkCardScreenState extends ConsumerState<LinkCardScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _flipAnimation;

  bool _isValidating = false;
  bool _isCardValidated = false;
  bool _saveForFuture = true;
  String _detectedBrand = 'Visa';
  final FocusNode _cvvFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutBack),
    );

    _cvvFocusNode.addListener(() {
      if (_cvvFocusNode.hasFocus && !_isCardValidated) {
        _animController.forward();
      } else if (!_isCardValidated) {
        _animController.reverse();
      }
    });

    _cardNumberController.addListener(_onCardNumberChanged);
  }

  void _onCardNumberChanged() {
    final text = _cardNumberController.text.replaceAll(' ', '');
    setState(() {
      if (text.startsWith('5') || text.startsWith('2')) {
        _detectedBrand = 'Mastercard';
      } else if (text.startsWith('3')) {
        _detectedBrand = 'Amex';
      } else {
        _detectedBrand = 'Visa';
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _cardNumberController.dispose();
    _nameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cvvFocusNode.dispose();
    super.dispose();
  }

  void _validateCard() async {
    if (!_formKey.currentState!.validate()) return;

    // Unfocus keyboard
    FocusScope.of(context).unfocus();

    setState(() => _isValidating = true);

    // Simulate online card verification / BIN check
    await Future.delayed(const Duration(milliseconds: 800));

    // Turn / Flip card animation to reveal validated state
    await _animController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    await _animController.reverse();

    setState(() {
      _isValidating = false;
      _isCardValidated = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Card validated successfully! Ready to debit.'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  void _proceedToDebit() {
    final transfer = ref.read(transferProvider);
    final currencyFormat = NumberFormat('#,##0.00');
    final amountFormatted = '£${currencyFormat.format(transfer.sendAmount)}';
    final recipient = transfer.selectedRecipient;
    final last4 = _cardNumberController.text.replaceAll(' ', '');
    final displayLast4 = last4.length >= 4 ? last4.substring(last4.length - 4) : '9021';

    // Show 3D Secure / Bank Authorization Bottom Sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottomPadding = MediaQuery.of(ctx).viewPadding.bottom;
        return Container(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 28 + bottomPadding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 36),
                ),
                const SizedBox(height: 16),
                Text('3D Secure Bank Verification', style: AppTextStyles.h2),
                const SizedBox(height: 8),
                Text(
                  'Your card issuer requires one-time authentication to debit $amountFormatted for ${recipient?.fullName ?? 'recipient'}.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Card', style: AppTextStyles.bodySmall),
                          Text('$_detectedBrand •••• $displayLast4', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Amount to Debit', style: AppTextStyles.bodySmall),
                          Text(amountFormatted, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                IjevoButton(
                  text: 'Authorize & Debit $amountFormatted',
                  onPressed: () {
                    // Save card to provider if toggled
                    if (_saveForFuture) {
                      final newCard = SavedCardModel(
                        id: 'card_${DateTime.now().millisecondsSinceEpoch}',
                        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
                        cardholderName: _nameController.text.trim().toUpperCase(),
                        expiryDate: _expiryController.text.trim(),
                        brand: _detectedBrand,
                        isDefault: false,
                      );
                      ref.read(cardProvider.notifier).addCard(newCard);
                    }

                    // Select as active payment method
                    ref.read(transferProvider.notifier).selectPaymentMethod('Debit Card (•••• $displayLast4)');

                    Navigator.pop(ctx);
                    // Route directly to transfer success screen
                    context.pushReplacement('/send/success');
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Cancel', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ),
      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transfer = ref.watch(transferProvider);
    final currencyFormat = NumberFormat('#,##0.00');
    final amountFormatted = '£${currencyFormat.format(transfer.sendAmount)}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Link Debit Card', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Interactive 3D Turning Card Preview
              AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  final angle = _flipAnimation.value * math.pi;
                  final isBack = _flipAnimation.value >= 0.5;

                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // perspective
                      ..rotateY(angle),
                    alignment: Alignment.center,
                    child: isBack
                        ? Transform(
                            transform: Matrix4.identity()..rotateY(math.pi),
                            alignment: Alignment.center,
                            child: _buildCardBack(),
                          )
                        : _buildCardFront(),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Status Indicator Banner when validated
              if (_isCardValidated) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.primary, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Card Verified & Linked',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Ready to debit $amountFormatted to credit recipient',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Card Number Input
              Text('Card Number', style: AppTextStyles.label),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                enabled: !_isCardValidated,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberInputFormatter(),
                ],
                decoration: InputDecoration(
                  hintText: '4532 8901 2345 9021',
                  prefixIcon: const Icon(Icons.credit_card, color: AppColors.textSecondary),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      _detectedBrand.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: _detectedBrand == 'Visa' ? const Color(0xFF1A1F71) : const Color(0xFFEB001B),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.replaceAll(' ', '').length < 16) {
                    return 'Please enter a valid 16-digit card number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Cardholder Name
              Text('Cardholder Name', style: AppTextStyles.label),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.characters,
                enabled: !_isCardValidated,
                decoration: const InputDecoration(
                  hintText: 'e.g. IJEOMA UCHE',
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter cardholder name';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 18),

              // Expiry & CVV Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Expiry Date', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _expiryController,
                          keyboardType: TextInputType.number,
                          enabled: !_isCardValidated,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            _CardExpiryInputFormatter(),
                          ],
                          decoration: const InputDecoration(
                            hintText: 'MM/YY',
                            prefixIcon: Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textSecondary),
                          ),
                          validator: (val) {
                            if (val == null || val.length < 5) {
                              return 'Enter MM/YY';
                            }
                            return null;
                          },
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Security Code (CVV)', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _cvvController,
                          focusNode: _cvvFocusNode,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          enabled: !_isCardValidated,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration: const InputDecoration(
                            hintText: '•••',
                            prefixIcon: Icon(Icons.lock_outline, size: 18, color: AppColors.textSecondary),
                          ),
                          validator: (val) {
                            if (val == null || val.length < 3) {
                              return 'Enter 3 digits';
                            }
                            return null;
                          },
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Save Card Toggle
              Row(
                children: [
                  Checkbox(
                    value: _saveForFuture,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (val) => setState(() => _saveForFuture = val ?? true),
                  ),
                  Expanded(
                    child: Text(
                      'Save card securely for future transfers',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Dynamic Turning Action Button
              if (!_isCardValidated) ...[
                IjevoButton(
                  text: 'Validate Card',
                  isLoading: _isValidating,
                  onPressed: _validateCard,
                ),
              ] else ...[
                IjevoButton(
                  text: 'Proceed to Debit $amountFormatted',
                  backgroundColor: AppColors.primary,
                  icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                  onPressed: _proceedToDebit,
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isCardValidated = false;
                      });
                    },
                    child: Text(
                      'Edit Card Info',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 6),
                  Text(
                    '256-Bit Encrypted • PCI-DSS Compliant',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildCardFront() {
    final rawNum = _cardNumberController.text.replaceAll(' ', '');
    final displayNum = rawNum.isEmpty
        ? '••••  ••••  ••••  ••••'
        : _formatCardPreview(rawNum);

    final displayName = _nameController.text.trim().isEmpty
        ? 'CARDHOLDER NAME'
        : _nameController.text.trim().toUpperCase();

    final displayExpiry = _expiryController.text.isEmpty
        ? 'MM/YY'
        : _expiryController.text;

    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isCardValidated
              ? [const Color(0xFF00D084), const Color(0xFF0B192C)]
              : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (_isCardValidated ? AppColors.primary : Colors.black).withOpacity(0.2),
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
                  const Icon(Icons.credit_card, color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                  Text('ijevo', style: AppTextStyles.h3.copyWith(color: Colors.white, letterSpacing: 1)),
                ],
              ),
              if (_isCardValidated)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text('VERIFIED', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              else
                const Icon(Icons.contactless, color: Colors.white, size: 24),
            ],
          ),
          Text(
            displayNum,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CARDHOLDER', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 9)),
                  Text(displayName, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('EXPIRES', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 9)),
                  Text(displayExpiry, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
              Text(
                _detectedBrand.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    final displayCvv = _cvvController.text.isEmpty ? '•••' : _cvvController.text;

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Magnetic Strip
          Container(
            height: 40,
            width: double.infinity,
            color: Colors.black87,
          ),
          const SizedBox(height: 20),
          // Signature & CVV Strip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36,
                    color: Colors.white70,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      displayCvv,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Authorized Signature',
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10),
                ),
                Text(
                  'CVV / CVC',
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCardPreview(String number) {
    final buffer = StringBuffer();
    for (int i = 0; i < number.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write('  ');
      buffer.write(number[i]);
    }
    // Pad remaining
    final remaining = 16 - number.length;
    for (int i = 0; i < remaining; i++) {
      final index = number.length + i;
      if (index > 0 && index % 4 == 0) buffer.write('  ');
      buffer.write('•');
    }
    return buffer.toString();
  }
}

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digitsOnly[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digitsOnly[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
