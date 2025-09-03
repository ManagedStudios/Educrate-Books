import 'dart:typed_data';

import 'package:buecherteam_2023_desktop/Data/book.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<Uint8List> createBasicBookListPdf(int classLevel, List<Book> books) async {
  final doc = pw.Document();
  final font = await PdfGoogleFonts.helvetica();

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Class $classLevel: ${books.length}',
              style: pw.TextStyle(font: font, fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8.0),
                  child: pw.Text(
                    '${book.name} ${book.subject}',
                    style: pw.TextStyle(font: font, fontSize: 18),
                  ),
                );
              },
            ),
          ],
        );
      },
    ),
  );

  return doc.save();
}
