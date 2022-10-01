import 'package:farmapp/pages/event_report_pdf.dart';
import 'package:farmapp/provider/cattle_provider.dart';
import 'package:farmapp/provider/events_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventsReportPage extends StatefulWidget {
  @override
  _EventsReportPageState createState() => _EventsReportPageState();
}

class _EventsReportPageState extends State<EventsReportPage> {
 
  // var cattleProvider;

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

 
  }

  @override
  Widget build(BuildContext context) {

    Provider.of<EventsProvider>(context, listen: false).getAllIndividualEventRecord(dateSearch: _searchDateOne, dateSearchTwo: _searchDateTwo);
    Provider.of<EventsProvider>(context, listen: false).getAllMassEventRecord(dateSearch: _searchDateOne, dateSearchTwo: _searchDateTwo);
    Provider.of<CattleProvider>(context, listen: false).getAllCattles("Unarchive Cattle",dateSearch: _searchDateOne, dateSearchTwo: _searchDateTwo);
    return Scaffold(
        appBar: AppBar(
          title: Text("Events Report"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventReportPDF(
                              searchDateOne: _searchDateOne,
                              searchDateTwo: _searchDateTwo)));
                },
                icon: Icon(Icons.picture_as_pdf)),
            popupMenuWidget()
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Consumer<EventsProvider>(
                builder: (_, eventProvider, __) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
                          width: double.infinity,
                          color: Theme.of(context).primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Individual Events:",
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
                                "Treated",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${eventProvider.treatededCattleEventsList.length}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
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
                                "Weaned",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${eventProvider.weanedCattleEventsList.length}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
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
                                "Gave Birth",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${eventProvider.birthedCattleEventsList.length}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
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
                                "Dry Offs",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${eventProvider.dryOffCattleEventsList.length}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
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
                                "Inseminated/Mated",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${eventProvider.matedCattleEventsList.length}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
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
                                "Abortions",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${eventProvider.abortedCattleEventsList.length}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
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
                                "Castrated",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${eventProvider.castratedCattleEventsList.length}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
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
                                "Vaccinated",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${eventProvider.vaccinatedCattleEventsList.length}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
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
                                "Weighed",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${eventProvider.weighedCattleEventsList.length}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
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
                                "Ohers",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${eventProvider.otherCattleEventsList.length}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
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
                                "Mass Events:",
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

      //mass starts here
                          
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Vaccination",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${eventProvider.vaccinatedCattleMassEventsList.length}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
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
                                "Herd spraying",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${eventProvider.herdSprayCattleMassEventsList.length}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
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
                                "Treatment",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${eventProvider.treatededCattleMassEventsList.length}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
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
                                "Tagging",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${eventProvider.taggedCattleMassEventsList.length}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
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
                                "Others",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${eventProvider.otherCattleMassEventsList.length}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
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
                      "Archives:",
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
// Archived cattles start here
            Consumer<CattleProvider>(
              builder: (_, cattleProvider, __) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Lost",
                            style:
                                TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${cattleProvider.lostCattleList.length}",
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
                            "Dead",
                            style:
                                TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${cattleProvider.deadCattleList.length}",
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
                            "Sold",
                            style:
                                TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${cattleProvider.soldCattleList.length}",
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
                            "Loaned",
                            style:
                                TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${cattleProvider.loanedCattleList.length}",
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
                            "Gifted",
                            style:
                                TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${cattleProvider.giftedCattleList.length}",
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
                            "Others",
                            style:
                                TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${cattleProvider.otherCattleList.length}",
                            style:
                                TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Container(
            //       padding: EdgeInsets.all(8),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text("Bulls"),
            //           Text("${_bulls.length}")
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            // Card(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Container(
            //       padding: EdgeInsets.all(8),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text("Steers"),
            //           Text("${_steers.length}")
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            // Card(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Container(
            //       padding: EdgeInsets.all(8),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text("Weaners"),
            //           Text("${_weaners.length}")
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            // Card(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Container(
            //       padding: EdgeInsets.all(8),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text("Calves"),
            //           Text("${_calves.length}")
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        )
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
