/*  génère array exploitable par le générateur de PDF à partir d'un fichier csv contenant les slots de travail
on peut écrire la source directement dans le code:
  var pdfStringList = [
['  Date      ', 'heures comme instruit', 'heures standarts', 'heures comme instructeur', 'heures sur simulateur', 'Total', 'observation ', 'occurrences TWR', 'occurrences APP'],
[' 2020-02-04', ' NIL', ' NIL', ' 14.27', ' NIL', ' 14.27', ' NIL', ' 0', ' 3'],
[' 2020-02-05', ' NIL', ' NIL', ' 4.65', ' 1.1', ' 5.75', ' NIL', ' 2', ' 3'] ]

ou bien le générer à partir d'un fichier csv:
    var myRegister = DayByDayRegister('p1.csv');
    var pdfStringList = ArrayForPDF(dayByDayRegister : myRegister).toLLS();
puis plus loin dans le générateur::
    pw.Table.fromTextArray(context: context, data: pdfStringList),
*/


import 'constant.dart';
import 'workingslot.dart';

class RegisterLine { // '''éléments de la ligne du registre, used for the global register '''
  String date ='undefined date';
  double h_as_trainee = 0;
  double h_simulator = 0;
  double h_alone_on_position = 0;
  double h_as_instructor = 0;
  double h_total = 0;
  String observation = ''; // unprocessed, remain at '' all along and displays nothing

  int occurence_TWR = 0;
  int occurence_APP = 0;
  
  //suppr notes_de_tache et notes_journee (inutile car tout passe par notes_de_journee_et_de_tache)
  //String notes_de_tache = ''; // direct from WorkingSlot
  //String notes_journee = ''; // direct from WorkingSlot
  
  String notes_de_journee_et_de_tache = '';
  //String inCSVlineNumber; // supprimé inutuile à tester // direct from WorkingSlot
  bool isValid = true;// direct from WorkingSlot
  String errorText = '';// direct from WorkingSlot


  RegisterLine ( List <String> listOfStringfilteredRawWorkingSlot ){ 
    var workingSlot = WorkingSlot( listOfStringfilteredRawWorkingSlot );

    date = workingSlot.date;
    if ( workingSlot.isTrainee ){ h_as_trainee = workingSlot.total_decimal; }
    if ( workingSlot.isSeulOnThePosition ){ h_alone_on_position = workingSlot.total_decimal; }
    if ( workingSlot.isInstructor ){ h_as_instructor = workingSlot.total_decimal; }    
    if ( workingSlot.isSimulation ){ h_simulator = workingSlot.total_decimal; }

    h_total = workingSlot.total_decimal;
/*
    observation = eMPTYSTRINGVALUE;
    if (workingSlot.notes_de_tache != eMPTYSTRINGVALUE) {
      observation = 'notes_de_tache: ' + workingSlot.notes_de_tache + ', '; 
          }

    if (workingSlot.notes_journee != eMPTYSTRINGVALUE) {
      observation = observation + 'notes_journee: ' + workingSlot.notes_journee + ', '; 
    }
*/
    if( workingSlot.isWorthAnOccurrence ){
      if ( workingSlot.isTWR ){ occurence_TWR = 1; }
      if ( workingSlot.isAPP ){ occurence_APP = 1; }
    }

    //notes_de_tache = workingSlot.notes_de_tache;
    //notes_journee = workingSlot.notes_de_tache;// erreur? deux fois tache ??
    
    ////////////////////////////////
    //notes_de_journee_et_de_tache = ''; inutile car '' par initialisation
    if (workingSlot.notes_journee.isNotEmpty) { // atention il faut mettre != EMptystring value
      notes_de_journee_et_de_tache += 'Note de journée du ${workingSlot.date}: ${workingSlot.notes_journee}\n';      
    }
    if (workingSlot.notes_de_tache.isNotEmpty) { 
      notes_de_journee_et_de_tache += 'Note de tâche du ${workingSlot.date} (ligne ${workingSlot.lineNumber}): ${workingSlot.notes_de_tache}\n';      
    }
    //inCSVlineNumber = workingSlot.lineNumber;
    isValid = workingSlot.isValid;
    if (workingSlot.validityError.isNotEmpty) {
      errorText = 'Créneau de travail non valide à la ligne ${workingSlot.lineNumber} à la date ${workingSlot.date}: erreur ${workingSlot.validityError}\n';  
    }
    
  }
  // direct constructor (to create TOTALINE or blank line)
  RegisterLine.intializeFrom (this.date, this.h_as_trainee, this.h_simulator, this.h_alone_on_position, this.h_as_instructor, this.h_total, this.observation, this.occurence_TWR, this.occurence_APP, this.notes_de_journee_et_de_tache, this.isValid, this.errorText); 

///////////////////////////////
/////
  String get taskAndDayNotes{ // tester
    return notes_de_journee_et_de_tache; 
  }

  String get warning{
    var w = eMPTYSTRINGVALUE; 
    if (h_total > (11.0 *0.80) ) { w = 'WARNING au $date: temps de repos apparemment trop faible';} 
    return w;
    }

  bool isSameDateAs(RegisterLine other) => date == other.date;  
  
  @override
  String toString(){
    return '${date}, ${h_as_trainee}, ${h_simulator}, ${h_alone_on_position}, ${h_as_instructor}, ${h_total}, ${observation}, ${occurence_TWR}, ${occurence_APP}';
    }

  void addWith( RegisterLine other ) { // caution no date check !
  //TODO: warning if different date, send to DbyD_RL otherr list to be shown at the end !
  h_as_trainee += other.h_as_trainee;
  h_simulator += other.h_simulator;
  h_alone_on_position += other.h_alone_on_position;
  h_as_instructor += other.h_as_instructor;
  h_total += other.h_total;
/*
  // 4 cases possible, sthing happens only if other.observation != eMPTYSTRINGVALUE (Can be done with if statement but more complex to debug)
  if (observation == eMPTYSTRINGVALUE && other.observation == eMPTYSTRINGVALUE) {  }// do nothing: observation is already at eMPTYSTRINGVALUE
  if (observation == eMPTYSTRINGVALUE && other.observation != eMPTYSTRINGVALUE) { observation = other.observation ; }
  if (observation != eMPTYSTRINGVALUE && other.observation == eMPTYSTRINGVALUE) {  }
  if (observation != eMPTYSTRINGVALUE && other.observation != eMPTYSTRINGVALUE) { observation = observation + ', ' + other.observation ; }
*/
  occurence_TWR += other.occurence_TWR;
  occurence_APP += other.occurence_APP;
  
  notes_de_journee_et_de_tache += other.notes_de_journee_et_de_tache ;
  //notes_journee += other.notes_journee;
  //notes_de_tache += other.notes_journee; 

  // no use to add errorText

  
 
  }

  List<String> toStringList(){
    var listResult = <String>[];
    
    for (var item in [date, h_as_trainee, h_simulator, h_alone_on_position, h_as_instructor, h_total, observation, occurence_TWR, occurence_APP] ) {
      if (item.runtimeType == double) { 
        item = toNaiveDouble2digit( item);
      }
      item = item.toString();
      if (item == '0.0') {
        item = eMPTYSTRINGVALUE;
        
      }
      listResult.add( item );
    }
    return listResult;
  }

}





double toNaiveDouble2digit(double x){
// [2.0, 2.0]
// [0.404, 0.4]
// [1.505, 1.5] naive because 1.505 shoulb be rounded to 1.51 and not 1.5
// [3.606, 3.61]
// [4.917, 4.92]
    return num.parse(x.toStringAsFixed(2));

  }


