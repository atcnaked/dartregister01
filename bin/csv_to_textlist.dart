 
import 'dart:convert';
import 'dart:io';

import 'constant.dart';

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