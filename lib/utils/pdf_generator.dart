import 'dart:io';

import 'package:adadeh_store/data/models/order_model.dart';
import 'package:adadeh_store/utils/currency_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  final OrderModel order;

  PdfGenerator(this.order);

  String getStatusText(String status) {
    if (status == 'success') {
      return 'Payment Success!';
    } else if (status == 'cancelled') {
      return 'Cancelled';
    } else if (status == 'pending') {
      return 'Pending';
    }

    return 'Payment Failed!';
  }

  Future<void> generatePdf(String filename) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text('Payment Status',
                    style: const pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 16),
                pw.Text('Status: ${getStatusText(order.status)}'),
                pw.Text(
                    'Amount: ${currencyFormatter(order.totalAmount.toInt())}'),
                pw.SizedBox(height: 16),
                pw.Text('Payment Method: ${order.paymentMethod.toUpperCase()}'),
                pw.Text('Status: ${order.status.toUpperCase()}'),
                pw.Text('Transaction ID: ${order.id}'),
                pw.Text('Customer ID: ${order.userId.substring(0, 16)} ...'),
                pw.Text(
                    'Transaction Date: ${DateTime.parse(order.orderDate).toLocal().toString().substring(0, 19)}'),
                pw.SizedBox(height: 16),
                pw.Divider(),
                ...order.products.map(
                  (product) => pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(product['name'],
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(
                              '${product['quantity']} x ${currencyFormatter(product['price'])}'),
                        ],
                      ),
                      pw.Text(
                          currencyFormatter(
                              product['quantity'] * product['price']),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Subtotal'),
                    pw.Text(currencyFormatter(order.totalPrice.toInt()),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Shipping cost'),
                    pw.Text(currencyFormatter(order.shippingCost.toInt()),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Admin fee'),
                    pw.Text(currencyFormatter(order.adminFee.toInt()),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total'),
                    pw.Text(currencyFormatter(order.totalAmount.toInt()),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            );
          },
        ),
      );

      final output = await getExternalStorageDirectory();
      var filePath = '${output?.path}/$filename.pdf';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
