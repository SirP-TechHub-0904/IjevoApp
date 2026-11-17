import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/transaction_model.dart';
import 'receipt_image_service.dart';

class PdfReceiptService {
  /// Direct trigger for Android Native System Share feature - shares crisp PNG receipt image
  static Future<void> shareReceipt(BuildContext context, TransactionModel tx) async {
    await ReceiptImageService.shareReceipt(context, tx);
  }

  /// Generate a high-resolution, branded Ijevo PDF receipt file (kept for optional PDF export)
  static Future<File> generateReceiptPdf(TransactionModel tx) async {
    final pdf = pw.Document();
    final numberFormat = NumberFormat('#,##0.00');

    final sendFormatted = '${tx.sendCurrency} ${numberFormat.format(tx.sendAmount)}';
    final payoutFormatted = '${tx.payoutCurrency} ${numberFormat.format(tx.payoutAmount)}';
    final dateFormatted = DateFormat('MMM d, yyyy • h:mm a').format(tx.createdAt);

    // Primary Brand Colors for PDF
    final primaryColor = PdfColor.fromHex('#00B074');
    final darkNavy = PdfColor.fromHex('#0B192C');
    final surfaceColor = PdfColor.fromHex('#F8FAFC');
    final borderColor = PdfColor.fromHex('#E2E8F0');
    final textSecondary = PdfColor.fromHex('#64748B');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 1. Header Bar
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Row(
                    children: [
                      // Logo Mark
                      pw.Container(
                        width: 44,
                        height: 44,
                        decoration: pw.BoxDecoration(
                          color: darkNavy,
                          shape: pw.BoxShape.circle,
                        ),
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          'i',
                          style: pw.TextStyle(
                            color: primaryColor,
                            fontSize: 26,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 12),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'ijevo',
                            style: pw.TextStyle(
                              color: darkNavy,
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'OFFICIAL TRANSFER RECEIPT',
                            style: pw.TextStyle(
                              color: textSecondary,
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#ECFDF5'),
                      borderRadius: pw.BorderRadius.circular(20),
                      border: pw.Border.all(color: primaryColor, width: 1),
                    ),
                    child: pw.Text(
                      'STATUS: SENT',
                      style: pw.TextStyle(
                        color: primaryColor,
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 24),
              pw.Divider(color: borderColor, thickness: 1),
              pw.SizedBox(height: 20),

              // 2. Amount Summary Card
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: pw.BoxDecoration(
                  color: surfaceColor,
                  borderRadius: pw.BorderRadius.circular(16),
                  border: pw.Border.all(color: borderColor),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Delivered Amount',
                      style: pw.TextStyle(color: textSecondary, fontSize: 12),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      payoutFormatted,
                      style: pw.TextStyle(
                        color: primaryColor,
                        fontSize: 32,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'to ${tx.recipientName}',
                      style: pw.TextStyle(
                        color: darkNavy,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 24),

              // 3. Detailed Transaction Data
              pw.Text(
                'TRANSACTION DETAILS',
                style: pw.TextStyle(
                  color: textSecondary,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              pw.SizedBox(height: 12),

              _buildPdfRow('Reference Number', tx.referenceNumber, isBoldValue: true),
              _buildPdfRow('Transaction Date', dateFormatted),
              _buildPdfRow('Payment Method', tx.paymentMethod),
              _buildPdfRow('Recipient Bank / Institution', tx.recipientInstitution),
              _buildPdfRow('Recipient Account Number', tx.recipientAccount),
              _buildPdfRow('Amount Sent', sendFormatted),
              _buildPdfRow('Transfer Fee', 'FREE (${tx.sendCurrency} 0.00)', valueColor: primaryColor),
              _buildPdfRow(
                'Exchange Rate',
                '1 ${tx.sendCurrency} = ${numberFormat.format(tx.exchangeRate)} ${tx.payoutCurrency}',
              ),
              _buildPdfRow('Total Charged', sendFormatted, isBoldValue: true),

              pw.Spacer(),

              // 4. Security & Compliance Footer
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F1F5F9'),
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                      width: 8,
                      height: 8,
                      decoration: pw.BoxDecoration(
                        color: primaryColor,
                        shape: pw.BoxShape.circle,
                      ),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Expanded(
                      child: pw.Text(
                        'Verified & cryptographically secured by Ijevo Remittance Ltd. '
                        'Regulated money transmission. This receipt serves as official proof of payment.',
                        style: pw.TextStyle(color: textSecondary, fontSize: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/Ijevo_Receipt_${tx.referenceNumber}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildPdfRow(
    String label,
    String value, {
    bool isBoldValue = false,
    PdfColor? valueColor,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(color: PdfColor.fromHex('#64748B'), fontSize: 11),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              color: valueColor ?? PdfColor.fromHex('#0B192C'),
              fontSize: 11,
              fontWeight: isBoldValue ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
