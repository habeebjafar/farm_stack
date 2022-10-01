import 'package:farmapp/pages/cattle_details_event.dart';
import 'package:farmapp/pages/cattle_details_general.dart.dart';
import 'package:farmapp/pages/cattle_form_page.dart';
import 'package:farmapp/provider/cattle_provider.dart';
import 'package:farmapp/widget/mydialogcontent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'individual_event_form.dart';

class CattleDetailsPage extends StatefulWidget {
  // final List<CattleModel> list;
  final int index;

  CattleDetailsPage(this.index);

  @override
  _CattleDetailsPageState createState() => _CattleDetailsPageState();
}

class _CattleDetailsPageState extends State<CattleDetailsPage> {
  String? _groupSelectedValue;

  String selectedValueArchiveReason = "-Reason for archiving-";
  String selectedValueCattleStatus = "Non Lactating";
  TextEditingController cattleDOEController = TextEditingController();
  TextEditingController cattleArchiveOtherReasonController =
      TextEditingController();
  TextEditingController cattleArchiveNoteController = TextEditingController();

  List<DropdownMenuItem<String>> get dropdownItemsArchiveReason {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text("-Reason for archiving-*"),
          value: "-Reason for archiving-"),
      DropdownMenuItem(child: Text("Lost"), value: "Lost"),
      DropdownMenuItem(child: Text("Dead"), value: "Dead"),
      DropdownMenuItem(child: Text("Sold"), value: "Sold"),
      DropdownMenuItem(child: Text("Loaned"), value: "Loaned"),
      DropdownMenuItem(child: Text("Gifted"), value: "Gifted"),
      DropdownMenuItem(child: Text("Other"), value: "Other"),
    ];

    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItemsCattleStatus {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Non Lactating"), value: "Non Lactating"),
      DropdownMenuItem(child: Text("Lactating"), value: "Lactating"),
      DropdownMenuItem(child: Text("Pregnant"), value: "Pregnant"),
    ];

    return menuItems;
  }

  var provider;
  @override
  void initState() {
    provider = Provider.of<CattleProvider>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
          return Container(
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  //backgroundColor: Colors.black,
                  //centerTitle: true,

                  titleSpacing: 0.0,
                  toolbarHeight: 220,
                  leadingWidth: 0.0,

                  title: Stack(
                    children: [
                      Container(
                          color: Colors.redAccent,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset("assets/images/fieldcow.jpg")),
                      Positioned(
                          top: 30,
                          left: 5,
                          right: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.arrow_back_sharp),
                              popupMenuWidget()
                            ],
                          )),
                      Positioned(
                        left: 45,
                        right: 45,
                        bottom: 45,
                        top: 45,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: Image.asset(
                            "${provider.singleCattle[0]['cattleStageImg']}",
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                      Positioned(
                          left: 20,
                          bottom: 35,
                          child: Text(
                            "${provider.singleCattle[0]['cattleTagNo']}",
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 26),
                          ))
                    ],
                  ),

                  bottom: PreferredSize(
                    preferredSize: Size.zero,
                    child: Container(
                      color: Colors.white,
                      child: TabBar(
                        indicatorColor: Colors.orange,
                        //indicatorWeight: 10,
                        //indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.green,
                        tabs: [
                          Tab(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "DETAILS",
                                  // style: TextStyle( color: Theme.of(context).primaryColor,),
                                )
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.multitrack_audio_outlined,
                                  //color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text("EVENTS")
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                body: TabBarView(
                  children: [
                    CattleDetailsGeneral(this.widget.index),
                    CattleDetailsEvent(this.widget.index)
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget popupMenuWidget() {
    provider = Provider.of<CattleProvider>(context, listen: false);

    return PopupMenuButton(
      onSelected: (value) {
        setState(() {
          _groupSelectedValue = value as String?;
          if (_groupSelectedValue == "Archive Cattle") {
            _editCategoryDialog();
          } else if (_groupSelectedValue == "Unarchive Cattle") {
            _unArchivedDialog();
            print("we have to unarchive the cattle");
          } else if (_groupSelectedValue == "Change Status") {
            _cattleStatusDialog();
          } else if (_groupSelectedValue == "Edit") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CattleFormPage(this.widget.index)));
          } else if (_groupSelectedValue == "Add Event") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        IndividualEventForm(index: this.widget.index)));
          } else if (_groupSelectedValue == "Delete Cattle") {
            _deleteCattleDialog();
          }
        });
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: "Edit",
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.edit,
                color: Colors.orange,
              ),
              SizedBox(
                width: 15,
              ),
              Text("Edit"),
              SizedBox(
                width: 35,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "Add Event",
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.orange,
              ),
              SizedBox(
                width: 15,
              ),
              Text("Add Event"),
              SizedBox(
                width: 35,
              ),
            ],
          ),
        ),
        if (provider.singleCattle[0]['cattleGender'] == "Female")
          PopupMenuItem(
            value: "Change Status",
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.track_changes_outlined,
                  color: Colors.orange,
                ),
                SizedBox(
                  width: 15,
                ),
                Text("Change Status"),
                SizedBox(
                  width: 35,
                ),
              ],
            ),
          ),
        // PopupMenuItem(
        //   value: "Weight Report",
        //   child: Row(
        //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     mainAxisSize: MainAxisSize.max,
        //     children: [
        //       Icon(
        //         Icons.masks_sharp,
        //         color: Colors.orange,
        //       ),
        //       SizedBox(
        //         width: 15,
        //       ),
        //       Text("Weight Report"),
        //       SizedBox(
        //         width: 35,
        //       ),
        //     ],
        //   ),
        // ),
        // PopupMenuItem(
        //   value: "Print PDF",
        //   child: Row(
        //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     mainAxisSize: MainAxisSize.max,
        //     children: [
        //       Icon(
        //         Icons.masks_sharp,
        //         color: Colors.orange,
        //       ),
        //       SizedBox(
        //         width: 15,
        //       ),
        //       Text("Print PDF"),
        //       SizedBox(
        //         width: 35,
        //       ),
        //     ],
        //   ),
        // ),
        PopupMenuItem(
          value:
              "${_groupSelectedValue = provider.singleCattle[0]['cattleArchive'] == 'All Active' ? 'Archive Cattle' : 'Unarchive Cattle'}",
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.archive,
                color: Colors.orange,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                  "${_groupSelectedValue = provider.singleCattle[0]['cattleArchive'] == 'All Active' ? 'Archive Cattle' : 'Unarchive Cattle'}"),
              SizedBox(
                width: 35,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "Delete Cattle",
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              SizedBox(
                width: 15,
              ),
              Text("Delete Cattle"),
              SizedBox(
                width: 35,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _editCategoryDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Archive Cattle"),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SingleChildScrollView(
                    child: MyDialogContent(

                        index: this.widget.index,
                        dropdownItemsArchiveReason: dropdownItemsArchiveReason,
                        groupSelectedValue: _groupSelectedValue,
                        selectedValueArchiveReason: selectedValueArchiveReason,
                        cattleDOEController: cattleDOEController,
                        cattleArchiveOtherReasonController: cattleArchiveOtherReasonController,
                        cattleArchiveNoteController: cattleArchiveNoteController),
                  );
                },
              ));
        });
  }

  _unArchivedDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
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
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary),
                  ),
                  onPressed: () async {
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
                        "All Active",
                        cattleDOEController.text,
                        selectedValueArchiveReason,
                        cattleArchiveOtherReasonController.text,
                        cattleArchiveNoteController.text,
                        provider.singleCattle[0]['id'],
                        this.widget.index);

                    await provider.getAllCattles("Unarchive Cattle");
                    await provider.getCattleById(this.widget.index);

                    Navigator.pop(context);
                  },
                  child: Text(
                    "OKAY",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              title: Text("Unrchiving Cattle"),
              content: Text(
                  "This cattle will be brought back to the list of active farm cattle. Click okay to continue!"));
        });
  }

  _deleteCattleDialog() {
    // provider = Provider.of<CattleProvider>(context, listen: false);

    return showDialog(
        context: context,
        barrierDismissible: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
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
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  onPressed: () async {
                    // print(provider.singleCattle[0]['cattleTagNo']);

                    await provider.deleteCattleById(this.widget.index);

                    await provider.getAllCattles(
                        (provider.singleCattle[0]['cattleArchive']));
                    await provider.getCattleById(this.widget.index);

                    Navigator.pop(context);
                     Navigator.pop(context);

                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => CattlePage()));
                  },
                  child: Text(
                    "DELETE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              title: Text("Deleting Cattle!"),
              content: Text(
                  "This cattle will be deleted completely from the app. This will also permanently delete all records such as milk, events, expenses and revenue attached to this cattle!"));
        });
  }

  _cattleStatusDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
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
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary),
                  ),
                  onPressed: () async {
                    await provider.updateCattleSingleField(
                        "id",
                        "cattleStatus",
                        selectedValueCattleStatus,
                        provider.singleCattle[0]['id']);

                    await provider.getAllCattles(
                      provider.singleCattle[0]['cattleArchive'],
                    );
                    await provider.getCattleById(this.widget.index);

                    Navigator.pop(context);

                  },
                  child: Text(
                    "SAVE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              title: Text("Change Status"),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return DropdownButtonFormField(
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 30,
                      ),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      value: selectedValueCattleStatus,
                      onChanged: (newValue) {
                        setState(() {
                          selectedValueCattleStatus = newValue! as String;
                        });
                      },
                      items: dropdownItemsCattleStatus);
                },
              ));
        });
  }
}

// class MyDialogContent extends StatefulWidget {
//   final index;
//   final dropdownItemsArchiveReason;
//   final groupSelectedValue;

//   var selectedValueArchiveReason;

//   final cattleDOEController;
//   final cattleArchiveOtherReasonController;
//   final cattleArchiveNoteController;

//   MyDialogContent(
//       this.index,
//       this.dropdownItemsArchiveReason,
//       this.groupSelectedValue,
//       this.selectedValueArchiveReason,
//       this.cattleDOEController,
//       this.cattleArchiveOtherReasonController,
//       this.cattleArchiveNoteController);

//   @override
//   _MyDialogContentState createState() => _MyDialogContentState();
// }

// class _MyDialogContentState extends State<MyDialogContent> {
//   GlobalKey<FormState> globalKey = GlobalKey<FormState>();
//   DateTime _date = DateTime.now();

//   var provider;
//   @override
//   void initState() {
//     provider = Provider.of<CattleProvider>(context, listen: false);
//     print("response from here ${this.widget.index}");
//     //checkUp();
//     super.initState();
//   }

//   var mydropdownValue;

//   _selectTodoDate(BuildContext context, int? i) async {
//     //mylist.last = "hello";

//     var _pickDate = await showDatePicker(
//         context: context,
//         initialDate: _date,
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2099));
//     if (_pickDate != null) {
//       setState(() {
//         _date = _pickDate;
//         if (i == 1) {
//           this.widget.cattleDOEController.text =
//               DateFormat('yyyy-MM-dd').format(_pickDate);
//         }
//       });
//     }
//   }

//   _getContent() {
//     return Form(
//       key: globalKey,
//       child: Column(
//         children: <Widget>[
//           DropdownButtonFormField(
//               style: TextStyle(fontSize: 16.0, color: Colors.black),
//               icon: Icon(
//                 Icons.arrow_drop_down,
//                 size: 30,
//               ),
//               decoration: InputDecoration(
//                   contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5.0))),
//               value: this.widget.selectedValueArchiveReason,
//               onChanged: (newValue) {
//                 setState(() {
//                   this.widget.selectedValueArchiveReason = newValue!;
//                 });
//               },
//               items: this.widget.dropdownItemsArchiveReason),
//           SizedBox(
//             height: 20,
//           ),
//           this.widget.selectedValueArchiveReason == "Other"
//               ? Column(
//                   children: [
//                     TextFormField(
//                       controller:
//                           this.widget.cattleArchiveOtherReasonController,
//                       validator: (input) =>
//                           input!.length < 1 ? "Required" : null,
//                       style: TextStyle(fontSize: 20.0),
//                       decoration: InputDecoration(
//                           contentPadding:
//                               EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                           //hintText: "Cattle name. *",
//                           labelText: "Enter reason ... *",
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0))),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                   ],
//                 )
//               : Container(),
//           TextFormField(
//             controller: this.widget.cattleDOEController,
//             validator: (input) => input!.length < 1 ? "Required" : null,
//             onTap: () {
//               _selectTodoDate(context, 1);
//             },
//             readOnly: true,
//             autofocus: false,
//             // enabled: false,
//             decoration: InputDecoration(
//                 //hintText: 'YY-MM-DD',

//                 labelText: 'Date of event ... *',
//                 contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5.0)),
//                 prefixIcon: InkWell(
//                     onTap: () {
//                       //  _selectTodoDate(context);
//                     },
//                     child: Icon(Icons.calendar_today))),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           TextFormField(
//             controller: this.widget.cattleArchiveNoteController,
//             maxLines: null,
//             minLines: 4,
//             style: TextStyle(fontSize: 20.0),
//             decoration: InputDecoration(
//                 contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                 //hintText: "Cattle name. *",
//                 labelText: "Note ...",
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5.0))),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               TextButton(
//                 style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.all<Color>(Colors.orange),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text(
//                   "CANCEL",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               TextButton(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all<Color>(
//                       Theme.of(context).colorScheme.primary),
//                 ),
//                 onPressed: () async {
//                   if (validateAndSave()) {
//                     await provider.saveCattle(
//                         provider.singleCattle[0]['cattleBreed'],
//                         provider.singleCattle[0]['cattleBreedId'],
//                         provider.singleCattle[0]['cattleName'],
//                         provider.singleCattle[0]['cattleGender'],
//                         provider.singleCattle[0]['cattleTagNo'],
//                         provider.singleCattle[0]['cattleStage'],
//                         provider.singleCattle[0]['cattleWeight'],
//                         provider.singleCattle[0]['cattleDOB'],
//                         provider.singleCattle[0]['cattleDOE'],
//                         provider.singleCattle[0]['cattleObtainMethod'],
//                         provider.singleCattle[0]['cattleOtherSource'],
//                         provider.singleCattle[0]['cattleMotherTagNo'],
//                         provider.singleCattle[0]['cattleFatherTagNo'],
//                         provider.singleCattle[0]['cattleNote'],
//                         provider.singleCattle[0]['cattleStatus'],
//                         this.widget.groupSelectedValue,
//                         this.widget.cattleDOEController.text,
//                         this.widget.selectedValueArchiveReason,
//                         this.widget.cattleArchiveOtherReasonController.text,
//                         this.widget.cattleArchiveNoteController.text,
//                         provider.singleCattle[0]['id'],
//                         this.widget.index);

//                     await provider.getAllCattles("All Active");
//                     await provider.getCattleById(this.widget.index);

//                     Navigator.pop(context);
//                   }
//                 },
//                 child: Text(
//                   "ARCHIVE",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   bool validateAndSave() {
//     final form = globalKey.currentState;
//     if (form!.validate() &&
//         !this
//             .widget
//             .selectedValueArchiveReason
//             .contains("-Reason for archiving-")) {
//       form.save();
//       return true;
//     }

//     final snackBar = SnackBar(
//       content: const Text('Please fill all the fields marked with (*)'),
//       // action: SnackBarAction(
//       //   label: 'Undo',
//       //   onPressed: () {
//       //     // Some code to undo the change.
//       //   },
//       // ),
//       duration: Duration(seconds: 2),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);

//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _getContent();
//   }
// }
