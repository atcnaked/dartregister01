import 'constant.dart';
import 'csv_to_textlist.dart';
import 'registerline.dart';


class DayByDayRegister {
  //String textViewOfFile; // TODO: move out to be able to display it in case of instanciation pb
  List dayLines;
  RegisterLine totalLine; 
  String discardedWorkingSlotErrors = '';
  String taskAndDayNotes = '';
  String timeLimitWarning = '';


  DayByDayRegister (String fileName){ 
    var lines = getLinesFromFile(fileName);

    //textViewOfFile = textOf(lines);

    var monthlyReportWithHeaderRaw = monthlyReportWithHeaderRawFromLines(lines);    
    var slotBySlotRegister = slotBySlotRegisterFrom(monthlyReportWithHeaderRaw);

    dayLines = dayByDayRegisterFrom(slotBySlotRegister);
    
    totalLine = RegisterLine.intializeFrom ('Total', 0.0, 0.0, 0.0, 0.0, 0.0, eMPTYSTRINGVALUE, 0, 0, '', true, ''); 
    for (var item in dayLines) {
      totalLine.addWith(item);
      totalLine.observation = eMPTYSTRINGVALUE;     
    }

    timeLimitWarning = _timeLimitWarning;

  }


  List slotBySlotRegisterFrom(List monthlyReportWithHeaderRaw){
    // Ok I should have done things differently: 
    // 1) at CSV decoding I should have done a list of Map <header, String value> for each lines
    // 2) then Here producing filtered working slot would have been much more direct

    var slotBySlotRegister = [];
    var headerLine = monthlyReportWithHeaderRaw.removeAt(0);

    var header =  { 'date':'Date', 
                        'decimal total':'Total (decimal)' ,  
                                 'task':'Tâche', 
                            'task note':'Notes tâche', 
                             'day note':'Notes journée', };
    
    int date_index = headerLine.indexOf( header['date']); 
    int total_decimal_index = headerLine.indexOf( header['decimal total']);
    int taskLetter_index = headerLine.indexOf( header['task'] );
    int notes_de_tache_index = headerLine.indexOf( header['task note'] );
    int notes_journee_index = headerLine.indexOf( header['day note'] );

    var mandatoryHeaders = [date_index,  total_decimal_index, taskLetter_index, notes_de_tache_index, notes_journee_index];

    if (mandatoryHeaders.any((element) => (element == -1)  )) {
      var errorMessage = 'une ou plusieurs entête est absente: \n'
                          'un ou des mots suivants recherchés dans la première ligne du fichier n\'ont pas été trouvés: \n';
      for (var item in header.values) {
        errorMessage = errorMessage + item+ ', ' ;
      }

      errorMessage = errorMessage + 
      '\najouter les entêtes nécessaire à la bonne position entre des séparateurs (sans doute des virgules); \n' +
      'Un exemple de ligne qui fonctionne est: \n' +
      'Date,Démarrer,Terminer,Total (decimal),Tâche,Tâche ID,Tâche Extra 1, Tâche Extra 2,Client,Notes tâche,Jour Total,Notes journée';

      var myregException = Exception ('$errorMessage');
      throw(myregException); 
    }

/////// original


    var lineCounter = 2; // 2 car la ligne header occupe le numéro 1
    for (var rawWorkingSlot in monthlyReportWithHeaderRaw){
          // debug: en dessous si on met var ça pose un pb:
          //  type 'List<dynamic>' is not a subtype of type 'List<String>'
          // j'ai donc mis List<String>  et ça marche
          // la logique de vérification de type m'échappe...

          List<String> filteredRawWorkingSlot = [ rawWorkingSlot[date_index],
                                        rawWorkingSlot[total_decimal_index],
                                        rawWorkingSlot[taskLetter_index],
                                        rawWorkingSlot[notes_de_tache_index],
                                        rawWorkingSlot[notes_journee_index ],
                                        lineCounter.toString() ];
          var rl = RegisterLine(filteredRawWorkingSlot);
          slotBySlotRegister.add(rl);  
          lineCounter++;
      }    
    return slotBySlotRegister;
  }


  List dayByDayRegisterFrom(List slotBySlotRegister){
    // verif mais pas besoin cond while // if (slotBySlotRegister == []) { return []; }

    var dayByDayRegister = [];

    var nonEmptyDummyFirstLine = RegisterLine.intializeFrom ('nonEmptyDummyFirstLine', 0.0, 0.0, 0.0, 0.0, 0.0, eMPTYSTRINGVALUE, 0, 0, '', true, ''); 
    dayByDayRegister.add(nonEmptyDummyFirstLine);

    while ( slotBySlotRegister.isNotEmpty ) {       
      RegisterLine first_SbyS_RL = slotBySlotRegister.removeAt(0); 
      taskAndDayNotes += first_SbyS_RL.taskAndDayNotes; 

      var first_SbyS_RL_is_NOT_Valid = ! first_SbyS_RL.isValid;

      if (first_SbyS_RL_is_NOT_Valid) { 
        discardedWorkingSlotErrors += first_SbyS_RL.errorText;
      }else{
        RegisterLine last_DbyD_RL = dayByDayRegister.last; // here nonEmptyDummyFirstLine mandatory to make algo simpler
        last_DbyD_RL.toString();

        if (last_DbyD_RL.isSameDateAs( first_SbyS_RL ) ){
          last_DbyD_RL.addWith(first_SbyS_RL);
        }else{
          dayByDayRegister.add(first_SbyS_RL);
        }
      }
    }
    dayByDayRegister.removeAt(0);// remove nonEmptyDummyFirstLine
    return dayByDayRegister;
    }

    String get _timeLimitWarning{
    var timeLimitWarning = '';
    for (var rl in dayLines) {
      timeLimitWarning += rl.warningRL;   
    }
    return timeLimitWarning;
  }
}