
import 'constant.dart';
import 'csv_to_textlist.dart';
import 'registerline.dart';


class DayByDayRegister {
  List dayLines;
  RegisterLine totalLine;
  // ici on devrait rajouter:
  
  // discarded WS List <int, String> with line number in csv + their error message
  // a get to have the numbers of th discarded WS (short info message)
  // List of Warning addWith date pb
  // +   List of observations of normal RL as date + OBS

  DayByDayRegister (String fileName){ 
    var monthlyReportWithHeaderRaw = monthlyReportWithHeaderRawFrom(fileName);
    var slotBySlotRegister = slotBySlotRegisterFrom(monthlyReportWithHeaderRaw);
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

    for (var rawWorkingSlot in monthlyReportWithHeaderRaw){
          // debug: en dessous si on met var ça pose un pb:
          //  type 'List<dynamic>' is not a subtype of type 'List<String>'
          // j'ai donc mis List<String>  et ça marche
          // la logique de vérification de type m'échappe...
          List<String> filteredRawWorkingSlot = [ rawWorkingSlot[date_index],
                                        rawWorkingSlot[total_decimal_index],
                                        rawWorkingSlot[taskLetter_index],
                                        rawWorkingSlot[notes_de_tache_index],
                                        rawWorkingSlot[notes_journee_index ] ];
          // ici on peut mettre un check si any vide alors pas de rl mais où mettre 
          var rl = RegisterLine(filteredRawWorkingSlot);
          slotBySlotRegister.add(rl);  
      }    
    return slotBySlotRegister;
  }


  List dayByDayRegisterFrom(List slotBySlotRegister){
    var dayByDayRegister = [];
    print('slotBySlotRegister.length: ${slotBySlotRegister.length}');///////////////////////////////////
    // todo:  empty check on slotBySlotRegister!
    RegisterLine toProcessRL = slotBySlotRegister.removeAt(0); 
    // todo:  empty checktoProcessRL!
    dayByDayRegister.add(toProcessRL);

    while ( slotBySlotRegister.isNotEmpty ) { 
      // print(slotBySlotRegister.length);
      RegisterLine first_SbyS_RL = slotBySlotRegister.removeAt(0); 
      RegisterLine last_DbyD_RL = dayByDayRegister.last; 
      last_DbyD_RL.toString();

      if (last_DbyD_RL.isSameDateAs( first_SbyS_RL ) ){
        last_DbyD_RL.addWith(first_SbyS_RL);
      }else{
        dayByDayRegister.add(first_SbyS_RL);
      }
    }
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