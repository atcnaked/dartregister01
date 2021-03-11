import 'dart:io';
import 'dart:convert';
import 'registerclass.dart';

// A FAIRE: modif class registre pour pourvoir mettre les valeurs à partir des titres des colonnes (+ souple pour le futur).
// cas où le décodeur csv renvoit directement une liste de dictionnaires avec clé = titres colonnes
// on peut généraliser et cas où on recoit une liste de Map avec clé = numéro de colonne (personnalisable)
// voir photo avec 8 cas possibles
// pb avec résultat = 4.2700000000000005 : pourquoi ces décimales (pas de division !!)

main() { 
String fileName = "p1.csv"; // pb avec p1court2.csv, ça génère un résultat 4.2700000000000005 ?

List monthlyReportaw = new List(); 
monthlyReportaw = getMonthlyReportRawFromFile(fileName);

List slotBySlotRegister = getSlotBySlotRegisterFrom (monthlyReportaw);

print("slotBySlotRegister");
for (var l in slotBySlotRegister){print(l.toString()) ;
  // ordonner selon date ?
}
print("collapse");
List dayByDayRegister = getDayByDayRegisterFrom (slotBySlotRegister);

print("dayByDayRegister"); 
dayByDayRegister.forEach(  (registerLine) {print( registerLine.toString() );}  );
print("ici fini !");

}
////////////////////////////////////////////////////////////////////////////////////////////////////



List getSlotBySlotRegisterFrom(List monthlyReportaw){
  var slotBySlotRegister = new List();
  for (var rawWorkingSlot in monthlyReportaw){
    RegisterLine rl = RegisterLine (rawWorkingSlot);
    slotBySlotRegister.add(rl);
    }
  return slotBySlotRegister;
}

List getDayByDayRegisterFrom(List slotBySlotRegister){
  var dayByDayRegister = new List();
  RegisterLine toProcessRL = slotBySlotRegister.removeAt(0); // empty check on slotBySlotRegister!
  dayByDayRegister.add(toProcessRL);// empty checktoProcessRL!

  while ( slotBySlotRegister.length != 0 ) { 
    print(slotBySlotRegister.length);
    RegisterLine first_SbyS_RL = slotBySlotRegister.removeAt(0); 
    RegisterLine last_DbyD_RL = dayByDayRegister.last; last_DbyD_RL.toString();

    if (last_DbyD_RL.isSameDateAs( first_SbyS_RL ) ){
      last_DbyD_RL.addWith(first_SbyS_RL);
    }else{
      dayByDayRegister.add(first_SbyS_RL);
    }
  }
  return dayByDayRegister;
  }


List getMonthlyReportRawFromFile(String fileName) {
  return getMonthlyReportRawFRomLines( getLinesFromFile(fileName) );
}

List getLinesFromFile(String fileName) {
  File data = new File(fileName);  
  List<String> lines = data.readAsLinesSync(encoding: latin1); // utf8 ou ascii possible
  return lines;
}


List getMonthlyReportRawFRomLines(List<String> lines){
  List monthlyReportRaw = new List();
  
  var header = true;
  String emptyStringValue = "NIL";
  for (var line in lines) {
    // when not header line, split line on separator:    
    if (!header) {
      List<String> fields = line.split(",");
      for ( int i = 0 ; i < fields.length; i++ ){  
        // on remplace les vides par NIL                                          
        if ( fields[i].length == 0 ){ fields[i] = emptyStringValue; } 
      }     
      monthlyReportRaw.add(fields);   
    }
    header = false;
  }
  return monthlyReportRaw;

}


// inutilisé
handleError(e) {
  print("An error $e occurred");
}
