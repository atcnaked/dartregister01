
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


Future generatePDF(String signatureFullName, List<List<String>> pdfStringList) async {
  
  
  final DateTime now = DateTime.now();
  final DateFormat todayFormatter = DateFormat('dd/MM/yyyy');
  final String todayDate = todayFormatter.format(now);
  
  final doc = pw.Document(pageMode: PdfPageMode.outlines);
  
  doc.addPage(pw.MultiPage(
      pageFormat:
        PdfPageFormat.a4.copyWith(marginBottom: 1.5 * PdfPageFormat.cm).landscape,
  
      crossAxisAlignment: pw.CrossAxisAlignment.start,
  
      build: (pw.Context context) => <pw.Widget>[
              //pw.Padding(padding: const pw.EdgeInsets.all(1)),///////////////
              pw.Paragraph(
                text:
                    'Je, soussigné $signatureFullName, atteste sur l\'honneur que l\'extrait du registre fourni ci-dessous est exact.'),
              
              pw.Paragraph(
                text:
                    'Fait à Clermont-Ferrand, le $todayDate'),
              //pw.Padding(padding: const pw.EdgeInsets.all(10)),
              pw.Table.fromTextArray(context: context, data: pdfStringList,//
                cellPadding : const pw.EdgeInsets.all(3), //default 5
                //cellAlignment : pw.Alignment.topRight, // marche mais peu lisible
                cellAlignment : pw.Alignment.topCenter,
                // cellHeight : 20, //default 0   // sans effet sur cellule pleine mais oui sur cellule  vide
               defaultColumnWidth : pw.IntrinsicColumnWidth(), //default 
        columnWidths: <int, pw.TableColumnWidth>{
          //0: const pw.IntrinsicColumnWidth(),
          //1: const pw.FlexColumnWidth(2), 
          //2: const pw.FractionColumnWidth(.2),
          6: const pw.FlexColumnWidth(1),
          //7: const pw.IntrinsicColumnWidth(),
          //8: const pw.FixedColumnWidth(10),
        },),
            //pw.Padding(padding: const pw.EdgeInsets.all(10)),
          ]));
  
  
  var underscorefullName = makeFullNameWithUnderscoreFrom(signatureFullName); 
  final DateTime now2 = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy_MM dd_HHmmss');
  final String timestamp = formatter.format(now2);
  final registerFileName ='${underscorefullName}LFLC_registre_$timestamp.pdf';
  
  final file2 = File(registerFileName);
  await file2.writeAsBytes(await doc.save());
  
  print('fichier PDF enregistré sous le nom: $registerFileName');
}

String makeFullNameWithUnderscoreFrom(String signatureFullName) {
   var result = '';
  for (var item in signatureFullName.split(' ')) {
    result += '${item.trim()}_';
  } 
  result.substring(1);
  return result;
}
