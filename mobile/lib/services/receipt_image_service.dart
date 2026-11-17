import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/transaction_model.dart';

class _ReceiptRow {
  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  const _ReceiptRow(this.label, this.value, {this.isBold = false, this.color});
}

class ReceiptImageService {
  /// Generate a crisp, high-resolution official Ijevo Receipt Image (.png)
  static Future<File> generateReceiptImage(TransactionModel tx) async {
    const double width = 900.0;
    const double height = 1120.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, width, height));

    // 1. Pure Crisp White Background
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(const Rect.fromLTWH(0, 0, width, height), bgPaint);

    // 2. Official Brand Logo (Ribbon + 'ijevo' wordmark)
    try {
      final logoData = await rootBundle.load('assets/ijevo-logo-dark.png');
      final codec = await ui.instantiateImageCodec(logoData.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      final logoImage = frame.image;

      const double targetHeight = 60.0;
      final double scale = targetHeight / logoImage.height;
      final double targetWidth = logoImage.width * scale;

      paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(60, 60, targetWidth, targetHeight),
        image: logoImage,
        fit: BoxFit.contain,
      );
    } catch (_) {
      final tpLogo = TextPainter(
        text: const TextSpan(
          text: 'ijevo',
          style: TextStyle(
            color: Color(0xFF0B192C),
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      tpLogo.paint(canvas, const Offset(60, 60));
    }

    // Subtitle below logo
    final tpSub = TextPainter(
      text: const TextSpan(
        text: 'OFFICIAL TRANSFER RECEIPT',
        style: TextStyle(
          color: Color(0xFF64748B),
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tpSub.paint(canvas, const Offset(60, 130));

    // 3. Status Badge (Right) - STRAIGHT RECTANGULAR BORDER
    const statusRect = Rect.fromLTWH(660, 68, 180, 50);
    final statusBgPaint = Paint()..color = const Color(0xFFECFDF5);
    canvas.drawRect(statusRect, statusBgPaint);

    final statusBorderPaint = Paint()
      ..color = const Color(0xFF00B074)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(statusRect, statusBorderPaint);

    final tpStatus = TextPainter(
      text: const TextSpan(
        text: 'STATUS: SENT',
        style: TextStyle(
          color: Color(0xFF00B074),
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tpStatus.paint(
      canvas,
      Offset(
        statusRect.left + (statusRect.width - tpStatus.width) / 2,
        statusRect.top + (statusRect.height - tpStatus.height) / 2,
      ),
    );

    // Hairline Divider below header
    final dividerPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1.0;
    canvas.drawLine(const Offset(60, 175), const Offset(840, 175), dividerPaint);

    // 4. Hero Card
    const heroRect = Rect.fromLTWH(60, 210, 780, 180);
    final heroRRect = RRect.fromRectAndRadius(heroRect, const Radius.circular(16));
    final heroBgPaint = Paint()..color = const Color(0xFFF8FAFC);
    canvas.drawRRect(heroRRect, heroBgPaint);

    final heroBorderPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(heroRRect, heroBorderPaint);

    // Hero: Delivered Amount
    final tpHeroLabel = TextPainter(
      text: const TextSpan(
        text: 'Delivered Amount',
        style: TextStyle(
          color: Color(0xFF64748B),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tpHeroLabel.paint(canvas, const Offset(95, 235));

    // Hero: Big Formatted Amount
    final numberFormat = NumberFormat('#,##0.00');
    final payoutStr = '${tx.payoutCurrency} ${numberFormat.format(tx.payoutAmount)}';
    final tpHeroAmount = TextPainter(
      text: TextSpan(
        text: payoutStr,
        style: const TextStyle(
          color: Color(0xFF00B074),
          fontSize: 44,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tpHeroAmount.paint(canvas, const Offset(95, 270));

    // Hero: Recipient Name
    final tpHeroRecipient = TextPainter(
      text: TextSpan(
        text: 'to ${tx.recipientName}',
        style: const TextStyle(
          color: Color(0xFF0B192C),
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tpHeroRecipient.paint(canvas, const Offset(95, 335));

    // 5. Transaction Details Header
    final tpSectionHeader = TextPainter(
      text: const TextSpan(
        text: 'TRANSACTION DETAILS',
        style: TextStyle(
          color: Color(0xFF64748B),
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tpSectionHeader.paint(canvas, const Offset(60, 435));
    canvas.drawLine(const Offset(60, 465), const Offset(840, 465), dividerPaint);

    // 6. Data Rows (Fixed date string to prevent glyph box artifacts)
    final dateFormatted = DateFormat("MMM d, yyyy 'at' h:mm a").format(tx.createdAt);
    final sendFormatted = '${tx.sendCurrency} ${numberFormat.format(tx.sendAmount)}';

    final rows = [
      _ReceiptRow('Reference Number', tx.referenceNumber, isBold: true),
      _ReceiptRow('Transaction Date', dateFormatted),
      _ReceiptRow('Payment Method', tx.paymentMethod),
      _ReceiptRow('Recipient Bank / Institution', tx.recipientInstitution),
      _ReceiptRow('Recipient Account Number', tx.recipientAccount),
      _ReceiptRow('Amount Sent', sendFormatted),
      _ReceiptRow('Transfer Fee', 'FREE (${tx.sendCurrency} 0.00)', color: const Color(0xFF00B074), isBold: true),
      _ReceiptRow('Exchange Rate', '1 ${tx.sendCurrency} = ${numberFormat.format(tx.exchangeRate)} ${tx.payoutCurrency}'),
      _ReceiptRow('Total Charged', sendFormatted, isBold: true),
    ];

    double currentY = 495.0;
    final rowDividerPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 1.0;

    for (final row in rows) {
      // Left Label
      final tpLabel = TextPainter(
        text: TextSpan(
          text: row.label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 22,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout(maxWidth: 400);
      tpLabel.paint(canvas, Offset(60, currentY));

      // Right Value
      final tpValue = TextPainter(
        text: TextSpan(
          text: row.value,
          style: TextStyle(
            color: row.color ?? const Color(0xFF0B192C),
            fontSize: 22,
            fontWeight: row.isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout(maxWidth: 400);
      tpValue.paint(canvas, Offset(840 - tpValue.width, currentY));

      canvas.drawLine(Offset(60, currentY + 42), Offset(840, currentY + 42), rowDividerPaint);
      currentY += 65.0;
    }

    // 7. Finish Picture & Convert to PNG Image (No footer note!)
    final picture = recorder.endRecording();
    final img = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/Ijevo_Receipt_${tx.referenceNumber}.png');
    await file.writeAsBytes(pngBytes);
    return file;
  }

  /// Direct trigger for Android Native System Share feature with PNG Image attached
  static Future<void> shareReceipt(BuildContext context, TransactionModel tx) async {
    try {
      final imageFile = await generateReceiptImage(tx);
      await Share.shareXFiles(
        [
          XFile(
            imageFile.path,
            mimeType: 'image/png',
            name: 'Ijevo_Receipt_${tx.referenceNumber}.png',
          ),
        ],
        subject: 'Ijevo Transfer Receipt: ${tx.referenceNumber}',
        text: 'Official Transfer Receipt (${tx.referenceNumber}) from Ijevo.',
      );
    } catch (e) {
      debugPrint('Error sharing receipt image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share receipt: $e')),
        );
      }
    }
  }
}
