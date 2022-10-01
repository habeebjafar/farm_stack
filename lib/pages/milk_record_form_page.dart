import 'package:farmapp/models/cattle_model.dart';
import 'package:farmapp/models/milk_model.dart';
import 'package:farmapp/provider/milk_provider.dart';
import 'package:farmapp/services/cattle_service.dart';
import 'package:farmapp/services/milk_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MilkFormPage extends StatefulWidget {
  final index;
  MilkFormPage({this.index});
  @override
  _MilkFormPageState createState() => _MilkFormPageState();
}

class _MilkFormPageState extends State<MilkFormPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  CattleService _cattleService = CattleService();
  List<String> _cattleMilkedList = [];
  List<String> _cattleIdList = [];
  String dropdownvalue = "";

  String milkCowRemark = "-Select cow milked-*";
  //var cattleId;

  @override
  void initState() {
    super.initState();
    _getAllCattles();

    noOfCattleMilkedController.text = "1";

    if (this.widget.index != null) _editValues();
  }

  @override
  void dispose(){
    
     noOfCattleMilkedController.dispose();
     totalMilkUsedController.dispose();
     totalMilkProducedController.dispose();
     milkingDateController.dispose();
    
    super.dispose();
    
  }

  _getAllCattles() async {
    var response = await _cattleService.getAllTCattles();
    print(response);

    response.forEach((data) {
      setState(() {
        var model = CattleModel();

        model.id = data['id'];
        model.cattleStage = data['cattleStage'];
        model.cattleName = data['cattleName'];
        model.cattleTagNo = data['cattleTagNo'];
        model.cattleArchive = data['cattleArchive'];
        model.cattleStatus = data['cattleStatus'];

        if (model.cattleStatus.toString() == "Lactating" &&
            model.cattleArchive.toString() == "All Active" &&
            (model.cattleStage.toString() == "Heifer" ||
                model.cattleStage.toString() == "Cow")) {
          //var cowMilked = "${model.cattleName.toString() + " (" +  model.cattleTagNo.toString() + ")" }";
          var cowMilked =  model.cattleTagNo.toString();
          _cattleMilkedList.add(cowMilked);
          var cowMilkedId = model.id.toString();
          _cattleIdList.add(cowMilkedId);

          
        }
      });
    });

    setState(() {
      dropdownvalue = _cattleMilkedList.isNotEmpty
          ? _cattleMilkedList.first.toString()
          : "";
    });
  }

  _editValues() {
    var provider = Provider.of<MilkProvider>(context, listen: false);
    milkingDateController.text =
        provider.milkRecordList[this.widget.index].milkDate!;
    totalMilkProducedController.text =
        provider.milkRecordList[this.widget.index].milkTotalProduced!;
    totalMilkUsedController.text =
        provider.milkRecordList[this.widget.index].milkTotalUsed!;
    noOfCattleMilkedController.text =
        provider.milkRecordList[this.widget.index].noOfCattleMilked!;
    selectedCowValue = provider.milkRecordList[this.widget.index].cowMilked!;
    selectedValue = provider.milkRecordList[this.widget.index].milkType!;
  }

  TextEditingController milkingDateController = TextEditingController();
  TextEditingController totalMilkProducedController = TextEditingController();
  TextEditingController totalMilkUsedController = TextEditingController();
  TextEditingController noOfCattleMilkedController = TextEditingController();
  String selectedValue = "-Select milk type-";
  String selectedCowValue = "-Select cow milked-";

  //List<String> mylist = [];

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text("-Select milk type-*"), value: "-Select milk type-"),
      DropdownMenuItem(child: Text("Bulk Milk"), value: "Bulk Milk"),
      DropdownMenuItem(
          child: Text("Individual Milk"), value: "Individual Milk"),
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
          milkingDateController.text =
              DateFormat('yyyy-MM-dd').format(_pickDate);
        }
      });
    }
  }

  _saveMilk() async {
    var milkModel = MilkModel();
    MilkService service = MilkService();
    milkModel.milkDate = milkingDateController.text;
    milkModel.milkTotalUsed = totalMilkUsedController.text;
    milkModel.milkTotalProduced = totalMilkProducedController.text;
    milkModel.milkType = selectedValue.toString();
    milkModel.cowMilked =
        selectedValue == "Individual Milk" ? dropdownvalue.toString() : "";
        milkModel.cattleId = selectedValue == "Individual Milk" ? _cattleIdList[_cattleMilkedList.indexOf(dropdownvalue)] : "";
       milkModel.noOfCattleMilked = selectedValue == "Bulk Milk" ? noOfCattleMilkedController.text : "";


    var response;
    if (this.widget.index != null) {
      var provider = Provider.of<MilkProvider>(context, listen: false);
      milkModel.id =   provider.milkRecordList[this.widget.index].id!;
      response = await service.updateMilk(milkModel);

    } else {
      response = await service.saveMilk(milkModel);
    }

    if (response > 0) {
      print("added successfully $response");
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (_) => MilkRecordPage()));
    } else {
      print("no value added");
    }
  }
  
      bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate() && !selectedValue.contains("-Select milk type-")) {
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
        title: Text("New Milk Record"),
        actions: [
          IconButton(
              onPressed: () async{
                var milkProvider = Provider.of<MilkProvider>(context, listen: false);
                 if (validateAndSave()) {

                   _saveMilk();
                   await milkProvider.getAllMilkRecord();
                   
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: milkingDateController,
                 validator: (input) => input!.length < 1 ? "Required" : null,
                onTap: () {
                  _selectTodoDate(context, 1);
                },
                readOnly: true,
                autofocus: false,
                // enabled: false,
                decoration: InputDecoration(
                    //hintText: 'YY-MM-DD',
        
                    labelText: 'Milking date.*',
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
                      labelText: "-Select milk type-*",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  //dropdownColor: Colors.blueAccent,
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                      print("checking seleced value $selectedValue");
                      if(selectedValue == "Individual Milk"){
                        if(_cattleMilkedList.length == 0){
        
                          setState(() {
                            milkCowRemark = "Cannot populate cows in the field below. No lactating cows found. Have you updated your cow statuses yet?";
                          });
        
        
                        }
        
        
                      }
                    });
        
                    
                  },
                  items: dropdownItems),
              SizedBox(
                height: 20,
              ),
              selectedValue == "Individual Milk"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(milkCowRemark,
                          style: TextStyle(fontSize: 16,
                          color: _cattleMilkedList.length == 0 ? Colors.orange : Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            size: 30,
                          ),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              //hintText: "Cattle name. *",
                              //labelText: "--Select the cattle's breed--",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          value: dropdownvalue,
                          //icon: Icon(Icons.keyboard_arrow_down),
                          items: _cattleMilkedList.map((String items) {
                            return DropdownMenuItem(
                                value: items, child: Text(items));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    )
                  : Container(),
              TextFormField(
                controller: totalMilkProducedController,
                 validator: (input) => input!.length < 1 ? "Required" : null,
                  keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //hintText: "Cattle name. *",
                    labelText: "Total milk produced.*",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: totalMilkUsedController,
                 validator: (input) => input!.length < 1 ? "Required" : null,
                  keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //hintText: "Cattle name. *",
                    labelText: "Total used (Calves/consumption).*",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 20,
              ),
              selectedValue == "Bulk Milk"
                  ? TextFormField(
                      controller: noOfCattleMilkedController,
                       validator: (input) => input!.length < 1 ? "Required" : null,
                  keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 20.0),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          //hintText: "Cattle name. *",
                          labelText: "Number of cattle milked.*",
                          //hintText: "2",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )
                  : Container(),
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
