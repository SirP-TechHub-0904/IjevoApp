import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/phone_country.dart';
import '../../services/storage_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/back_circle_button.dart';
import '../../widgets/flag_avatar.dart';
import '../../widgets/ijevo_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Ijeoma Uche');
  final _emailController = TextEditingController(text: 'ijeoma.uche@example.com');
  final _phoneController = TextEditingController(text: '7911 123456');
  final _passwordController = TextEditingController(text: 'SecretPass123!');
  final _referralController = TextEditingController();

  PhoneCountry _selectedCountry = kPhoneCountries.first;

  bool _obscurePassword = true;
  bool _agreedToTerms = true;
  bool _isLoading = false;
  bool _showReferral = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _showCountryPickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredCountries = kPhoneCountries.where((c) {
              final query = searchQuery.toLowerCase().trim();
              if (query.isEmpty) return true;
              return c.name.toLowerCase().contains(query) ||
                  c.dialCode.contains(query) ||
                  c.code.toLowerCase().contains(query);
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.72,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Drag Handle
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Country Code', style: AppTextStyles.h2),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.textSecondary),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),

                  // Search Box
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: TextField(
                      autofocus: false,
                      onChanged: (val) {
                        setModalState(() {
                          searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search country or dialing code (e.g. +49, France)...',
                        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        filled: true,
                        fillColor: AppColors.surfaceSecondary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const Divider(height: 1),

                  // List of Countries
                  Expanded(
                    child: filteredCountries.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                'No countries found matching your search.',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filteredCountries.length,
                            separatorBuilder: (_, __) => const Divider(height: 1, indent: 64),
                            itemBuilder: (context, index) {
                              final country = filteredCountries[index];
                              final isSelected = country.code == _selectedCountry.code;

                              return ListTile(
                                leading: FlagAvatar(countryCode: country.code, size: 28),
                                title: Text(country.name, style: AppTextStyles.bodyMedium),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      country.dialCode,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                      ),
                                    ),
                                    if (isSelected) ...[
                                      const SizedBox(width: 8),
                                      const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                                    ],
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedCountry = country;
                                  });
                                  Navigator.pop(ctx);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the Terms of Service to continue')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);

    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final phone = '${_selectedCountry.dialCode} ${_phoneController.text.trim()}';
    final password = _passwordController.text.trim();

    // Save profile and reset post-signup prompt tracker
    await StorageService.setUserFullName(name);
    await StorageService.setUserEmail(email);
    await StorageService.setUserPhone(phone);
    await StorageService.setUserPassword(password);
    await StorageService.setHasSeenOnboarding(true);
    await StorageService.setHasPromptedPostSignup(false);

    if (mounted) {
      // Direct navigation to Email OTP Verification (no popups on signup)
      context.push('/verify-email', extra: email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Sign Up', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create Your Account', style: AppTextStyles.h2),
                const SizedBox(height: 6),
                Text(
                  'Send money worldwide with zero fees and live exchange rates.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),

                const SizedBox(height: 24),

                // Legal Full Name
                Text('LEGAL FULL NAME', style: AppTextStyles.label),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Ijeoma Uche',
                    prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your legal name' : null,
                ),

                const SizedBox(height: 16),

                // Email Address
                Text('EMAIL ADDRESS', style: AppTextStyles.label),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'name@example.com',
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Please enter a valid email' : null,
                ),

                const SizedBox(height: 16),

                // Phone Number
                Text('MOBILE PHONE NUMBER', style: AppTextStyles.label),
                const SizedBox(height: 6),
                Row(
                  children: [
                    InkWell(
                      onTap: _showCountryPickerBottomSheet,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSecondary,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FlagAvatar(countryCode: _selectedCountry.code, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              _selectedCountry.dialCode,
                              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: '7911 123456',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        validator: (v) => (v == null || v.trim().length < 6) ? 'Enter a valid phone number' : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Password
                Text('PASSWORD', style: AppTextStyles.label),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Create a secure password',
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
                ),

                const SizedBox(height: 16),

                // Optional Referral Code
                InkWell(
                  onTap: () => setState(() => _showReferral = !_showReferral),
                  child: Row(
                    children: [
                      Icon(
                        _showReferral ? Icons.remove_circle_outline : Icons.add_circle_outline,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Have a referral / promo code?',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                if (_showReferral) ...[
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _referralController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'e.g. IJEOMA20',
                      prefixIcon: const Icon(Icons.card_giftcard, color: AppColors.primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      helperText: 'Get £5 off your first transfer of £50+',
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Terms agreement
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreedToTerms,
                        activeColor: AppColors.primary,
                        onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                        child: Text(
                          'I agree to Ijevo\'s User Agreement, Privacy Policy, and Cookie Policy.',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.3),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Submit Button
                IjevoButton(
                  text: 'Create Free Account',
                  isLoading: _isLoading,
                  onPressed: _onSignup,
                ),

                const SizedBox(height: 20),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    InkWell(
                      onTap: () => context.go('/login'),
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
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
