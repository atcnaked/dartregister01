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
import 'dart:io';
import 'dart:convert';

var eMPTYSTRINGVALUE = 'NIL'; // mettre if p le debug 

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

class RegisterLine { // '''éléments de la ligne du registre, used for the global register '''
  String date ='undefined date';
  double h_as_trainee = 0;
  double h_simulator = 0;
  double h_alone_on_position = 0;
  double h_as_instructor = 0;
  double h_total = 0;
  String observation; 
  // créer get observation et recopier les notes_de_tache et notes_journee 
  int occurence_TWR = 0;
  int occurence_APP = 0;


  RegisterLine ( List <String> listOfStringfilteredRawWorkingSlot ){ 
    var workingSlot = WorkingSlot( listOfStringfilteredRawWorkingSlot );

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

  void addWith( RegisterLine other ) { // caution no date check !
  //TODO: warning if different date, send to DbyD_RL otherr list to be shown at the end !
  h_as_trainee += other.h_as_trainee;
  h_simulator += other.h_simulator;
  h_alone_on_position += other.h_alone_on_position;
  h_as_instructor += other.h_as_instructor;
  h_total += other.h_total;

  // 4 cases possible, sthing happens only if other.observation != eMPTYSTRINGVALUE (Can be done with if statement but more complex to debug)
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
  // ici ajouter   List<String> warnings;
  // l info vient de dayByDayRegister 
  // dayByDayRegister contient les warnings de RL non conforme donc délaissées
  // chaque RL contiendra les warnings de dépassement de temps si RL conforme
  // ensuite il y a le pb des working line avec un champs nécessaire vide => warning où ?
  // il y a aussi le pb des durée = 0  ou du trigramme d activité non reconnu

  ArrayForPDF({DayByDayRegister dayByDayRegister ,bool interligne = true, bool replaceZeroByNothingInDayLines = true, bool replaceZeroByNothingInTotalLine = false})
  {
    List<List<String>> array = [];

    array.add( [' Date ', 'heures comme instruit', 'heures standarts ', 'heures comme instructeur', 'heures sur simulateur', ' Total ', '', ' occurrences TWR', ' occurrences APP'] );//' observation '

    for (var rl in dayByDayRegister.dayLines) {
      rl.observation = eMPTYSTRINGVALUE; // on n'affichera jamais aucun commentaire
      var rlStringList = rl.toStringList();
      rlStringList = replaceZeroByNothingIn(rlStringList);
      array.add( rlStringList );      
    }

    if (interligne = true) { array.add( ['', '', '', '', '', '', '', '', ''] ); }

    var totalLineStringList = dayByDayRegister.totalLine.toStringList();
    if (replaceZeroByNothingInDayLines) {
          totalLineStringList = replaceZeroByNothingIn(totalLineStringList);        
    }

    array.add(totalLineStringList);
    arrayForPDF = array;
  }

  List<String> replaceZeroByNothingIn(List<String> totalLineStringList) {
    for (var i = 0; i < totalLineStringList.length; i++) {
      if (totalLineStringList[i] == eMPTYSTRINGVALUE) {
        totalLineStringList[i] = '';
      }    
    }
    return totalLineStringList;
  }

  void display(){
    print('display');
    for (var line in arrayForPDF) {
      print(line);      
    }
  }

/* special method that print arrayForPDF in the terminal with the symbol"" */
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
    return arrayForPDF;
  }

}
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


  List monthlyReportWithHeaderRawFrom(String fileName) {
    return monthlyReportWithHeaderRawFromLines( getLinesFromFile(fileName) );
    
  }

  List getLinesFromFile(String fileName) {
    var data = File(fileName);  
    var lines = data.readAsLinesSync(encoding: latin1); // utf8 ou ascii possible
    return lines;
  }


  List monthlyReportWithHeaderRawFromLines(List<String> lines){
    var monthlyReportRaw = [];  
    // first line may be header
    for (var line in lines) {      
        var fields = line.split(',');
        for ( var i = 0 ; i < fields.length; i++ ){  
          // on remplace les vides par eMPTYSTRINGVALUE                                         
          if ( fields[i].isEmpty ){ fields[i] = eMPTYSTRINGVALUE; } 
        }     
        monthlyReportRaw.add(fields);      
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



