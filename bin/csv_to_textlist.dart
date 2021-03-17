 
import 'dart:convert';
import 'dart:io';

import 'constant.dart';

List monthlyReportWithHeaderRawFrom(String fileName) {
    return monthlyReportWithHeaderRawFromLines( getLinesFromFile(fileName) );
    
  }

////// Here different options could be handle: XML file, other separator in CSV
  List getLinesFromFile(String fileName) {
    var data = File(fileName);  
    List lines;
    try {
      lines = data.readAsLinesSync(encoding: latin1); // utf8 ou ascii possible
    } on Exception catch(e){
      var myregException = Exception ('ouverture ou lecture fichier impossible, \n$e');
      throw(myregException);
    }       
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

    String textOf(List<String> lines){
    var textResult = ''; 
    for (var line in lines) {     
      textResult += line + '\n';  
    }
    return textResult;
  }