// for eMPTYSTRINGVALUE
import 'constant.dart';
import 'daybydayregister.dart';


class ArrayForPDF {
  List<List<String>> _arrayForPDF;

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
    _arrayForPDF = array;
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
    for (var line in _arrayForPDF) {
      print(line);      
    }
  }

/* special method that print arrayForPDF in the terminal with the symbol"" */
  void displaySpecial(){
    print('display');
    for (var line in _arrayForPDF) {
      var resultLine = [];
      for (var item in line) {
        resultLine.add('" ' + item + '"');        
      }
      print(resultLine);      
    }
  }


  List<List<String>> toLLS(){
    return _arrayForPDF;
  }

  List<List<String>> get arrayForPDF {
    return _arrayForPDF;
  }

}