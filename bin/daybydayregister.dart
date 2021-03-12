
import 'constant.dart';
import 'csv_to_textlist.dart';
import 'registerline.dart';


class DayByDayRegister {
  List dayLines;
  RegisterLine totalLine;
  // ici on devrait rajouter 3 éléments: 
  // sumup String = a get to have the numbers of th discarded WS (short info message) build from dayByDayRegisterFrom
  String discardedWorkingSlotSummary = '';
  // discarded WS List <int, String> with line number in csv + their error message build from dayByDayRegisterFrom
  String discardedWorkingSlotErrors = '';
  // List of all notes task + day (+ validity) build from slotBySlotRegisterFrom
  String taskAndDayNotes = '';

  DayByDayRegister (String fileName){ 
    var monthlyReportWithHeaderRaw = monthlyReportWithHeaderRawFrom(fileName);
    // ici il faudrait meix passer par 
    var slotBySlotRegister = slotBySlotRegisterFrom(monthlyReportWithHeaderRaw);
    // ici slotBySlotRegister  n est pas abimé donc on peut extraire des infos globales dessus


    dayLines = dayByDayRegisterFrom(slotBySlotRegister);
    
    totalLine = RegisterLine.intializeFrom ('Total', 0.0, 0.0, 0.0, 0.0, 0.0, eMPTYSTRINGVALUE, 0, 0); 
    for (var item in dayLines) {
      totalLine.addWith(item);
      totalLine.observation = eMPTYSTRINGVALUE;     
    }
  }


  List slotBySlotRegisterFrom(List monthlyReportWithHeaderRaw){
    // Ok I should have done things differently: 
    // 1) at CSV decoding I should have done a list of Map <header, String value> for each lines
    // 2) then Here producing filtered working slot would have been much more direct

    var slotBySlotRegister = [];

    int date_index;
    int total_decimal_index;
    int taskLetter_index;
    int notes_de_tache_index;
    int notes_journee_index;

    var headerLine = monthlyReportWithHeaderRaw.removeAt(0);
    var index = 0;

    for (var title in headerLine) {
          switch(title) { 
              case 'Date': {  date_index = index; } 
              break; 
            
              case 'Total (decimal)': {  total_decimal_index = index; } 
              break; 
            
              case 'Tâche': {  taskLetter_index = index; } 
              break; 
            
              case 'Notes tâche': {  notes_de_tache_index = index; } 
              break; 
            
              case 'Notes journée': {  notes_journee_index = index; } 
              break;  
          } 
          index++;
        }
    var lineCounter = 2; // 2 car la ligne header occupe le numéro 1
    for (var rawWorkingSlot in monthlyReportWithHeaderRaw){
          // debug: en dessous si on met var ça pose un pb:
          //  type 'List<dynamic>' is not a subtype of type 'List<String>'
          // j'ai donc mis List<String>  et ça marche
          // la logique de vérification de type m'échappe...

          ////////////////////////////////////////////
          ///
          ///lineCounter.toString(),  à f !!!!!!!!!!!!!!!!!!!!!!!!
          /////////////////////////////////////////////////////
          List<String> filteredRawWorkingSlot = [ rawWorkingSlot[date_index],
                                        rawWorkingSlot[total_decimal_index],
                                        rawWorkingSlot[taskLetter_index],
                                        rawWorkingSlot[notes_de_tache_index],
                                        rawWorkingSlot[notes_journee_index ],
                                        lineCounter.toString() ];
          // ici on peut mettre un check si any vide alors pas de rl mais où mettre 
          var rl = RegisterLine(filteredRawWorkingSlot);
          slotBySlotRegister.add(rl);  
          lineCounter++;
      }    
    return slotBySlotRegister;
  }


  List dayByDayRegisterFrom(List slotBySlotRegister){
    // verif mais pas besoin cond while // if (slotBySlotRegister == []) { return []; }

    var dayByDayRegister = [];

    var nonEmptyDummyFirstLine = RegisterLine.intializeFrom ('dummy£ ', 0.0, 0.0, 0.0, 0.0, 0.0, eMPTYSTRINGVALUE, 0, 0); 
    dayByDayRegister.add(nonEmptyDummyFirstLine);

    while ( slotBySlotRegister.isNotEmpty ) {       
      RegisterLine first_SbyS_RL = slotBySlotRegister.removeAt(0); 

      //////////////////////
      // TODO //on alimente taskAndDayNotes avec 
      var taskAndDayNotesOffirst_SbyS_RL = '${first_SbyS_RL.notes_journee}${first_SbyS_RL.notes_de_tache}${first_SbyS_RL.date}';
      // TODO// f un get ds RL      
      taskAndDayNotes = taskAndDayNotes + taskAndDayNotesOffirst_SbyS_RL;

      var first_SbyS_RL_is_NOT_Valid = ! first_SbyS_RL.isValid;
      if (first_SbyS_RL_is_NOT_Valid) {
        // TODO//on alimente 
        // discardedWorkingSlotSummary avec
        first_SbyS_RL.date; // et
        first_SbyS_RL.inCSVlineNumber;
        
        // TODO//et discardedWorkingSlotErrors avec
        first_SbyS_RL.date; // et
        first_SbyS_RL.inCSVlineNumber;// et
        first_SbyS_RL.validityError;
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

    String get warnings{
    var warnings = '';
    for (var rl in dayLines) {
      if (rl.warning != eMPTYSTRINGVALUE) { warnings = warnings + ', ' + rl.date + ': ' + rl.warning;        
      }
    }
    return warnings;
  }

  String get observations {
    var observations = '';
    for (var rl in dayLines) {
      if (rl.observation != eMPTYSTRINGVALUE) { 
        observations = observations + ' OBSERVATION: ' + rl.date + ': ' + rl.observation;        
      }
    }
    return observations;
  }


}