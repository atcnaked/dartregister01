

import 'constant.dart';

class WorkingSlot {

  String date;
  double total_decimal;
  bool isWorthAnOccurrence = false;
  bool isTrainee = false;
  bool isSimulation = false;
  bool isSeulOnThePosition = false;
  bool isInstructor = false;
  bool isTWR = false;
  bool isAPP = false;
  String notes_de_tache;
  String notes_journee;

  bool isValid = true;
  String validityError = '';

   
  WorkingSlot( List<String> workingSlotAsStringList ){
    date = workingSlotAsStringList[0]; 
    if (date == eMPTYSTRINGVALUE) { isValid = false; print('date = eMPTYSTRINGVALUE');}
    // date format validation too complicated

    String total_decimalStringData = workingSlotAsStringList[1];
    total_decimal = double.tryParse(total_decimalStringData) ?? 0;
    if (total_decimal == 0) { isValid = false; print('total_decimal = 0');}

    var taskLetter = workingSlotAsStringList[2];
    
    if (taskLetter.length >= 3) { // 3 first letters are mandatory
      switch (taskLetter[0]) {
        case 't':{
          if ( taskLetter == 'trn') { isTrainee = true ; } 
        } break;
        case 'S':{ 
          if ( taskLetter == 'Sim') { isSimulation = true ;}
        } break;
        case 'o':{ 
          if ( total_decimal >= 0.25){ isWorthAnOccurrence = true; };

          switch (taskLetter[1]) {
          case 'a':{
            isAPP = true;     
          } break;
          case 't':{
            isTWR = true;   
          } break;
          default: {
            validityError = validityError + 'erreur deuxième lettre du descriptif de tache\n'; 
            isValid = false;
          } break;                 
          }

          if (isValid) {
            switch (taskLetter[2]) { 
            case 's':{                  // s signifie seul sur la position
              isSeulOnThePosition = true; 
            } break;
            case 'i':{
              isInstructor = true;    
            } break;
            default: {validityError = validityError + 'erreur troisième lettre du descriptif de tache\n'; 
                      isValid = false; 
            } break;        
            }
            
          }

          
          
        } break; // it is the: case 'o' break
        default: { validityError = 'erreur première lettre du descriptif de tache\n';
                   isValid = false; 
        } break;

      }      
    } else {
      validityError = 'erreur descriptif de tache trop court\n';
      isValid = false; 
    }
    print(validityError);
    notes_de_tache = workingSlotAsStringList[3];  
    notes_journee = workingSlotAsStringList[4]; 
    // NB la note de journée figure dans un seul Working Slot pour une journée et pas dans tous comme ça aurait été possible

  }
}