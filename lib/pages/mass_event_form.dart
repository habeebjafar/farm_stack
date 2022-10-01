import 'package:farmapp/models/event_model.dart';
import 'package:farmapp/pages/mass_event.dart';
import 'package:farmapp/provider/events_provider.dart';
import 'package:farmapp/services/event_service.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MassEventForm extends StatefulWidget {
  final index;

  MassEventForm({this.index});

  @override
  _MassEventFormState createState() => _MassEventFormState();
}

class _MassEventFormState extends State<MassEventForm> {

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    numOfCattlesController.text = "1";
    if(this.widget.index != null)  _editValues();
  }

    @override
  void dispose(){
    
     eventDateController.dispose();
     numOfCattlesController.dispose();
     noteController.dispose();
     nameOfMedicineController.dispose();
    
    super.dispose();
    
  }

  var response;

  TextEditingController eventDateController = TextEditingController();
   TextEditingController numOfCattlesController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  TextEditingController nameOfMedicineController = TextEditingController();
  String selectedValue = "Select event type. *";

  EventService _eventService = EventService();
  //List<String> mylist = [];

  String otherLabel = "Name of medicine given.*";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text("Select event type. *"), value: "Select event type. *"),
      DropdownMenuItem(
          child: Text("Vacination/Injection"), value: "Vacination/Injection"),
      DropdownMenuItem(child: Text("Herd spraying"), value: "Herd Spraying"),
      // DropdownMenuItem(child: Text("Deworming"), value: "Deworming"),
      DropdownMenuItem(
          child: Text("Treatment/Medication"), value: "Treatment/Medication"),
      // DropdownMenuItem(child: Text("Hoof Trimming"), value: "Hoof Trimming"),
      DropdownMenuItem(child: Text("Tagging"), value: "Tagging"),
      DropdownMenuItem(child: Text("Other"), value: "Other"),
    ];

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

  _editValues() {
    var provider = Provider.of<EventsProvider>(context, listen: false);
    eventDateController.text =
        provider.massEventsList[this.widget.index].eventDate!;
    numOfCattlesController.text =
        provider.massEventsList[this.widget.index].numOfCattles!;
    noteController.text =
        provider.massEventsList[this.widget.index].eventNotes!;
    nameOfMedicineController.text =
        provider.massEventsList[this.widget.index].nameOfMedicine!;
    selectedValue =
        provider.massEventsList[this.widget.index].eventType!;
   
  }

  _saveEvent() async {
    var eventModel = EventModel();

    eventModel.eventDate = eventDateController.text;

    eventModel.eventNotes = noteController.text;
    eventModel.numOfCattles = numOfCattlesController.text;
    eventModel.eventType = selectedValue.toString();

    eventModel.nameOfMedicine = nameOfMedicineController.text;

    var response; 

     if(this.widget.index != null){
      var provider = Provider.of<EventsProvider>(context, listen: false);
      eventModel.id =  provider.massEventsList[this.widget.index].id;
        response = await _eventService.updateEvent(eventModel);

     } else{
        response = await _eventService.saveEvent(eventModel);
     }
    
  

    if (response > 0) {
      print("added successfully $response");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MassEvent()));
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
        title: Text("New Mass Event"),
        actions: [
          IconButton(
              onPressed: () async{

                   if (validateAndSave()) {
                   _saveEvent();

                 await Provider.of<EventsProvider>(context, listen: false).getAllMassEventRecord(getAll: "All");
                  Navigator.pop(context);
                }
               
              },
              icon: Icon(
                Icons.gpp_good,
              ))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
          key: globalKey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
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
                      // labelText: "-Select milk type-*",
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
                      controller: numOfCattlesController,
                      validator: (input) => input!.length < 1 ? "Required" : null,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 20.0),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          //hintText: "Cattle name. *",
                          labelText: "Number of Cattles",
                          //hintText: "2",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ), 

                    SizedBox(
                      height: 20,
                    ),
                    
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
      ),
    );
  }
}
