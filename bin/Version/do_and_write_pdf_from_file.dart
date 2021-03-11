

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'slot_register_class_w_header_extract.dart';

Future<void> main({String fileName = 'p1.csv'}) async {
    var myRegister = DayByDayRegister(fileName);
    var sourceDatas3 = ArrayForPDF(dayByDayRegister : myRegister).toLLS();

      var warnings = myRegister.warnings;
    print('warnings: ');
    print(warnings);
    var observations = myRegister.observations;
    print('observations: ');
    print(observations);


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


// pdfStringList alimente le tableau PDF

  var pdfStringList = sourceDatas3;

  final doc = pw.Document(pageMode: PdfPageMode.outlines);

  doc.addPage(pw.MultiPage(
      pageFormat:
        PdfPageFormat.a4.copyWith(marginBottom: 1.5 * PdfPageFormat.cm).landscape,

      crossAxisAlignment: pw.CrossAxisAlignment.start,

      build: (pw.Context context) => <pw.Widget>[
              //pw.Padding(padding: const pw.EdgeInsets.all(1)),///////////////
              pw.Paragraph(
                text:
                    'Je, soussigné GAUTIER Frédéric, atteste sur l\'honneur que l\'extrait du registre fourni ci-dessous est exact.'),
              
              pw.Paragraph(
                text:
                    'Fait à Clermont-Ferrand, le ___date___'),
              //pw.Padding(padding: const pw.EdgeInsets.all(10)),
              pw.Table.fromTextArray(context: context, data: pdfStringList,//
                cellPadding : const pw.EdgeInsets.all(3), //default 5
                // cellHeight : 20, //default 0   // sans effet sur cellule pleine mais oui sur cellule  vide
               defaultColumnWidth : pw.IntrinsicColumnWidth(), //default 
        columnWidths: <int, pw.TableColumnWidth>{
          //0: const pw.IntrinsicColumnWidth(),
          //1: const pw.FlexColumnWidth(2), 
          //2: const pw.FractionColumnWidth(.2),
          //3: const pw.IntrinsicColumnWidth(),
          //4: const pw.IntrinsicColumnWidth(),
          //5: const pw.IntrinsicColumnWidth(),
          6: const pw.FlexColumnWidth(1),
          //7: const pw.IntrinsicColumnWidth(),
          //8: const pw.FixedColumnWidth(10),
        },),
            //pw.Padding(padding: const pw.EdgeInsets.all(10)),
          ]));



  DateTime _now = DateTime.now();
  String timestamp = '${_now.year}-${_now.month}-${_now.day}_${_now.hour}${_now.minute}${_now.second}';
  // imperfection: only 1 figure for month (3 instead of 03)

  final file2 = File('registre_$timestamp.pdf');
  await file2.writeAsBytes(await doc.save());

  print('fait');
}


