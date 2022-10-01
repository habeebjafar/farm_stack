import 'package:farmapp/models/milk_model.dart';
import 'package:farmapp/pages/milk_report_pdf.dart';
import 'package:farmapp/provider/milk_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MilkReportPage extends StatefulWidget {
  @override
  _MilReportPageState createState() => _MilReportPageState();
}

class _MilReportPageState extends State<MilkReportPage> {
  // var provider;

  String? _groupSelectedValue;
  DateTime? _searchDateOne;
  DateTime? _searchDateTwo;
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  DateTime _date = DateTime.now();

  String? selectedRange;

  _selectRangeDate(BuildContext context) async {
    DateTime _dateOne = DateTime.now();
    var _pickDate = await showDatePicker(
        context: context,
        initialDate: _dateOne,
        firstDate: DateTime(2000),
        lastDate: DateTime(2099));
    if (_pickDate != null) {
      setState(() {
        startDate.text = DateFormat('yyyy-MM-dd').format(_pickDate);
      });
    }
  }

  _selectRangeDateTwo(BuildContext context) async {
    DateTime _dateTwo = DateTime.now();
    var _pickDate = await showDatePicker(
        context: context,
        initialDate: _dateTwo,
        firstDate: DateTime(2000),
        lastDate: DateTime(2099));
    if (_pickDate != null) {
      setState(() {
        endDate.text = DateFormat('yyyy-MM-dd').format(_pickDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchDateOne = new DateTime(_date.year, _date.month, 01);
    _groupSelectedValue = "0";
    selectedRange = "Current Month";
    // provider = Provider.of<MilkProvider>(context, listen: false);
    // provider.getAllMilkRecord(dateSearch: _searchDateOne, dateSearchTwo: _searchDateTwo);

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Milk Report"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                   MaterialPageRoute(
                    builder: (context) => MilkReportPDF(searchDateOne: _searchDateOne, searchDateTwo: _searchDateTwo)
                   ));
                },
                icon: Icon(Icons.picture_as_pdf)),
            popupMenuWidget()
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<MilkProvider>(context, listen: false)
                .getAllMilkRecord(
                    dateSearch: _searchDateOne, dateSearchTwo: _searchDateTwo),
            builder: (BuildContext context,
                AsyncSnapshot<List<MilkModel>> snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return SingleChildScrollView(
              child: Consumer<MilkProvider>(
            builder: (_, milkProvider, __) =>
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
              // SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "$selectedRange",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Milk Summary:",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
        
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Daily mllk average",
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${milkProvider.averageDailyMilk}",
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
        
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total milk produced",
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${milkProvider.totalMilkedProduced}",
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
        
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total milk for calves/used",
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${milkProvider.totalMilkedUsed}",
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
        
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Most productive cow",
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${milkProvider.highestProductive}(${milkProvider.highestProductiveCow})",
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
        
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Least productive cow",
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${milkProvider.leastProductive}(${milkProvider.leastProductiveCow})",
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
        
              SizedBox(
                height: 5,
              ),
        
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Records:",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
        
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 2),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 1.8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Day",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 16),
                      ),
                      Text(
                        "Produced",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 16),
                      ),
                      Text(
                        "Used",
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w900,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
        
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: milkProvider.milkRecordListDateSearch.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 1.8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${milkProvider.milkRecordListDateSearch[index].milkDate!.substring(5)}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16),
                            ),
                            Text(
                              "${milkProvider.milkRecordListDateSearch[index].milkTotalProduced}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16),
                            ),
                            Text(
                              "${milkProvider.milkRecordListDateSearch[index].milkTotalUsed}",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    );
                  })
            ]),
          )
          );
              }    
                }
        
        )
        );
  }

  _groupSelectedValueOnchanged(String? value) async {
    if (value != "14") {
      setState(() {});
    }
    _groupValue(value);

    Navigator.pop(context);
  }

  Widget popupMenuWidget() {
    return PopupMenuButton(
      onSelected: (String? value) async {
        if (value != "14") {
          setState(() {});
        }

        _groupValue(value);
      },
      icon: Icon(Icons.filter_list),
      itemBuilder: (context) => [
        PopupMenuItem(
            value: "7",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Last 7 Days"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "7",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "0",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Current Month"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "0",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "1",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Last Month"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "1",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "3",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Last 3 Months"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "3",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "6",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Last 6 Months"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "6",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "12",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Last 12 Months"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "12",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "13",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("All Time"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "13",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "14",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Custom Range"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "14",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
      ],
    );
  }

  _groupValue(String? value) {
    DateTime date = new DateTime.now();
    var dateFormatOne;
    var dateFormatTwo;
    var currentDate = DateTime(date.year, date.month, date.day);
    dateFormatTwo =
        DateFormat('dd/MM/yyyy').format(currentDate).substring(0, 10);

    if (value == "7") {
      _searchDateOne =
          new DateTime(date.year, date.month, date.day - int.parse(value!));
      dateFormatOne =
          DateFormat('dd/MM/yyyy').format(_searchDateOne!).substring(0, 10);
      selectedRange = "Last 7 Days\n($dateFormatOne - $dateFormatTwo)";
      _searchDateTwo = null;
    } else if (value == "1") {
      _searchDateTwo =
          new DateTime(date.year, date.month - int.parse(value!), 01);
      dateFormatOne =
          DateFormat('dd/MM/yyyy').format(_searchDateTwo!).substring(0, 10);
      var prevMonth = new DateTime(date.year, date.month, 0);
      dateFormatTwo =
          DateFormat('dd/MM/yyyy').format(prevMonth).substring(0, 10);
      selectedRange = "Last Month\n($dateFormatOne - $dateFormatTwo)";
      print("last day $dateFormatOne");
      _searchDateOne = null;
    } else if (value == "13") {
      _searchDateOne = new DateTime(date.year - 50, 01, 01);
      selectedRange = "All Time";
      _searchDateTwo = null;
    } else if (value == "14") {
      _editCategoryDialog();
    } else {
      _searchDateOne =
          new DateTime(date.year, date.month - int.parse(value!), 01);
      _searchDateTwo = null;

      if (value != "0") {
        dateFormatOne =
            DateFormat('dd/MM/yyyy').format(_searchDateOne!).substring(0, 10);

        if (value == "3") {
          selectedRange = "Last 3 Months\n($dateFormatOne - $dateFormatTwo)";
        } else if (value == "6") {
          selectedRange = "Last 6 Months\n($dateFormatOne - $dateFormatTwo)";
        } else if (value == "12") {
          selectedRange = "Last 12 Months\n($dateFormatOne - $dateFormatTwo)";
        }
      } else {
        selectedRange = "Current Month";
      }
    }

    _groupSelectedValue = value;
  }

  _editCategoryDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Date Range"),
            content: SingleChildScrollView(
              child: Form(
                key: globalKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: startDate,
                      validator: (input) =>
                          input!.length < 1 ? "Required" : null,
                      onTap: () {
                        _selectRangeDate(context);
                      },
                      readOnly: true,
                      autofocus: false,
                      // enabled: false,
                      decoration: InputDecoration(
                          //hintText: 'YY-MM-DD',

                          labelText: 'Start Date ... *',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
                    TextFormField(
                      controller: endDate,
                      validator: (input) =>
                          input!.length < 1 ? "Required" : null,
                      onTap: () {
                        _selectRangeDateTwo(context);
                      },
                      readOnly: true,
                      autofocus: false,
                      // enabled: false,
                      decoration: InputDecoration(
                          //hintText: 'YY-MM-DD',

                          labelText: 'End Date ... *',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          prefixIcon: InkWell(
                              onTap: () {
                                //  _selectTodoDate(context);
                              },
                              child: Icon(Icons.calendar_today))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.orange),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "CANCEL",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                onPressed: () async {
                  if (validateAndSave()) {
                    setState(() {
                      _searchDateOne = DateTime.parse(startDate.text);
                      _searchDateTwo = DateTime.parse(endDate.text);
                      var dateFormatOne = DateFormat('dd/MM/yyyy')
                          .format(_searchDateOne!)
                          .substring(0, 10);
                      var dateFormatTwo = DateFormat('dd/MM/yyyy')
                          .format(_searchDateTwo!)
                          .substring(0, 10);
                      selectedRange =
                          "Custom Range\n($dateFormatOne - $dateFormatTwo)";

                      startDate.clear();
                      endDate.clear();
                    });
                  }

                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
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
}
