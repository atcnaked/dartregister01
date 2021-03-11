

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> main() async {
  // must be of type List<List<dynamic>>
  var sourceDatas = [
               // data_titre =  ['NIL Date NIL', 'heures comme instruit', 'heures standarts NIL', 'heures comme instructeur', 'heures sur simulateur', 'NIL Total NIL', 'NIL observation NIL', 'NIL occurrences TWR', 'NIL occurrences APP']
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

  var pdfStringList = sourceDatas;



  // now I ve got to get a montRegisterWithBlankAndTotal

  // refaire complètement les classes p la suite , 
  // renommer WorkingSlot en WorkingSlots car c'est une liste de WorkingSlot, 
  // renommer les fct genre getReportFromFile(String filename) en reportFrom(String filename). 
    //Créer la classe Report ?
    
    // modulariser p avoir en sortie un fichier string ou typé + ligne total à part, 
    // intégrée, séparée d 1 ligne vide ou pas (option)



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


