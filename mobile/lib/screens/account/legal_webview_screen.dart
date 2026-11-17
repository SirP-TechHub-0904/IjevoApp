import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/back_circle_button.dart';

class LegalWebViewScreen extends StatelessWidget {
  final String title;
  final String slug;

  const LegalWebViewScreen({
    super.key,
    required this.title,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text(title, style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: _buildDocumentContent(),
        ),
      ),
    );
  }

  Widget _buildDocumentContent() {
    switch (slug) {
      case 'terms':
        return _buildTermsContent();
      case 'privacy':
        return _buildPrivacyContent();
      case 'cookies':
        return _buildCookiesContent();
      case 'licenses':
        return _buildLicensesContent();
      case 'company':
        return _buildCompanyContent();
      default:
        return _buildTermsContent();
    }
  }

  Widget _buildTermsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocHeader('User Agreement & Terms of Service', 'Version 2.4 • Effective November 2026'),
        _buildSectionTitle('1. Introduction & Overview'),
        _buildParagraph(
          'Welcome to Ijevo Remit. This User Agreement governs your access to and use of the Ijevo mobile application, website, multi-currency wallets, and international payment services provided by Ijevo Remit Ltd.',
        ),
        _buildSectionTitle('2. Eligibility & Account Verification'),
        _buildParagraph(
          'To use Ijevo services, you must be at least 18 years of age and a resident of the United Kingdom or other supported jurisdictions. You must complete customer identity verification (KYC) in compliance with applicable anti-money laundering regulations.',
        ),
        _buildSectionTitle('3. Send Money & Payout Services'),
        _buildParagraph(
          'When you initiate a money transfer, we display the guaranteed live exchange rate and total amount to be received in the destination currency before confirmation. Transfer fees are £0.00 unless explicitly disclosed for expedited rail access.',
        ),
        _buildSectionTitle('4. Safeguarding of Funds'),
        _buildParagraph(
          'All client funds are held in segregated, safeguarded bank accounts at Tier-1 UK financial institutions. Client funds are kept separate from company operational accounts at all times.',
        ),
        _buildSectionTitle('5. Cancellation & Refunds'),
        _buildParagraph(
          'Transfers can be cancelled free of charge before they are processed by the receiving bank or mobile money operator. Once delivered to the recipient account, transfers cannot be recalled.',
        ),
      ],
    );
  }

  Widget _buildPrivacyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocHeader('Privacy Policy & GDPR Compliance', 'Last Updated: November 2026'),
        _buildSectionTitle('1. Information We Collect'),
        _buildParagraph(
          'We collect information necessary to facilitate safe money remittance, verify identity, and prevent fraudulent transactions. This includes legal name, date of birth, residential address, email, phone number, and transaction histories.',
        ),
        _buildSectionTitle('2. How We Protect Your Data'),
        _buildParagraph(
          'Your personal and financial information is encrypted in transit and at rest using bank-grade 256-bit AES encryption. We do not sell or rent personal information to marketing third parties.',
        ),
        _buildSectionTitle('3. Your GDPR Rights'),
        _buildParagraph(
          'Under the UK General Data Protection Regulation (UK GDPR), you have the right to access, rectify, or request erasure of your personal data, subject to statutory financial record-retention requirements.',
        ),
      ],
    );
  }

  Widget _buildCookiesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocHeader('Cookie & Tracking Policy', 'Effective November 2026'),
        _buildSectionTitle('1. Essential App Tokens'),
        _buildParagraph(
          'Our mobile application uses secure tokens stored in your device encrypted keychain for session authentication and biometric lock state.',
        ),
        _buildSectionTitle('2. Analytics & Performance'),
        _buildParagraph(
          'Anonymous crash reporting and performance telemetry help us improve remittance delivery speeds and user experience without logging personally identifiable financial credentials.',
        ),
      ],
    );
  }

  Widget _buildLicensesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocHeader('Third-Party Software Notices', 'Open Source Attributions'),
        _buildSectionTitle('1. Flutter Framework'),
        _buildParagraph('Copyright 2014 The Flutter Authors. All rights reserved under BSD 3-Clause License.'),
        _buildSectionTitle('2. Open Source Libraries'),
        _buildParagraph('• Riverpod (MIT License)\n• GoRouter (BSD 3-Clause)\n• Google Fonts (SIL Open Font License)\n• LocalAuth (BSD 3-Clause)'),
      ],
    );
  }

  Widget _buildCompanyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocHeader('Company Registration Details', 'Official Corporate Profile'),
        _buildSectionTitle('Legal Entity'),
        _buildParagraph('Ijevo Remit Ltd\nRegistered in England and Wales\nCompany Registration Number: 14298192'),
        _buildSectionTitle('Registered Office'),
        _buildParagraph('42 Highfield Road, Canary Wharf, London, E14 9GE, United Kingdom'),
        _buildSectionTitle('Contact Information'),
        _buildParagraph('General Enquiries: contact@ijevo.com\nCompliance & Legal: legal@ijevo.com\nCustomer Support: support@ijevo.com'),
      ],
    );
  }

  Widget _buildDocHeader(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 1.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h2),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF475569), height: 1.6),
    );
  }
}
