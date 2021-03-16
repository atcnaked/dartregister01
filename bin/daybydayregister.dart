
import 'dart:io';

import 'constant.dart';
import 'csv_to_textlist.dart';
import 'registerline.dart';


class DayByDayRegister {
  List dayLines;
  RegisterLine totalLine; 
  String discardedWorkingSlotErrors = '';
  String taskAndDayNotes = '';
  String timeLimitWarning = '';

  DayByDayRegister (String fileName){ 
    var monthlyReportWithHeaderRaw = monthlyReportWithHeaderRawFrom(fileName);
    // ici il faudrait meix passer par 
    var slotBySlotRegister = slotBySlotRegisterFrom(monthlyReportWithHeaderRaw);
    // ici slotBySlotRegister  n est pas abimé donc on peut extraire des infos globales dessus


    dayLines = dayByDayRegisterFrom(slotBySlotRegister);
    
    totalLine = RegisterLine.intializeFrom ('Total', 0.0, 0.0, 0.0, 0.0, 0.0, eMPTYSTRINGVALUE, 0, 0, '', true, ''); 
    for (var item in dayLines) {
      totalLine.addWith(item);
      totalLine.observation = eMPTYSTRINGVALUE;     
    }

    timeLimitWarning = _timeLimitWarning;

  }


  List slotBySlotRegisterFrom(List monthlyReportWithHeaderRaw){
    // Ok I should have done things differently: 
    // 1) at CSV decoding I should have done a list of Map <header, String value> for each lines
    // 2) then Here producing filtered working slot would have been much more direct

    var slotBySlotRegister = [];
    var headerLine = monthlyReportWithHeaderRaw.removeAt(0);

    var header =  { 'date':'Date', 
                        'decimal total':'Total (decimal)' ,  
                                 'task':'Tâche', 
                            'task note':'Notes tâche', 
                             'day note':'Notes journée', };
    
    int date_index = headerLine.indexOf( header['date']); 
    int total_decimal_index = headerLine.indexOf( header['decimal total']);
    int taskLetter_index = headerLine.indexOf( header['task'] );
    int notes_de_tache_index = headerLine.indexOf( header['task note'] );
    int notes_journee_index = headerLine.indexOf( header['day note'] );

    var mandatoryHeaders = [date_index,  total_decimal_index, taskLetter_index, notes_de_tache_index, notes_journee_index];
    ////////////////////////////////////////////////////////////////////////////////////////////////////
print('TODO gestion EXCEPTION une ou plusieurs entête est absente dans slotBySlotRegisterFrom(List monthlyReportWithHeaderRaw)');

    if (mandatoryHeaders.any((element) => (element == -1)  )) {
      var errorMessage = '''une ou plusieurs entête est absente: \n
                            un ou des mots suivants recherchés dans la première ligne du fichier n\'ont pas été trouvés: \n''';
      for (var item in header.values) {
        errorMessage = errorMessage + item+ ', ' ;
      }

      errorMessage = errorMessage + ''' Ajouter les entêtes nécessaire à la bonne 
                                    position entre des séparateurs (sans doute des virgules); \n
                                    Un exemple de ligne qui fonctionne est: \n
                                    Date,Démarrer,Terminer,Total (decimal),Tâche,Tâche ID,Tâche Extra 1,
                                    Tâche Extra 2,Client,Notes tâche,Jour Total,Notes journée''';
      print(errorMessage);
      exit(1); // 
    }

    var lineCounter = 2; // 2 car la ligne header occupe le numéro 1
    for (var rawWorkingSlot in monthlyReportWithHeaderRaw){
          // debug: en dessous si on met var ça pose un pb:
          //  type 'List<dynamic>' is not a subtype of type 'List<String>'
          // j'ai donc mis List<String>  et ça marche
          // la logique de vérification de type m'échappe...

          List<String> filteredRawWorkingSlot = [ rawWorkingSlot[date_index],
                                        rawWorkingSlot[total_decimal_index],
                                        rawWorkingSlot[taskLetter_index],
                                        rawWorkingSlot[notes_de_tache_index],
                                        rawWorkingSlot[notes_journee_index ],
                                        lineCounter.toString() ];
          var rl = RegisterLine(filteredRawWorkingSlot);
          slotBySlotRegister.add(rl);  
          lineCounter++;
      }    
    return slotBySlotRegister;
  }


  List dayByDayRegisterFrom(List slotBySlotRegister){
    // verif mais pas besoin cond while // if (slotBySlotRegister == []) { return []; }

    var dayByDayRegister = [];

    var nonEmptyDummyFirstLine = RegisterLine.intializeFrom ('nonEmptyDummyFirstLine', 0.0, 0.0, 0.0, 0.0, 0.0, eMPTYSTRINGVALUE, 0, 0, '', true, ''); 
    dayByDayRegister.add(nonEmptyDummyFirstLine);

    while ( slotBySlotRegister.isNotEmpty ) {       
      RegisterLine first_SbyS_RL = slotBySlotRegister.removeAt(0); 
      taskAndDayNotes += first_SbyS_RL.taskAndDayNotes; 

      var first_SbyS_RL_is_NOT_Valid = ! first_SbyS_RL.isValid;

      if (first_SbyS_RL_is_NOT_Valid) { 
        discardedWorkingSlotErrors += first_SbyS_RL.errorText;
      }else{
        RegisterLine last_DbyD_RL = dayByDayRegister.last; // here nonEmptyDummyFirstLine mandatory to make algo simpler
        last_DbyD_RL.toString();

        if (last_DbyD_RL.isSameDateAs( first_SbyS_RL ) ){
          last_DbyD_RL.addWith(first_SbyS_RL);
        }else{
          dayByDayRegister.add(first_SbyS_RL);
        }
      }
    }
    dayByDayRegister.removeAt(0);// remove nonEmptyDummyFirstLine
    return dayByDayRegister;
    }

    String get _timeLimitWarning{
    var timeLimitWarning = '';
    for (var rl in dayLines) {
      timeLimitWarning += rl.warningRL;   
    }
    return timeLimitWarning;
  }


/*
// pour test
  List<List<String>> get arrayForPDF {
      var arrayForPDF = [
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


    return arrayForPDF;
  }
*/

}