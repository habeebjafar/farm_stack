import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TestCode extends StatefulWidget {
  const TestCode({Key? key}) : super(key: key);

  @override
  State<TestCode> createState() => _TestCodeState();
}

class _TestCodeState extends State<TestCode> {
  String? _groupSelectedValue;
  DateTime? _searchDateOne;
  DateTime? _searchDateTwo;

  List mydates = [
    '2022-01-23',
    '2022-02-23',
    '2022-03-23',
    '2022-03-23',
    '2022-04-23',
    '2022-04-23',
    '2022-05-01',
    '2022-05-23',
    '2022-06-23',
    '2022-07-23',
    '2022-08-23',
    '2022-09-03'
  ];
  @override
  Widget build(BuildContext context) {
    var date = new DateTime.now();
    var nonthOne = new DateTime(date.year, date.month - 4, 01);
     var nonthTwo = new DateTime(date.year, date.month - 2, 01);

    for (int i = 0; i < mydates.length; i++) {
      if (nonthOne.compareTo(DateTime.parse(mydates[i])) <= 0 && nonthTwo.compareTo(DateTime.parse(mydates[i])) >= 0) {
        // print(mydates[i]);

      }
    }

   
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                // => showSearch(context: context, delegate: Search())
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TestCode()));
              },
              icon: Icon(Icons.search)),
          popupMenuWidget()
        ],
      ),
      body: Center(child: Text(_searchDateOne.toString())),
    );
  }


  _groupSelectedValueOnchanged(String? value) async {

      setState(() {
          
        DateTime date = new DateTime.now();
         DateTime? searchMonthOne;
        if(value == "7"){
            searchMonthOne = new DateTime(date.year, date.month, date.day - int.parse(value!));

          } else if(value == "1"){
          }else{
             searchMonthOne = new DateTime(date.year, date.month - int.parse(value!), 01);

          }
          _searchDateOne =searchMonthOne;
          _groupSelectedValue = value;
        }); 

    Navigator.pop(context);
  }



  Widget popupMenuWidget() {
    return PopupMenuButton(
      onSelected: (String? value) async {

       
      setState(() {
          
        DateTime date = new DateTime.now();
         DateTime? searchDateOne;
        if(value == "7"){
            searchDateOne = new DateTime(date.year, date.month, date.day - int.parse(value!));
             _searchDateOne =searchDateOne;

          } else if(value == "1"){
             searchDateOne = new DateTime(date.year, date.month - int.parse(value!), 01);
             _searchDateTwo = searchDateOne;

          }else if(value == "13"){
             searchDateOne = new DateTime(date.year - 20, 01, 01);
              _searchDateOne =searchDateOne;
             
          }else if(value == "14"){
             searchDateOne = new DateTime(date.year, date.month - int.parse(value!), 01);
          _searchDateOne =searchDateOne;
          _searchDateTwo =searchDateOne;
          }else{
             searchDateOne = new DateTime(date.year, date.month - int.parse(value!), 01);
              _searchDateOne =searchDateOne;

          }
        
           

          _groupSelectedValue = value;
        });
        print(_groupSelectedValue);

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
                    value: "Steer",
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
}
