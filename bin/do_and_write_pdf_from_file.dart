import 'arrayforpdf.dart';
import 'reg_pdf_generator.dart';

Future<void> main({String theFileName = 'p1.csv',String signatureFullName = 'GAUTIER Frédéric'}) async {

  // myRegister object creation
    var myRegister = ArrayForPDF(fileName : theFileName); // Exception raised if unable

    // some objects are available before print
    print('myRegister.discardedWorkingSlotErrors: ');
    print(myRegister.discardedWorkingSlotErrors);
    print('myRegister.taskAndDayNotes: ');
    print(myRegister.taskAndDayNotes);
    print('myRegister.timeLimitWarning: ');
    print(myRegister.timeLimitWarning);
    // 3 choix pour la preview:
    // on peut utiliser arrayForPDF et envoyer vers un Table
    // on peut générer une liste de text = TextList: à générer depuis arrayForPDF
    // on peut générer un text d'un bloc: à générer depuis TextList

  var sourceDatas3 =  myRegister.arrayForPDF; 

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

  var pdfStringList = sourceDatas3; // pdfStringList alimente le tableau PDF

  // PDF file creation
  await generatePDF(signatureFullName, pdfStringList);// Exception raised if unable

}


