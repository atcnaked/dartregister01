

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> main() async {
  // must be of type List<List<dynamic>>
  var sourceDatas = [
              ['mIL_______ Date NIL', 'heures comme instruit', 'heures standarts NIL', 'heures comme instructeur', 'heures sur simulateur', 'NIL Total NIL', 'NIL observation NIL', 'NIL occurrences TWR', 'NIL occurrences APP'],
              ['NIL Date NIL', 'heures comme instruit', 'heures standarts NIL', 'heures comme instructeur', 'heures sur simulateur', 'NIL Total NIL', 'NIL observation NIL', 'NIL occurrences TWR', 'NIL occurrences APP'],
              ['NIL Date NIL', 'heures comme instruit', 'heures standarts NIL', 'heures comme instructeur', 'heures sur simulateur', 'NIL Total NIL', 'NIL observation NIL', 'NIL occurrences TWR', 'NIL occurrences APP'],
              ['1993', 'PDF 1.0', 'Acrobat 1'],
              ['2008', 'PDF 1.7', 'Acrobat 9'],
              ['2009', 'PDF 1.7', 'Acrobat 9.1'],
              ['2010', 'PDF 1.7', 'Acrobat X'],
              ['', '', ''],
              ['2017', 'PDF 2.0', 'Acrobat DC'],
            ];


  var sourceDatas2 = [
['  Date      ', 'heures comme instruit', 'heures standarts', 'heures comme instructeur', 'heures sur simulateur', 'Total', 'observation ', 'occurrences TWR', 'occurrences APP'],
[' 2020-02-04', ' NIL', ' NIL', ' 14.27', ' NIL', ' 14.27', ' NIL', ' 0', ' 3'],
[' 2020-02-05', ' NIL', ' NIL', ' 4.65', ' 1.1', ' 5.75', ' NIL', ' 2', ' 3'],
[' 2020-02-06', ' NIL', ' NIL', ' 5.59', ' NIL', ' 5.59', ' NIL', ' 2', ' 4'],
[' 2020-02-10', ' NIL', ' NIL', ' 4.15', ' NIL', ' 4.15', ' NIL', ' 1', ' 2'],
[' 2020-02-11', ' NIL', ' NIL', ' 5.32', ' NIL', ' 5.32', ' NIL', ' 0', ' 3'],
[' 2020-02-12', ' NIL', ' NIL', ' 5.45', ' NIL', ' 5.45', ' NIL', ' 0', ' 3'],
[' 2020-02-16', ' NIL', ' NIL', ' 1.47', ' NIL', ' 1.47', ' NIL', ' 1', ' 0'],
[' 2020-02-17', ' NIL', ' NIL', ' 6.83', ' NIL', ' 6.83', ' NIL', ' 0', ' 4'],
[' 2020-02-18', ' NIL', ' NIL', ' 8.08', ' NIL', ' 8.08', ' NIL', ' 2', ' 0'],
[' 2020-02-22', ' NIL', ' NIL', ' 5.31', ' NIL', ' 5.31', ' NIL', ' 1', ' 2'],
[' 2020-02-23', ' NIL', ' NIL', ' 6.2', ' NIL', ' 6.2', ' NIL', ' 1', ' 4'],
[' 2020-02-24', ' NIL', ' NIL', ' 5.68', ' NIL', ' 5.68', ' NIL', ' 1', ' 3'],
[' 2020-02-28', ' NIL', ' NIL', ' 3.65', ' 2.22', ' 5.87', ' NIL', ' 2', ' 2'],
[' 2020-02-29', ' NIL', ' NIL', ' 4.5', ' NIL', ' 4.5', ' NIL', ' 1', ' 1'],
[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
[' Total', ' NIL', ' NIL', ' 81.15', ' 3.32', ' 84.47', ' NIL', ' 14', ' 34']
  ];




  //var pdfStringList = sourceDatas;
  var pdfStringList = sourceDatas2;


  final doc = pw.Document(pageMode: PdfPageMode.outlines);

  doc.addPage(pw.MultiPage(
      pageFormat:
        PdfPageFormat.a4.copyWith(marginBottom: 1.5 * PdfPageFormat.cm).landscape,

      crossAxisAlignment: pw.CrossAxisAlignment.start,
      // header A GARDER pour l'instant pour les exemple de chiffre non compris
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const pw.BoxDecoration(
                border: pw.Border(
                    bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey))),
            child: pw.Text('Portable Document Format',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      // footer A GARDER pour l'instant pour les exemple de chiffre non compris
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },

      build: (pw.Context context) => <pw.Widget>[
              pw.Padding(padding: const pw.EdgeInsets.all(10)),
              pw.Paragraph(
                text:
                    'Je, soussigné GAUTIER Frédéric, atteste sur l\'honneur que l\'extrait du registre fourni ci-dessous est exact.'),
              
              pw.Paragraph(
                text:
                    'Fait à Clermont-Ferrand, le ___date___'),
              pw.Padding(padding: const pw.EdgeInsets.all(10)),
              pw.Table.fromTextArray(context: context, data: pdfStringList),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
          ]));



    final file2 = File('example-reg2.pdf');
  await file2.writeAsBytes(await doc.save());
}


