import 'package:farmapp/models/expense_category_model.dart';
import 'package:farmapp/provider/transactions_provider.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'expense_category_page.dart';

class ExpensesForm extends StatefulWidget {
  final index;
  ExpensesForm({this.index});
  @override
  _ExpensesFormState createState() => _ExpensesFormState();
}

class _ExpensesFormState extends State<ExpensesForm> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  var expenseProvider;
  @override
  void initState() {
    super.initState();

    expenseProvider = Provider.of<TransactionsProvider>(context, listen: false);
    expenseProvider.getAllExpenseCategory();
     expenseProvider.selectedValueExpenseCategory = expenseProvider
                            .expenseCategoryNameList.isNotEmpty
                        ? expenseProvider.expenseCategoryNameList.first.toString()
                        : "";
    if (this.widget.index != null) _editValues();
  }

  TextEditingController expenseDateController = TextEditingController();
  TextEditingController amountSpentController = TextEditingController();
  TextEditingController receiptNoController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  TextEditingController subOptionController = TextEditingController();

  String selectedValue = "-Select expense type-*";



  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text("-Select expense type-*"), value: "-Select expense type-*"),
      
      DropdownMenuItem(child: Text("Category Expense"), value: "Category Expense"),
      DropdownMenuItem(
          child: Text("Other (specify)"), value: "Other (specify)"),
    ];

    return menuItems;
  }
  

   _editValues() {
    var provider = Provider.of<TransactionsProvider>(context, listen: false);
    expenseDateController.text =
        provider.expenseList[this.widget.index].expenseDate.toString();
    noteController.text =
        provider.expenseList[this.widget.index].expenseNotes.toString();
        selectedValue = provider.expenseList[this.widget.index].expenseType.toString();
 selectedValue == "Other (specify)"  ? provider.expenseList[this.widget.index].otherExpense.toString() : "";
    receiptNoController.text =
        provider.expenseList[this.widget.index].receiptNo!;
    amountSpentController.text = provider.expenseList[this.widget.index].amountSpent!;

    provider.selectedValueExpenseCategory = selectedValue == "Category Expense" ? provider.expenseList[this.widget.index].selectedValueExpenseCategory.toString() : "";

    
   
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
          expenseDateController.text =
              DateFormat('yyyy-MM-dd').format(_pickDate);
        }
      });
    }
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate() && !selectedValue.contains("-Select expense type-*")) {
      form.save();
      return true;
    }

    final snackBar = SnackBar(
      content: const Text('Please fill all the fields marked with (*)'),
      // action: SnackBarAction(
      //   label: 'Undo',
      //   onPressed: () {
      //     // Some code to undo the change.
      //   },
      // ),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Expense"),
        actions: [
          IconButton(
              onPressed: () async {
                if (validateAndSave()) {
                  expenseProvider.saveTrans(
                    "Expense",
                      expenseDateController.text,
                      noteController.text,
                      selectedValue,
                      "",
                      receiptNoController.text,
                      amountSpentController.text,
                      selectedValue == "Category Expense" ? expenseProvider.selectedValueExpenseCategory : "",
                       selectedValue == "Category Expense" ? 
                      expenseProvider.expenseCategoryIdList[expenseProvider.expenseCategoryNameList.indexOf(expenseProvider.selectedValueExpenseCategory)] : "",
                      selectedValue == "Other (specify)" ? subOptionController.text : "",
                      updateId: this.widget.index != null ? expenseProvider.expenseList[this.widget.index].id : null

                      );

                  await expenseProvider.getAllExpensesRecord();
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
                controller: expenseDateController,
                validator: (input) => input!.length < 1 ? "Required" : null,
                onTap: () {
                  _selectTodoDate(context, 1);
                },
                readOnly: true,
                autofocus: false,
                // enabled: false,
                decoration: InputDecoration(
                    //hintText: 'YY-MM-DD',

                    labelText: 'Date of Expense.*',
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
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      //hintText: "Cattle name. *",
                      // labelText: "-Select milk type-*",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  //dropdownColor: Colors.blueAccent,
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                     if (selectedValue == "Category Expense") {
                        expenseProvider.selectedValueExpenseCategory =
                            expenseProvider.expenseCategoryNameList.isNotEmpty
                                ? expenseProvider.expenseCategoryNameList.first
                                    .toString()
                                : "";
                      }
                      // print("checking seleced value $selectedValue");
                    });
                   
                  },
                  items: dropdownItems),
              SizedBox(
                height: 20,
              ),
              selectedValue == "Category Expense"
                  ? Row(
                      children: [
                        Expanded(
                          child: FutureBuilder(
                              future: Provider.of<TransactionsProvider>(context,
                                      listen: false)
                                  .getAllExpenseCategory(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<ExpenseCategoryModel>>
                                      snapShot) {
                                if (snapShot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                    child: Center(
                                        //child: CircularProgressIndicator(),
                                        ),
                                  );
                                } else {
                             
                                  return Consumer<TransactionsProvider>(
                                    builder: (_, provider, __) => provider.expenseCategoryNameList.length == 0 ?
                                    Container(
                                      child: TextFormField(
                                        enabled: false,
                                        style: TextStyle(fontSize: 20.0),
                                        decoration: InputDecoration(
                                            suffixIcon: Icon(
                                              Icons.arrow_drop_down,
                                              size: 35,
                                            ),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 15.0, 20.0, 15.0),
                                            //hintText: "Cattle name. *",

                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                      ),
                                    ):
                                        DropdownButtonFormField(
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.black),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        size: 30,
                                      ),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 15.0, 20.0, 15.0),
                                          //hintText: "Cattle name. *",
                                          // labelText: "-Select milk type-*",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      //dropdownColor: Colors.blueAccent,
                                      value:
                                          provider.selectedValueExpenseCategory,
                                      items: provider.expenseCategoryNameList
                                          .map((String items) {
                                        return DropdownMenuItem(
                                            value: items, child: Text(items));
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          provider.selectedValueExpenseCategory =
                                              newValue!;

                                          // print("checking seleced value $selectedValue");
                                        });
                                      },
                                    ),
                                  );
                                }
                              }),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ExpenseCategoryPage()));
                          },
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(
                              Icons.add,
                              size: 30,
                            ),
                            radius: 26,
                          ),
                        )
                      ],
                    )
                  : Container(),
              selectedValue == "Category Expense"
                  ? SizedBox(
                      height: 20,
                    )
                  : Container(),
               selectedValue == "Other (specify)"
                  ? TextFormField(
                      controller: subOptionController,
                      validator: (input) =>
                          input!.length < 1 ? "Required" : null,
                      style: TextStyle(fontSize: 20.0),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          //hintText: "Cattle name. *",
                          labelText: "Please specify the name of expense*.",
                          //hintText: "2",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )
                  : Container(),
               selectedValue == "Other (specify)"
                  ? SizedBox(
                      height: 20,
                    )
                  : Container(),
              TextFormField(
                controller: amountSpentController,
                keyboardType: TextInputType.number,
                validator: (input) => input!.length < 1 ? "Required" : null,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //hintText: "Cattle name. *",600
                    labelText: "How much did you spend?",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: receiptNoController,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //hintText: "Cattle name. *",
                    labelText: "Receipt No. (Option)",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                child: TextFormField(
                  controller: noteController,
                  maxLines: null,
                  minLines: 4,
                  style: TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      //hintText: "Cattle name. *",
                      labelText: "Write some notes ...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
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
