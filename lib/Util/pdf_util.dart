import 'dart:typed_data';

import 'package:buecherteam_2023_desktop/Data/book.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<Uint8List> createBasicBookListPdf(int classLevel, List<Book> books) async {
  final doc = pw.Document();

  final latoRegular = await PdfGoogleFonts.latoRegular();
  final latoBold = await PdfGoogleFonts.latoBold();

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start, // This aligns all children to the left
          children: [
            pw.Text(
              '${TextRes.basicTrainingDirection}${TextRes.hyphen}${TextRes.books} $classLevel${TextRes.classLevel} \n'
                  '${TextRes.amount}${books.length}',
              style: pw.TextStyle(font: latoBold, fontSize: 40),
            ),
            pw.SizedBox(height: 30),

            // --- THE FIX IS HERE ---
            // Instead of ListView, use a simple 'for' loop to generate widgets.
            // This places each book directly into the Column, respecting its alignment.
            // ... inside the for loop ...
            for (final book in books)
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 12.0),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // The checkbox character prefix
                    pw.Text(
                      '☐ ', // This is the Unicode character for an empty box
                      style: pw.TextStyle(font: latoRegular, fontSize: 35),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Expanded(
                      child: pw.RichText(
                        text: pw.TextSpan(
                          style: pw.TextStyle(font: latoRegular, fontSize: 30),
                          children: <pw.TextSpan>[
                            pw.TextSpan(
                              text: '${book.subject}: ',
                              style: pw.TextStyle(font: latoBold),
                            ),
                            pw.TextSpan(text: book.name),
                          ],
                        ),
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

  return doc.save();
}