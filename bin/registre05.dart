import 'dart:io';
import 'dart:convert';
import 'slot_register_class.dart';

// A FAIRE: modif class registre pour pourvoir mettre les valeurs à partir des titres des colonnes (+ souple pour le futur).
// cas où le décodeur csv renvoit directement une liste de dictionnaires avec clé = titres colonnes
// on peut généraliser et cas où on recoit une liste de Map avec clé = numéro de colonne (personnalisable)
// voir photo avec 8 cas possibles

void main(List<String> args) {
  var myRegister = DayByDayRegister('p1.csv');
  var arrayForPDF = ArrayForPDF(dayByDayRegister : myRegister);
  arrayForPDF.displaySpecial();

  var warnings = myRegister.warnings;
  print('warnings: ');
  print(warnings);
  var observations = myRegister.observations;
  print('observations: ');
  print(observations);
  }
  