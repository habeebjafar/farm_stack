import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeDialog extends StatefulWidget {
   final  startDate;
  final  endDate;
   DateRangeDialog({this.startDate, this.endDate, Key? key }) : super(key: key);

  @override
  State<DateRangeDialog> createState() => _DateRangeDialogState();
}

class _DateRangeDialogState extends State<DateRangeDialog> {

   GlobalKey<FormState> globalKey = GlobalKey<FormState>();

    DateTime _date = DateTime.now();

  _selectRangeDate(BuildContext context, int? i) async {
    var _pickDate = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2099));
    if (_pickDate != null) {
      setState(() {
        _date = _pickDate;
        if (i == 1) {
          this.widget.startDate.text = DateFormat('yyyy-MM-dd').format(_pickDate);
        } else {
          this.widget.endDate.text = DateFormat('yyyy-MM-dd').format(_pickDate);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _editCategoryDialog();
  }


  _editCategoryDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Archive Cattle"),
              content: Form(
                key: globalKey,
                child: Column(
                  children: [
              
                       TextFormField(
                          controller: this.widget.startDate.text,
                          validator: (input) => input!.length < 1 ? "Required" : null,
                          onTap: () {
                _selectRangeDate(context, 1);
                          },
                          readOnly: true,
                          autofocus: false,
                          // enabled: false,
                          decoration: InputDecoration(
                  //hintText: 'YY-MM-DD',
              
                  labelText: 'Start Date ... *',
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
              
                        TextFormField(
                          controller: this.widget.endDate.text,
                          validator: (input) => input!.length < 1 ? "Required" : null,
                          onTap: () {
                _selectRangeDate(context, 0);
                          },
                          readOnly: true,
                          autofocus: false,
                          // enabled: false,
                          decoration: InputDecoration(
                  //hintText: 'YY-MM-DD',
              
                  labelText: 'End Date ... *',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  prefixIcon: InkWell(
                      onTap: () {
                        //  _selectTodoDate(context);
                      },
                      child: Icon(Icons.calendar_today))),
                        ),
                        SizedBox(height: 15,),

                        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
              SizedBox(
                width: 10,
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary),
                ),
                onPressed: () async {
                  if (validateAndSave()) {
                    
                       

                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
              
                  ],
                ),
              )
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