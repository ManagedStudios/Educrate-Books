import 'dart:typed_data';

import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../Data/book.dart';

Future<Uint8List> createClassListPdf(ClassData classData, List<Student> students) async {
  final doc = pw.Document();
  final Map<BookLite, int> bookNumbers = {};
  int bookCounter = 1;

  // First, collect all unique books and assign them a number
  for (final student in students) {
    for (final book in student.books) {
      if (!bookNumbers.containsKey(book)) {
        bookNumbers[book] = bookCounter++;
      }
    }
  }

  final latoRegular = await PdfGoogleFonts.latoRegular();
  final latoBold = await PdfGoogleFonts.latoBold();

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      header: (pw.Context context) {
        return pw.Text(
          '${TextRes.classText} ${classData.getLabelText()}',
          style: pw.TextStyle(font: latoBold, fontSize: 20),
        );
      },
      footer: (pw.Context context) {
        final footnotes = bookNumbers.entries
            .map((entry) => '${entry.value}: ${entry.key.name}')
            .join(' | ');
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(height: 20),
            pw.Text(TextRes.footnotes, style: pw.TextStyle(font: latoBold)),
            pw.Text(footnotes, style: pw.TextStyle(font: latoRegular)),
          ],
        );
      },
      build: (pw.Context context) {
        // Define headers and styles for clarity
        final headers = [
          TextRes.studentName,
          TextRes.booksReceived,
          TextRes.signature,
          TextRes.notes
        ];
        final headerStyle = pw.TextStyle(font: latoBold);
        final cellStyle = pw.TextStyle(font: latoRegular);

        return [
          // ---- START: UPDATED CODE ----
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(3),
              3: const pw.FlexColumnWidth(3),
            },
            children: [
              // Header Row
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: headers.map((header) {
                  return pw.Padding( // Optional: Add padding for better looks
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(header, style: headerStyle, textAlign: pw.TextAlign.center),
                  );
                }).toList(),
              ),
              // Data Rows
              ...students.map((student) {
                final bookIds = student.books
                    .map((book) => bookNumbers[book])
                    .toSet() // Use a Set to remove duplicate book numbers
                    .toList() // Convert to list to sort
                      .join(', ');

                final rowData = [
                  '${student.firstName} ${student.lastName}',
                  bookIds,
                  '', // Signature
                  ''  // Notes
                ];

                return pw.TableRow(
                  children: rowData.map((cell) {
                    return pw.Padding( // Optional: Add padding
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(cell, style: cellStyle),
                    );
                  }).toList(),
                );
              }).toList(),
            ],
          ),
          // ---- END: UPDATED CODE ----
        ];
      },
    ),
  );

  return doc.save();
}

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