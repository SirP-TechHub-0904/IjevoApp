import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/back_circle_button.dart';
import '../../widgets/ijevo_button.dart';
import '../../widgets/user_avatar.dart';

class PersonalDetailsScreen extends ConsumerStatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  ConsumerState<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends ConsumerState<PersonalDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Personal Details', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 60),
          children: [
            // Top Profile Avatar Section
            Center(
              child: Column(
                children: [
                  UserAvatar(
                    user: user,
                    size: 88,
                    showEditBadge: true,
                    onTap: () => _showAvatarPickerModal(context),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.fullName,
                        style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, color: AppColors.primary, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => _showAvatarPickerModal(context),
                    child: Text(
                      'Change photo or avatar icon',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text('PERSONAL INFORMATION', style: AppTextStyles.label),
            const SizedBox(height: 10),

            // 1. Legal Full Name (Verification Required)
            _buildInteractiveItem(
              label: 'Legal Full Name',
              value: user.fullName,
              isEditable: true,
              badge: user.nameChangeStatus == 'Under Review' ? 'Under Review' : null,
              badgeColor: const Color(0xFFF59E0B),
              pendingNote: user.nameChangeStatus == 'Under Review'
                  ? 'Request to change name to "${user.pendingNameChange}" is under compliance review with your ${user.nameChangeDocType ?? 'ID card'}.'
                  : null,
              onTap: () => _showNameChangeModal(context, user),
            ),

            // 2. Date of Birth (Verification Required)
            _buildInteractiveItem(
              label: 'Date of Birth',
              value: user.dateOfBirth,
              isEditable: true,
              badge: user.dobChangeStatus == 'Under Review' ? 'Under Review' : null,
              badgeColor: const Color(0xFFF59E0B),
              pendingNote: user.dobChangeStatus == 'Under Review'
                  ? 'DOB update to "${user.pendingDobChange}" is under review with your ID document.'
                  : null,
              onTap: () => _showDobChangeModal(context, user),
            ),

            // 3. Residential Address (Editable with Proof of Address)
            _buildInteractiveItem(
              label: 'Residential Address',
              value: '${user.address}, ${user.city}, ${user.postcode}',
              isEditable: true,
              onTap: () => _showAddressUpdateModal(context, user),
            ),

            // 4. Mobile Phone Number (Verification Required via SMS OTP)
            _buildInteractiveItem(
              label: 'Mobile Phone Number',
              value: user.phoneNumber,
              isEditable: true,
              onTap: () => _showPhoneUpdateModal(context, user),
            ),

            // 5. Email Address (Fixed for Security)
            _buildInteractiveItem(
              label: 'Email Address',
              value: user.email,
              isEditable: false,
              isFixed: true,
              onTap: () => _showEmailFixedDialog(context, user.email),
            ),

            // 6. Country of Residence
            _buildInteractiveItem(
              label: 'Country of Residence',
              value: user.country,
              isEditable: false,
              onTap: () => _showCountryInfoDialog(context),
            ),

            // 7. KYC Verification Status
            _buildInteractiveItem(
              label: 'KYC Verification',
              value: 'Identity Verified',
              valueColor: AppColors.primary,
              isEditable: false,
              badge: 'Verified',
              badgeColor: AppColors.primary,
              onTap: () => _showKycDetailsModal(context),
            ),

            const SizedBox(height: 28),

            // Download statement button
            OutlinedButton.icon(
              onPressed: () => context.push('/activity/statement'),
              icon: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.primary),
              label: const Text(
                'Download Transfer Statements PDF',
                style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveItem({
    required String label,
    required String value,
    required bool isEditable,
    bool isFixed = false,
    Color? valueColor,
    String? badge,
    Color? badgeColor,
    String? pendingNote,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badge != null ? (badgeColor ?? AppColors.primary) : AppColors.border,
          width: badge != null ? 1.5 : 1,
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
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: AppTextStyles.bodySmall),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: (badgeColor ?? AppColors.primary).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (badge == 'Under Review')
                            Icon(Icons.schedule, size: 12, color: badgeColor ?? AppColors.primary)
                          else
                            Icon(Icons.check_circle, size: 12, color: badgeColor ?? AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            badge,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: badgeColor ?? AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (isEditable)
                    const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary)
                  else if (isFixed)
                    const Icon(Icons.lock_outline, size: 16, color: AppColors.textMuted)
                  else
                    const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.textPrimary,
                ),
              ),
              if (pendingNote != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: Color(0xFFD97706)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          pendingNote,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: const Color(0xFF92400E),
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================================
  // 1. AVATAR / ICON / PHOTO PICKER MODAL
  // =====================================================================
  void _showAvatarPickerModal(BuildContext context) {
    final user = ref.read(authProvider);

    final List<Map<String, dynamic>> avatarIcons = [
      {'name': 'person', 'label': 'Profile', 'icon': Icons.person_rounded},
      {'name': 'shield', 'label': 'Security', 'icon': Icons.shield_rounded},
      {'name': 'diamond', 'label': 'VIP', 'icon': Icons.diamond_rounded},
      {'name': 'rocket', 'label': 'Growth', 'icon': Icons.rocket_launch_rounded},
      {'name': 'savings', 'label': 'Savings', 'icon': Icons.savings_rounded},
      {'name': 'public', 'label': 'Global', 'icon': Icons.public_rounded},
      {'name': 'star', 'label': 'Pioneer', 'icon': Icons.stars_rounded},
      {'name': 'bolt', 'label': 'Fast', 'icon': Icons.bolt_rounded},
      {'name': 'credit_card', 'label': 'Card', 'icon': Icons.credit_card_rounded},
      {'name': 'crown', 'label': 'Elite', 'icon': Icons.military_tech_rounded},
    ];

    final List<int> bgColors = [
      0xFF0B192C, // Navy (Ijevo brand)
      0xFF00D084, // Emerald Green
      0xFF1E40AF, // Royal Blue
      0xFF6B21A8, // Deep Purple
      0xFFBE185D, // Rose
      0xFF0F766E, // Teal
      0xFFB45309, // Amber Gold
      0xFF334155, // Slate
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String selectedIcon = user.avatarIconName;
        int selectedColor = user.avatarBgColor;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
            final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.only(bottom: keyboardInset),
              child: Container(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 28 + bottomPadding),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Customize Profile Avatar', style: AppTextStyles.h3),
                    const SizedBox(height: 4),
                    Text(
                      'Choose a modern icon or profile photo (no emojis).',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),

                    // Live Preview
                    Center(
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: Color(selectedColor),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          UserAvatar.getIconData(selectedIcon),
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text('SELECT AVATAR ICON', style: AppTextStyles.label),
                    const SizedBox(height: 10),

                    // Grid of icons
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: avatarIcons.map((item) {
                        final isSelected = selectedIcon == item['name'];
                        return InkWell(
                          onTap: () {
                            setModalState(() {
                              selectedIcon = item['name'];
                            });
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryLight : AppColors.surfaceSecondary,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.border,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                              size: 26,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                    Text('BACKGROUND COLOR', style: AppTextStyles.label),
                    const SizedBox(height: 10),

                    // Color palette
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: bgColors.map((c) {
                          final isSelected = selectedColor == c;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () {
                                setModalState(() {
                                  selectedColor = c;
                                });
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Color(c),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : Colors.white,
                                    width: isSelected ? 3 : 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                                    : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Simulate custom photo upload
                              ref.read(authProvider.notifier).setAvatarPhoto(
                                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
                                  );
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Custom profile photo uploaded successfully')),
                              );
                            },
                            icon: const Icon(Icons.camera_alt_outlined, size: 18),
                            label: const Text('Upload Photo', style: TextStyle(fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              ref.read(authProvider.notifier).resetAvatar();
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Avatar reset to default initials (IU)')),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('Use Initials', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    IjevoButton(
                      text: 'Apply Avatar Icon',
                      onPressed: () {
                        ref.read(authProvider.notifier).setAvatarIcon(
                              iconName: selectedIcon,
                              bgColor: selectedColor,
                            );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile avatar updated!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            );
          },
        );
      },
    );
  }

  // =====================================================================
  // 2. LEGAL NAME CHANGE WITH ID CARD VERIFICATION
  // =====================================================================
  void _showNameChangeModal(BuildContext context, UserProfile user) {
    final nameController = TextEditingController(text: user.pendingNameChange ?? user.fullName);
    String selectedDoc = 'Passport';
    bool hasUploadedDoc = user.nameChangeDocType != null;
    String fileName = hasUploadedDoc ? 'id_verification_scan.jpg' : '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
            final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.only(bottom: keyboardInset),
              child: Container(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 28 + bottomPadding),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Update Legal Full Name', style: AppTextStyles.h3),
                      const SizedBox(height: 4),
                      Text(
                        'Requires verification: Upload an official ID card backing your new legal name.',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),

                      // Compliance requirement alert
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.shield_outlined, color: AppColors.primary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Regulated Payment Rule: Your name must strictly match your bank account and government ID to prevent remittance delays.',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primaryDark,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text('NEW LEGAL FULL NAME', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter new full name',
                          prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.textSecondary),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text('SUPPORTING ID DOCUMENT', style: AppTextStyles.label),
                      const SizedBox(height: 8),

                      DropdownButtonFormField<String>(
                        value: selectedDoc,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Passport', child: Text('International Passport')),
                          DropdownMenuItem(value: 'National ID Card', child: Text('National ID Card / Biometric')),
                          DropdownMenuItem(value: 'Driving Licence', child: Text('UK Driving Licence')),
                          DropdownMenuItem(value: 'Marriage Certificate', child: Text('Marriage Certificate / Deed Poll')),
                        ],
                        onChanged: (val) {
                          if (val != null) setModalState(() => selectedDoc = val);
                        },
                      ),

                      const SizedBox(height: 16),
                      Text('UPLOAD ID CARD BACKING', style: AppTextStyles.label),
                      const SizedBox(height: 8),

                      InkWell(
                        onTap: () {
                          setModalState(() {
                            hasUploadedDoc = true;
                            fileName = '${selectedDoc.toLowerCase().replaceAll(' ', '_')}_verified_scan.jpg';
                          });
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: hasUploadedDoc ? AppColors.primaryLight : AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: hasUploadedDoc ? AppColors.primary : AppColors.border,
                              style: hasUploadedDoc ? BorderStyle.solid : BorderStyle.solid,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: hasUploadedDoc ? AppColors.primary : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  hasUploadedDoc ? Icons.check : Icons.camera_alt_outlined,
                                  color: hasUploadedDoc ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hasUploadedDoc ? fileName : 'Take photo or upload ID card',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: hasUploadedDoc ? AppColors.primaryDark : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      hasUploadedDoc ? '2.4 MB • Front & back scanned' : 'Clear color scan (JPG, PNG, PDF up to 10MB)',
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              if (hasUploadedDoc)
                                const Text(
                                  'Change',
                                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                                ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      IjevoButton(
                        text: 'Submit for Verification',
                        onPressed: () {
                          if (nameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter your new legal name')),
                            );
                            return;
                          }
                          if (!hasUploadedDoc) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please upload an ID card backing your name change')),
                            );
                            return;
                          }

                          ref.read(authProvider.notifier).requestNameChange(
                                newName: nameController.text.trim(),
                                documentType: selectedDoc,
                              );
                          Navigator.pop(ctx);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Color(0xFF0B192C),
                              content: Text(
                                'Name change request submitted with ID card! Compliance status: Under Review (typically 1-2 hours).',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =====================================================================
  // 3. DATE OF BIRTH CHANGE WITH ID VERIFICATION
  // =====================================================================
  void _showDobChangeModal(BuildContext context, UserProfile user) {
    final dobController = TextEditingController(text: user.pendingDobChange ?? user.dateOfBirth);
    bool hasDoc = user.dobChangeDocType != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
            final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.only(bottom: keyboardInset),
              child: Container(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 28 + bottomPadding),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Update Date of Birth', style: AppTextStyles.h3),
                      const SizedBox(height: 4),
                      Text(
                        'Requires verification: Upload your passport or national ID card showing your date of birth.',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),

                      Text('DATE OF BIRTH (DD/MM/YYYY)', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextField(
                        controller: dobController,
                        decoration: InputDecoration(
                          hintText: 'DD/MM/YYYY',
                          prefixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text('ID PROOF OF BIRTHDATE', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          setModalState(() => hasDoc = true);
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: hasDoc ? AppColors.primaryLight : AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: hasDoc ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(hasDoc ? Icons.check_circle : Icons.upload_file, color: AppColors.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  hasDoc ? 'passport_dob_scan.pdf (1.9 MB)' : 'Upload Passport / ID Card',
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      IjevoButton(
                        text: 'Submit for Review',
                        onPressed: () {
                          ref.read(authProvider.notifier).requestDobChange(
                                newDob: dobController.text.trim(),
                                documentType: 'Passport',
                              );
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Color(0xFF0B192C),
                              content: Text('Date of birth update submitted! Status: Under Review.'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =====================================================================
  // 4. PHONE NUMBER WITH SMS OTP VERIFICATION
  // =====================================================================
  void _showPhoneUpdateModal(BuildContext context, UserProfile user) {
    final phoneController = TextEditingController(text: '+44 7922 889900');
    final otpController = TextEditingController(text: '749201');
    bool otpSent = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
            final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.only(bottom: keyboardInset),
              child: Container(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 28 + bottomPadding),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Update Mobile Phone Number', style: AppTextStyles.h3),
                      const SizedBox(height: 4),
                      Text(
                        otpSent
                            ? 'Enter the 6-digit SMS verification code sent to your new phone number.'
                            : 'Enter your new phone number. We will send an SMS OTP code to verify ownership.',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 20),

                      if (!otpSent) ...[
                        Text('NEW MOBILE NUMBER', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.phone_iphone, color: AppColors.textSecondary),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        IjevoButton(
                          text: 'Send Verification Code',
                          onPressed: () {
                            if (phoneController.text.trim().isEmpty) return;
                            setModalState(() => otpSent = true);
                          },
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.sms_outlined, color: AppColors.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'SMS code sent to ${phoneController.text}. Demo OTP code pre-filled.',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('6-DIGIT VERIFICATION CODE', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        TextField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            'Resend code in 45s',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                        const SizedBox(height: 20),
                        IjevoButton(
                          text: 'Verify & Update Phone',
                          onPressed: () {
                            ref.read(authProvider.notifier).updatePhone(phoneController.text.trim());
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: AppColors.primary,
                                content: Text('Phone number verified and updated successfully!'),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =====================================================================
  // 5. RESIDENTIAL ADDRESS UPDATE
  // =====================================================================
  void _showAddressUpdateModal(BuildContext context, UserProfile user) {
    final addressController = TextEditingController(text: user.address);
    final cityController = TextEditingController(text: user.city);
    final postcodeController = TextEditingController(text: user.postcode);
    bool uploadedProof = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
            final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.only(bottom: keyboardInset),
              child: Container(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 28 + bottomPadding),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Update Residential Address', style: AppTextStyles.h3),
                      const SizedBox(height: 4),
                      Text(
                        'Provide your new address and supporting proof of residence (e.g. utility bill or bank statement).',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),

                      Text('STREET ADDRESS', style: AppTextStyles.label),
                      const SizedBox(height: 6),
                      TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                          hintText: 'e.g. 42 Highfield Road',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CITY', style: AppTextStyles.label),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: cityController,
                                  decoration: InputDecoration(
                                    hintText: 'London',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('POSTCODE', style: AppTextStyles.label),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: postcodeController,
                                  decoration: InputDecoration(
                                    hintText: 'E14 9GE',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Text('PROOF OF ADDRESS (LAST 3 MONTHS)', style: AppTextStyles.label),
                      const SizedBox(height: 8),

                      InkWell(
                        onTap: () {
                          setModalState(() => uploadedProof = true);
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: uploadedProof ? AppColors.primaryLight : AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: uploadedProof ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(uploadedProof ? Icons.check_circle : Icons.upload_file, color: AppColors.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  uploadedProof ? 'utility_bill_september.pdf (1.2 MB)' : 'Upload Utility Bill or Bank Statement',
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      IjevoButton(
                        text: 'Save Address & Verify',
                        onPressed: () {
                          ref.read(authProvider.notifier).updateAddress(
                                address: addressController.text.trim(),
                                city: cityController.text.trim(),
                                postcode: postcodeController.text.trim(),
                              );
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AppColors.primary,
                              content: Text('Residential address updated and verified!'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =====================================================================
  // 6. EMAIL FIXED DIALOG (EMAIL CANNOT BE CHANGED IN APP)
  // =====================================================================
  void _showEmailFixedDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_rounded, color: AppColors.navy, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Text('Email Address is Fixed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'For account security, fraud prevention, and regulatory safeguards, your primary email address is fixed:',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  email,
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'If you have lost access to this email or need a manual override, please contact Ijevo Support.',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Understood', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.push('/account/help');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Contact Support', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // =====================================================================
  // 7. COUNTRY INFO & KYC DETAILS
  // =====================================================================
  void _showCountryInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Country of Residence', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'Your country of residence is currently set to United Kingdom. Changing country requires relocation documentation and local bank linking. Please contact support if you have relocated.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showKycDetailsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        final bottomPadding = MediaQuery.of(ctx).viewPadding.bottom;
        return Container(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 28 + bottomPadding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified, color: AppColors.primary, size: 28),
                  const SizedBox(width: 12),
                  Text('KYC Verification Details', style: AppTextStyles.h3),
                ],
              ),
              const SizedBox(height: 16),
              _buildKycRow('Verification Level', 'Level 2 (Full Tier)'),
              _buildKycRow('ID Document', 'UK Passport (Verified)'),
              _buildKycRow('Facial Biometrics', 'Passed (Verified)'),
              _buildKycRow('Daily Sending Limit', '£20,000.00'),
              _buildKycRow('Annual Limit', 'Unlimited'),
              const SizedBox(height: 20),
              IjevoButton(
                text: 'Done',
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKycRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
