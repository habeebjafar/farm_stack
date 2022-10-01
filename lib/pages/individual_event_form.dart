import 'package:farmapp/models/event_individual_model.dart';
import 'package:farmapp/pages/cattle_details_page.dart';
import 'package:farmapp/provider/cattle_provider.dart';
import 'package:farmapp/provider/events_provider.dart';
import 'package:farmapp/services/event_individual_service.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IndividualEventForm extends StatefulWidget {
  final  index;
  final eventIndex;

  IndividualEventForm({this.index, this.eventIndex});

  @override
  _IndividualEventFormState createState() => _IndividualEventFormState();
}

class _IndividualEventFormState extends State<IndividualEventForm> {
   GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  String selectedValue = "Select event type. *";

var provider ;
  @override
  void initState() {
     provider = Provider.of<CattleProvider>(context, listen: false);
    provider.getCattleById(this.widget.index);

    print("print this cattle ${provider.getCattleById(this.widget.index)}");


    if(this.widget.eventIndex != null)  _editValues();
    super.initState();
  }


    @override
  void dispose(){
    
     eventDateController.dispose();
     noteController.dispose();
     nameOfMedicineController.dispose();
    
    
    super.dispose();
    
  }

  TextEditingController eventDateController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  TextEditingController nameOfMedicineController = TextEditingController();
  

  EventIndividualService _eventService = EventIndividualService();

  String otherLabel = "Name of medicine given.*";


    List<DropdownMenuItem<String>> femaleMenuItem = [

      DropdownMenuItem(
          child: Text("Select event type. *"), value: "Select event type. *"),
      DropdownMenuItem(child: Text("Dry Off"), value: "Dry Off"),
      DropdownMenuItem(
          child: Text("Treated/Medicated"), value: "Treated/Medicated"),
      DropdownMenuItem(child: Text("Inseminated/Mated"), value: "Inseminated/Mated"),
      DropdownMenuItem(child: Text("Weighed"), value: "Weighed"),
      DropdownMenuItem(
          child: Text("Gave Birth"), value: "Gave Birth"),
      DropdownMenuItem(child: Text("Weaned"), value: "Weaned"),
      DropdownMenuItem(child: Text("Vaccinated"), value: "Vaccinated"),
      DropdownMenuItem(child: Text("Pregnant"), value: "Pregnant"),
      DropdownMenuItem(child: Text("Aborted Pregnancy"), value: "Aborted Pregnancy"),
      DropdownMenuItem(child: Text("Other"), value: "Other"),
  ];

   List<DropdownMenuItem<String>> maleMenuItem = [
     DropdownMenuItem(
          child: Text("Select event type. *"), value: "Select event type. *"),
      DropdownMenuItem(
          child: Text("Treated/Medicated"), value: "Treated/Medicated"),
      DropdownMenuItem(child: Text("Weighed"), value: "Weighed"),
      DropdownMenuItem(child: Text("Weaned"), value: "Weaned"),
      DropdownMenuItem(child: Text("Vaccinated"), value: "Vaccinated"),
      DropdownMenuItem(child: Text("Castrated"), value: "Castrated"),
      DropdownMenuItem(child: Text("Other"), value: "Other"),
  ];



  List<DropdownMenuItem<String>> get dropdownItems {
    var menuItems;

   
      if (provider.singleCattle[0]['cattleGender'] == "Male") {
        menuItems = maleMenuItem;
      } else if(provider.singleCattle[0]['cattleGender'] == "Female") {
        menuItems = femaleMenuItem;
      }
   

    return menuItems;
  }

  DateTime _date = DateTime.now();

  _selectTodoDate(BuildContext context, int? i) async {
    //mylist.last = "hello";

    var _pickDate = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2099));
    if (_pickDate != null) {
      setState(() {
        _date = _pickDate;
        if (i == 1) {
          eventDateController.text = DateFormat('yyyy-MM-dd').format(_pickDate);
        }
      });
    }
  }

  _editValues(){
     var provider = Provider.of<EventsProvider>(context, listen: false);

    eventDateController.text = provider.individualEventsList[this.widget.eventIndex].eventDate!;
    noteController.text = provider.individualEventsList[this.widget.eventIndex].eventNotes!;
    nameOfMedicineController.text = provider.individualEventsList[this.widget.eventIndex].nameOfMedicine!;
    selectedValue = provider.individualEventsList[this.widget.eventIndex].eventType!;
    
  }

  _saveEvent() async {
    var provider = Provider.of<CattleProvider>(context, listen: false);
    provider.getCattleById(this.widget.index);
    
    var eventModel = EventIndividualModel();

    eventModel.eventDate = eventDateController.text;
    eventModel.eventNotes = noteController.text;
    eventModel.eventType = selectedValue.toString();
    eventModel.nameOfMedicine = nameOfMedicineController.text;
    eventModel.cattleId = provider.singleCattle[0]['id'].toString();
    eventModel.cattleTagNo = provider.singleCattle[0]['cattleTagNo'];

    var response;

    if(this.widget.eventIndex != null){
      var provider = Provider.of<EventsProvider>(context, listen: false);
      eventModel.id =  provider.individualEventsList[this.widget.eventIndex].id;

 response = await _eventService.updateTodo(eventModel);
    } else {
 response = await _eventService.saveEvent(eventModel);
    }


   

    if (response > 0) {
      print("added successfully $response");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => CattleDetailsPage(this.widget.index)));
    } else {
      print("no value added");
    }
  }

    bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate() && !selectedValue.contains("Select event type. *")) {
      form.save();
      return true;
    }

    final snackBar = SnackBar(
      content: const Text('Please fill all the fields marked with (*)'),
   
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Event"),
        actions: [
          IconButton(
              onPressed: () async{
                     if (validateAndSave()) {
                   _saveEvent();

                 await Provider.of<EventsProvider>(context, listen: false).
                 getAllIndividualEventRecord(cattleId: this.widget.index, searchEventType: "All");
                  Navigator.pop(context);
                }
              },
              icon: Icon(
                Icons.gpp_good,
              ))
        ],
      ),
      body: FutureBuilder(
      future: provider.getCattleById(this.widget.index),
      builder: (BuildContext context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (provider.singleCattle.length == 0) {
            return Container(
              child: Text("No data"),
            );
          }
          return Consumer<CattleProvider>(builder: (_, cPro, __) => SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Form(
               key: globalKey,
              child: Column(
                children: [
                 
                  Container(
                    padding: EdgeInsets.fromLTRB(2, 7, 0, 7),
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white70,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "${cPro.singleCattle[0]['cattleTagNo']}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                  ),
                            ),
            
                               SizedBox(width: 10),
                            Text(
                              "-",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                  ),
                            ),
            
                               SizedBox(width: 10),
                            Text(
                              "${cPro.singleCattle[0]['cattleGender']}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                  ),
                            ),
                               SizedBox(width: 5),
                            Text(
                              "${cPro.singleCattle[0]['cattleStage']}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                  ),
                            ),
                          ],
                        ),
                     
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: eventDateController,
                     validator: (input) => input!.length < 1 ? "Required" : null,
                    onTap: () {
                      _selectTodoDate(context, 1);
                    },
                    readOnly: true,
                    autofocus: false,
                    // enabled: false,
                    decoration: InputDecoration(
                        //hintText: 'YY-MM-DD',
                  
                        labelText: 'Event date.*',
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        prefixIcon: InkWell(
                            onTap: () {
                              //  _selectTodoDate(context);
                            },
                            child: Icon(Icons.calendar_today))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 30,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          //hintText: "Cattle name. *",
                          //labelText: "-Select milk type-*",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      //dropdownColor: Colors.blueAccent,
                      value: selectedValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                          if (selectedValue == "Other") {
                            otherLabel = "Name of event. *";
                          } else {
                            otherLabel = "Name of medicine given.*";
                          }
                          print("checking seleced value $selectedValue");
                        });
                      },
                      items: dropdownItems),
                  SizedBox(
                    height: 20,
                  ),
                  selectedValue == "Vacination/Injection" ||
                          selectedValue == "Deworming" ||
                          selectedValue == "Treatment/Medication" ||
                          selectedValue == "Other"
                      ? TextFormField(
                          controller: nameOfMedicineController,
                           validator: (input) => input!.length < 1 ? "Required" : null,
                          style: TextStyle(fontSize: 20.0),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              //hintText: "Cattle name. *",
                              labelText: otherLabel,
                              //hintText: "2",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        )
                      : Container(),
                  selectedValue == "Vacination/Injection" ||
                          selectedValue == "Deworming" ||
                          selectedValue == "Treatment/Medication" ||
                          selectedValue == "Other"
                      ? SizedBox(
                          height: 20,
                        )
                      : Container(),
                  TextFormField(
                    controller: noteController,
                    maxLines: null,
                    minLines: 4,
                    style: TextStyle(fontSize: 20.0),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        //hintText: "Cattle name. *",
                        labelText: "Write some notes ...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )
        );
        }
        }
      ),
    );
  }
}
