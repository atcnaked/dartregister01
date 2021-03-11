import 'dart:io';
import 'dart:convert';
// import 'tonaivedoubletwodigit.dart';

var eMPTYSTRINGVALUE = 'NIL'; 

// TODO faire cas où le champs date est non conforme, ou même n'imorte quel champs pas bon: WARNING
// create a list of infos: warning, obs, etc
class WorkingSlot {
  /*
  Map <String, String> sws = { "date":"", "demarrer":"" ,"terminer":"" ,"total_decimal":"", 
                            "tache":"", "tache_ID":"", "tache_Extra_1":"", "tache_Extra":"", 
                            "client":"", "notes_tache":"", "jour_Total":"", "notes_journee":"" };
                            */

  
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

  

   
  WorkingSlot( List<String> workingSlotAsStringList ){

    // à priori il faut filtrer les entrées et trouver l index de date , total_decimal
    // la ligne serait alors date = workingSlotAsStringList[index_date];
    date = workingSlotAsStringList[0];

    total_decimal = double.parse(workingSlotAsStringList[3] );
    total_decimal = toNaiveDouble2digit(total_decimal); // separated line for digit round

    var taskLetter = workingSlotAsStringList[4];
    if ( taskLetter == 'trn') { 
      isTrainee = true ;
    }
    if ( taskLetter == 'Sim') { 
      isSimulation = true ;
    }
    if (taskLetter[0] == 'o'){
      if ( total_decimal >= 0.25){ isWorthAnOccurrence = true; };
      switch (taskLetter[1]) {
      case 'a':{
        isAPP = true;      
        break;}
      case 't':{
        isTWR = true;      
        break;}
      print('erreur de descriptif de tache');      
      break;        
      }
      switch (taskLetter[2]) {
      case 's':{                  // s signifie seul sur la position
        isSeulOnThePosition = true; 
        break;}
      case 'i':{
        isInstructor = true;     
        break;}
      print('erreur de descriptif de statut');        
      break;        
      }
    }
    else{
      print('trigramme de tache impossible à analyser');
    }
    notes_de_tache = workingSlotAsStringList[9];   
    notes_journee = workingSlotAsStringList[11];

  }  
}

class RegisterLine { // '''éléments de la ligne du registre, used for the global register '''
  String date ='undefined date';
  double h_as_trainee = 0;
  double h_simulator = 0;
  double h_alone_on_position = 0;
  double h_as_instructor = 0;
  double h_total = 0;
  String observation; 
  int occurence_TWR = 0;
  int occurence_APP = 0;


  RegisterLine ( List <String> listOfStringWorkingSlot ){ 

    var workingSlot = WorkingSlot( listOfStringWorkingSlot );

    date = workingSlot.date;
    if ( workingSlot.isTrainee ){ h_as_trainee = workingSlot.total_decimal; }
    if ( workingSlot.isSeulOnThePosition ){ h_alone_on_position = workingSlot.total_decimal; }
    if ( workingSlot.isInstructor ){ h_as_instructor = workingSlot.total_decimal; }    
    if ( workingSlot.isSimulation ){ h_simulator = workingSlot.total_decimal; }

    h_total = workingSlot.total_decimal;

    observation = eMPTYSTRINGVALUE;
    if (workingSlot.notes_de_tache != eMPTYSTRINGVALUE) {
      observation = 'notes_de_tache: ' + workingSlot.notes_de_tache + ', '; 
          }

    if (workingSlot.notes_journee != eMPTYSTRINGVALUE) {
      observation = observation + 'notes_journee: ' + workingSlot.notes_journee + ', '; 
    }

    if( workingSlot.isWorthAnOccurrence ){
      if ( workingSlot.isTWR ){ occurence_TWR = 1; }
      if ( workingSlot.isAPP ){ occurence_APP = 1; }
    }
}
  // direct constructor (to create TOTALINE or blank line)
  RegisterLine.intializeFrom (this.date, this.h_as_trainee, this.h_simulator, this.h_alone_on_position, this.h_as_instructor, this.h_total, this.observation, this.occurence_TWR, this.occurence_APP); 

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

  void addWith( RegisterLine other ) {
  h_as_trainee += other.h_as_trainee;
  h_simulator += other.h_simulator;
  h_alone_on_position += other.h_alone_on_position;
  h_as_instructor += other.h_as_instructor;
  h_total += other.h_total;

  // 4 cases possible, sthing happens only if other.observation != eMPTYSTRINGVALUE (if statement TODO)
  if (observation == eMPTYSTRINGVALUE && other.observation == eMPTYSTRINGVALUE) {  }// do nothing: observation is already at eMPTYSTRINGVALUE
  if (observation == eMPTYSTRINGVALUE && other.observation != eMPTYSTRINGVALUE) { observation = other.observation ; }
  if (observation != eMPTYSTRINGVALUE && other.observation == eMPTYSTRINGVALUE) {  }
  if (observation != eMPTYSTRINGVALUE && other.observation != eMPTYSTRINGVALUE) { observation = observation + ', ' + other.observation ; }

  occurence_TWR += other.occurence_TWR;
  occurence_APP += other.occurence_APP;
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


class ArrayForPDF {
  List<List<String>> arrayForPDF;

  ArrayForPDF({DayByDayRegister dayByDayRegister ,bool interligne = true, bool replaceZeroByNothingInDayLines = true, bool replaceZeroByNothingInTotalLine = false})
  {
    List<List<String>> array = [];

    array.add( [' Date ', 'heures comme instruit', 'heures standarts ', 'heures comme instructeur', 'heures sur simulateur', ' Total ', ' observation ', ' occurrences TWR', ' occurrences APP'] );
    // TODO replaceZeroByNothingInDayLines: useless
    // TODO replaceZeroByNothingInTotalLine: useless
    for (var rl in dayByDayRegister.dayLines) {
      rl.observation = eMPTYSTRINGVALUE;
      array.add( rl.toStringList() );      
    }
    if (interligne = true) { array.add( ['', '', '', '', '', '', '', '', ''] ); }
    
    array.add( dayByDayRegister.totalLine.toStringList() );
    // print( dayByDayRegister.totalLine.toStringList() );
    arrayForPDF = array;
  }

  void display(){
    print('display');
    for (var line in arrayForPDF) {
      print(line);      
    }
  }

/* special method that print arrayForPDF in the terminal with the symbol"".
 it is retrieved and copied into the Flutter source file to create example that cannot be 
made from the Flutter software for the time being */
  void displaySpecial(){
    print('display');
    for (var line in arrayForPDF) {
      var resultLine = [];
      for (var item in line) {
        resultLine.add('" ' + item + '"');        
      }
      print(resultLine);      
    }
  }

  List<List<String>> toLLS(){
    print('toLLS');
    var result = [];
    for (var line in arrayForPDF) {
      var resultLine = [];
      for (var item in line) {
        resultLine.add(item);        
      }
      result.add(resultLine);      
    }
    return result;
  }

  List<List<String>> toLLS2(){
    return arrayForPDF;
  }

}
class DayByDayRegister {
  List dayLines;
  RegisterLine totalLine;

  DayByDayRegister (String fileName){ 
    var monthlyReportaw = monthlyReportRawFrom(fileName);
    var slotBySlotRegister = slotBySlotRegisterFrom(monthlyReportaw);
    dayLines = dayByDayRegisterFrom(slotBySlotRegister);
    
    totalLine = RegisterLine.intializeFrom ('Total', 0.0, 0.0, 0.0, 0.0, 0.0, eMPTYSTRINGVALUE, 0, 0); 
    for (var item in dayLines) {
      totalLine.addWith(item);
      totalLine.observation = eMPTYSTRINGVALUE;     
    }
  }
    
  List slotBySlotRegisterFrom(List monthlyReportaw){
    var slotBySlotRegister = [];
    for (var rawWorkingSlot in monthlyReportaw){
      var rl = RegisterLine(rawWorkingSlot);
      slotBySlotRegister.add(rl);
      }
    return slotBySlotRegister;
  }

  List dayByDayRegisterFrom(List slotBySlotRegister){
    var dayByDayRegister = [];
    RegisterLine toProcessRL = slotBySlotRegister.removeAt(0); // empty check on slotBySlotRegister!
    dayByDayRegister.add(toProcessRL);// empty checktoProcessRL!

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


  List monthlyReportRawFrom(String fileName) {
    return monthlyReportRawFromLines( getLinesFromFile(fileName) );
  }

  List getLinesFromFile(String fileName) {
    var data = File(fileName);  
    var lines = data.readAsLinesSync(encoding: latin1); // utf8 ou ascii possible
    return lines;
  }


  List monthlyReportRawFromLines(List<String> lines){
    var monthlyReportRaw = [];  
    var header = true;
   
    for (var line in lines) {
      // when not header line, split line on separator:    
      if (!header) {
        var fields = line.split(',');
        for ( var i = 0 ; i < fields.length; i++ ){  
          // on remplace les vides par eMPTYSTRINGVALUE                                         
          if ( fields[i].isEmpty ){ fields[i] = eMPTYSTRINGVALUE; } 
        }     
        monthlyReportRaw.add(fields);   
      }
      header = false;
    }
    return monthlyReportRaw;

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

double toNaiveDouble2digit(double x){
// [2.0, 2.0]
// [0.404, 0.4]
// [1.505, 1.5] naive because 1.505 shoulb be rounded to 1.51 and not 1.5
// [3.606, 3.61]
// [4.917, 4.92]
    return num.parse(x.toStringAsFixed(2));

  }



  
// A FAIRE: modif class registre pour pourvoir mettre les valeurs à partir des titres des colonnes (+ souple pour le futur).
// cas où le décodeur csv renvoit directement une liste de dictionnaires avec clé = titres colonnes
// on peut généraliser et cas où on recoit une liste de Map avec clé = numéro de colonne (personnalisable)
// voir photo avec 8 cas possibles



