import 'package:farmapp/models/transactions_model.dart';
import 'package:farmapp/pages/receipt.dart';
import 'package:farmapp/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DataSummaryPage extends StatefulWidget {
  @override
  _DataSummaryPageState createState() => _DataSummaryPageState();
}

class _DataSummaryPageState extends State<DataSummaryPage> {
  // var transProvider;
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

    // transProvider = Provider.of<TransactionsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Transactions"),
          actions: [
            IconButton(onPressed: () {
              Navigator.push(context,
               MaterialPageRoute(
                builder: (context) => Receipt(searchDateOne: _searchDateOne, searchDateTwo: _searchDateTwo)
               ));

            }, icon: Icon(Icons.picture_as_pdf)),
            popupMenuWidget()
          ],
        ),
        body: FutureBuilder(
            future: Provider.of<TransactionsProvider>(context, listen: false)
                .getAllTransactionsRecord(
                    dateSearch: _searchDateOne, dateSearchTwo: _searchDateTwo),
            builder: (BuildContext context,
                AsyncSnapshot<List<TransactionsModel>> snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$selectedRange",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black54),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Income",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.orange)),
                        Divider(
                          thickness: 1,
                        ),
                        Consumer<TransactionsProvider>(
                          builder: (_, incomeProvider, __) => incomeProvider
                                      .incomeTransListSearch.length ==
                                  0
                              ? Center(
                                  child: Text(
                                  " ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.orange),
                                ))
                              : ListView.builder(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: incomeProvider
                                      .incomeTransListSearch.length,
                                  itemBuilder: (BuildContext context, index) {
                                    var incomeType = incomeProvider
                                                .incomeTransListSearch[index]
                                                .type ==
                                            "Category Income"
                                        ? incomeProvider
                                            .incomeTransListSearch[index]
                                            .selectedValueCategory
                                        : incomeProvider
                                                    .incomeTransListSearch[
                                                        index]
                                                    .type ==
                                                "Other (specify)"
                                            ? incomeProvider
                                                .incomeTransListSearch[index]
                                                .otherIncomeExpense
                                            : incomeProvider
                                                .incomeTransListSearch[index]
                                                .type;

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "$incomeType",
                                            style: TextStyle(
                                              //fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              //color: Colors.orange
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                              "${incomeProvider.incomeTransListSearch[index].amount}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.green))
                                        ],
                                      ),
                                    );
                                  }),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black54)),
                              Consumer<TransactionsProvider>(
                                builder: (_, totalIncomeProvider, __) => Text(
                                    "${totalIncomeProvider.totalIncomeSearch}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.orange)),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 9,
                        ),
                        Divider(
                          thickness: 3,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text("Expenses",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.orange)),
                        Divider(
                          thickness: 1,
                        ),
                        Consumer<TransactionsProvider>(
                          builder: (_, expenseProvider, __) => expenseProvider
                                      .expenseTransListSearch.length ==
                                  0
                              ? Center(
                                  child: Text(
                                  " ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.orange),
                                ))
                              : ListView.builder(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: expenseProvider
                                      .expenseTransListSearch.length,
                                  itemBuilder: (BuildContext context, index) {
                                    var expenseType = expenseProvider
                                                .expenseTransListSearch[index]
                                                .type ==
                                            "Category Expense"
                                        ? expenseProvider
                                            .expenseTransListSearch[index]
                                            .selectedValueCategory
                                        : expenseProvider
                                                    .expenseTransListSearch[
                                                        index]
                                                    .type ==
                                                "Other (specify)"
                                            ? expenseProvider
                                                .expenseTransListSearch[index]
                                                .otherIncomeExpense
                                            : expenseProvider
                                                .expenseTransListSearch[index]
                                                .type;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("$expenseType",
                                              style: TextStyle(
                                                //fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                //color: Colors.orange
                                              )),
                                          Text(
                                              "${expenseProvider.expenseTransListSearch[index].amount}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.green))
                                        ],
                                      ),
                                    );
                                  }),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black54)),
                              Consumer<TransactionsProvider>(
                                builder: (_, totalExpenseProvider, __) => Text(
                                    "${totalExpenseProvider.totalExpenseSearch}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.orange)),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(
                          thickness: 3,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Net:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black54)),
                              Consumer<TransactionsProvider>(
                                builder: (_, netProfit, __) => Text(
                                    "${netProfit.totalIncomeSearch - netProfit.totalExpenseSearch}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.orange)),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                      ],
                    ),
                  ),
                );
              }
            }));
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



  _groupValue(String? value){

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
            dateFormatOne = DateFormat('dd/MM/yyyy')
                .format(_searchDateOne!)
                .substring(0, 10);

            if (value == "3") {
              selectedRange =
                  "Last 3 Months\n($dateFormatOne - $dateFormatTwo)";
            } else if (value == "6") {
              selectedRange =
                  "Last 6 Months\n($dateFormatOne - $dateFormatTwo)";
            } else if (value == "12") {
              selectedRange =
                  "Last 12 Months\n($dateFormatOne - $dateFormatTwo)";
            }
          }else{
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
                      var dateFormatOne =
              DateFormat('dd/MM/yyyy').format(_searchDateOne!).substring(0, 10);
               var dateFormatTwo =
            DateFormat('dd/MM/yyyy').format(_searchDateTwo!).substring(0, 10);
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
