import 'package:farmapp/provider/cattle_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyDialogContent extends StatefulWidget {
  final index;
  final dropdownItemsArchiveReason;
  final groupSelectedValue;

  var selectedValueArchiveReason;

  final cattleDOEController;
  final cattleArchiveOtherReasonController;
  final cattleArchiveNoteController;

  MyDialogContent(
      {this.index,
      this.dropdownItemsArchiveReason,
      this.groupSelectedValue,
      this.selectedValueArchiveReason,
      this.cattleDOEController,
      this.cattleArchiveOtherReasonController,
      this.cattleArchiveNoteController});

  @override
  _MyDialogContentState createState() => _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();

  var provider;
  @override
  void initState() {
    provider = Provider.of<CattleProvider>(context, listen: false);
    super.initState();
  }

  var mydropdownValue;

  _selectTodoDate(BuildContext context, int? i) async {

    var _pickDate = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2099));
    if (_pickDate != null) {
      setState(() {
        _date = _pickDate;
        if (i == 1) {
          this.widget.cattleDOEController.text =
              DateFormat('yyyy-MM-dd').format(_pickDate);
        }
      });
    }
  }

  _getContent() {
    return Form(
      key: globalKey,
      child: Column(
        children: <Widget>[
          DropdownButtonFormField(
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              icon: Icon(
                Icons.arrow_drop_down,
                size: 30,
              ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              value: this.widget.selectedValueArchiveReason,
              onChanged: (newValue) {
                setState(() {
                  this.widget.selectedValueArchiveReason = newValue!;
                });
              },
              items: this.widget.dropdownItemsArchiveReason),
          SizedBox(
            height: 20,
          ),
          this.widget.selectedValueArchiveReason == "Other"
              ? Column(
                  children: [
                    TextFormField(
                      controller:
                          this.widget.cattleArchiveOtherReasonController,
                      validator: (input) =>
                          input!.length < 1 ? "Required" : null,
                      style: TextStyle(fontSize: 20.0),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          //hintText: "Cattle name. *",
                          labelText: "Enter reason ... *",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              : Container(),
          TextFormField(
            controller: this.widget.cattleDOEController,
            validator: (input) => input!.length < 1 ? "Required" : null,
            onTap: () {
              _selectTodoDate(context, 1);
            },
            readOnly: true,
            autofocus: false,
            // enabled: false,
            decoration: InputDecoration(
                //hintText: 'YY-MM-DD',

                labelText: 'Date of event ... *',
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
            controller: this.widget.cattleArchiveNoteController,
            maxLines: null,
            minLines: 4,
            style: TextStyle(fontSize: 20.0),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                //hintText: "Cattle name. *",
                labelText: "Note ...",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
          ),
          SizedBox(
            height: 15,
          ),
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
                    await provider.saveCattle(
                        provider.singleCattle[0]['cattleBreed'],
                        provider.singleCattle[0]['cattleBreedId'],
                        provider.singleCattle[0]['cattleName'],
                        provider.singleCattle[0]['cattleGender'],
                        provider.singleCattle[0]['cattleTagNo'],
                        provider.singleCattle[0]['cattleStage'],
                        provider.singleCattle[0]['cattleWeight'],
                        provider.singleCattle[0]['cattleDOB'],
                        provider.singleCattle[0]['cattleDOE'],
                        provider.singleCattle[0]['cattleObtainMethod'],
                        provider.singleCattle[0]['cattleOtherSource'],
                        provider.singleCattle[0]['cattleMotherTagNo'],
                        provider.singleCattle[0]['cattleFatherTagNo'],
                        provider.singleCattle[0]['cattleNote'],
                        provider.singleCattle[0]['cattleStatus'],
                        this.widget.groupSelectedValue,
                        this.widget.cattleDOEController.text,
                        this.widget.selectedValueArchiveReason,
                        this.widget.cattleArchiveOtherReasonController.text,
                        this.widget.cattleArchiveNoteController.text,
                        provider.singleCattle[0]['id'],
                        this.widget.index);

                    await provider.getAllCattles("All Active");
                    await provider.getCattleById(this.widget.index);

                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "ARCHIVE",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate() &&
        !this
            .widget
            .selectedValueArchiveReason
            .contains("-Reason for archiving-")) {
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
    return _getContent();
  }
}
