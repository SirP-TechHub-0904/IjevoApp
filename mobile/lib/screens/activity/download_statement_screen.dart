import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/back_circle_button.dart';
import '../../widgets/ijevo_button.dart';

class DownloadStatementScreen extends ConsumerStatefulWidget {
  const DownloadStatementScreen({super.key});

  @override
  ConsumerState<DownloadStatementScreen> createState() => _DownloadStatementScreenState();
}

class _DownloadStatementScreenState extends ConsumerState<DownloadStatementScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  final _passwordController = TextEditingController();

  String _selectedRange = 'Last 30 Days';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  String _formatType = 'PDF'; // 'PDF' or 'CSV'
  bool _includeExchangeDetails = true;
  bool _obscurePassword = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider);
    _emailController = TextEditingController(text: user.email);
    _emailController.addListener(_onEmailChanged);
  }

  void _onEmailChanged() {
    setState(() {});
  }

  bool get _isExternalEmail {
    final userEmail = ref.read(authProvider).email.trim().toLowerCase();
    final currentEmail = _emailController.text.trim().toLowerCase();
    return currentEmail.isNotEmpty && currentEmail != userEmail;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _pickCustomRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedRange = 'Custom Range';
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _selectPresetRange(String range) {
    setState(() {
      _selectedRange = range;
      final now = DateTime.now();
      if (range == 'Last 30 Days') {
        _startDate = now.subtract(const Duration(days: 30));
        _endDate = now;
      } else if (range == 'Last 3 Months') {
        _startDate = DateTime(now.year, now.month - 3, now.day);
        _endDate = now;
      } else if (range == 'Year to Date') {
        _startDate = DateTime(now.year, 1, 1);
        _endDate = now;
      }
    });
  }

  void _generateStatement() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);
    await Future.delayed(const Duration(milliseconds: 900));

    setState(() => _isSending = false);

    if (mounted) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    final email = _emailController.text.trim();
    final dateFormat = DateFormat('MMM d, yyyy');
    final rangeStr = '${dateFormat.format(_startDate)} – ${dateFormat.format(_endDate)}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.download_done_rounded, color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: 20),
            Text('Statement Ready!', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              'Your official $_formatType statement covering $rangeStr has been downloaded to your device storage and sent to:',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                email,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.folder_outlined, size: 14, color: AppColors.primaryDark),
                const SizedBox(width: 4),
                Text(
                  'Saved to: Downloads/Ijevo_Statement_Nov2026.$_formatType',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if (_isExternalEmail) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock, color: Color(0xFFD97706), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Encrypted with your selected password for external recipient protection.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: const Color(0xFF92400E),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            IjevoButton(
              text: 'Done',
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Download Statement', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Range Section
              Text('SELECT DATE RANGE', style: AppTextStyles.label),
              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildPresetChip('Last 30 Days'),
                  _buildPresetChip('Last 3 Months'),
                  _buildPresetChip('Year to Date'),
                  ActionChip(
                    label: Text(
                      _selectedRange == 'Custom Range'
                          ? '${dateFormat.format(_startDate)} - ${dateFormat.format(_endDate)}'
                          : 'Custom Dates',
                    ),
                    backgroundColor: _selectedRange == 'Custom Range' ? AppColors.primaryLight : Colors.white,
                    side: BorderSide(
                      color: _selectedRange == 'Custom Range' ? AppColors.primary : AppColors.border,
                      width: 1.5,
                    ),
                    labelStyle: AppTextStyles.bodySmall.copyWith(
                      color: _selectedRange == 'Custom Range' ? AppColors.primaryDark : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    onPressed: _pickCustomRange,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recipient Email Section
              Text('RECEIVING EMAIL ADDRESS', style: AppTextStyles.label),
              const SizedBox(height: 8),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter destination email...',
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                  suffixIcon: _emailController.text.trim().toLowerCase() == ref.watch(authProvider).email.toLowerCase()
                      ? Container(
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'YOUR EMAIL',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primaryDark,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Email address is required';
                  if (!val.contains('@') || !val.contains('.')) return 'Enter a valid email address';
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // Notice Banner (Verified Own Email vs. External Email)
              if (!_isExternalEmail) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Delivering to your verified email. No extra password needed.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Password Encryption Required for External Emails!
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFF59E0B)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.shield_outlined, color: Color(0xFFD97706), size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password Encryption Required',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: const Color(0xFF92400E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Because this statement is being sent to a third-party email, you must set an encryption password. The recipient must enter this password to open the document.',
                              style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF78350F)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Text('CREATE DOCUMENT ENCRYPTION PASSWORD', style: AppTextStyles.label),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter password (min 6 characters)...',
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (val) {
                    if (_isExternalEmail) {
                      if (val == null || val.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 24),

              // Format Selector
              Text('DOCUMENT FORMAT', style: AppTextStyles.label),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _buildFormatCard('PDF', 'Official PDF Document', Icons.picture_as_pdf),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFormatCard('CSV', 'Spreadsheet (CSV/Excel)', Icons.table_chart_outlined),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Statement Options Toggle
              CheckboxListTile(
                value: _includeExchangeDetails,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
                title: Text('Include detailed exchange rates & fees', style: AppTextStyles.bodyMedium),
                subtitle: Text('Full breakdown per transfer', style: AppTextStyles.bodySmall),
                onChanged: (val) => setState(() => _includeExchangeDetails = val ?? true),
              ),

              const SizedBox(height: 32),

              // Submit Button
              IjevoButton(
                text: 'Download & Send Statement',
                isLoading: _isSending,
                icon: const Icon(Icons.download_rounded, color: Colors.white, size: 20),
                onPressed: _generateStatement,
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildPresetChip(String label) {
    final isSelected = _selectedRange == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primaryLight,
      backgroundColor: Colors.white,
      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
      labelStyle: AppTextStyles.bodySmall.copyWith(
        color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
      ),
      onSelected: (_) => _selectPresetRange(label),
    );
  }

  Widget _buildFormatCard(String type, String title, IconData icon) {
    final isSelected = _formatType == type;
    return InkWell(
      onTap: () => setState(() => _formatType = type),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
