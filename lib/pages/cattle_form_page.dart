import 'package:farmapp/models/cattle_breed_model.dart';
import 'package:farmapp/provider/cattle_provider.dart';
import 'package:farmapp/services/cattle_breed_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ad_helper.dart';

class CattleFormPage extends StatefulWidget {
  final int index;

  CattleFormPage(this.index);

  @override
  _CattleFormPageState createState() => _CattleFormPageState();
}

class _CattleFormPageState extends State<CattleFormPage> {

  
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;


   GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  var provider;
  var cattleBreedId;

  // InterstitialAd _interstitialAd = InterstitialAd. ;

  @override
  void initState() {
    super.initState();
  
  _bannerAd = BannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    request: AdRequest(),
    size: AdSize.banner,
    listener: BannerAdListener(
      onAdLoaded: (_) {
        setState(() {
          _isBannerAdReady = true;
        });
      },
      onAdFailedToLoad: (ad, err) {
        print('Failed to load a banner ad: ${err.message}');
        _isBannerAdReady = false;
        ad.dispose();
      },
    ),
  );

  _loadBannerAds();


    provider = Provider.of<CattleProvider>(context, listen: false);

    if (this.widget.index != -1) {
      provider.getCattleById(this.widget.index);
    }

    _getAllCattleBreed();
    editvalue();
  }

   _loadBannerAds() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    //bool _isSubscribed;
    int? isSubscribed = _prefs.getInt("subscribed");
    if (isSubscribed != 1) {
      _bannerAd.load();
    }
  }



  TextEditingController cattleNameController = TextEditingController();
  TextEditingController cattleTagNoController = TextEditingController();
  TextEditingController cattleWeightController = TextEditingController();
  TextEditingController cattleDOBController = TextEditingController();
  TextEditingController cattleDOEController = TextEditingController();
  TextEditingController cattleMotherTagNoController = TextEditingController();
  TextEditingController cattleFatherTagNoController = TextEditingController();
  TextEditingController cattleNotesController = TextEditingController();
  TextEditingController sourceOfCattleController = TextEditingController();

  List<DropdownMenuItem<String>> get dropdownItemsTwo {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text("Select Gender. *"), value: "Select Gender. *"),
      DropdownMenuItem(child: Text("Male"), value: "Male"),
      DropdownMenuItem(child: Text("Female"), value: "Female"),
    ];

    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItemsObtainMethod {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text("Select how cattle was obtained. *"),
          value: "Select how cattle was obtained. *"),
      DropdownMenuItem(child: Text("Born of farm"), value: "Born of farm"),
      DropdownMenuItem(child: Text("Purchased"), value: "Purchased"),
      DropdownMenuItem(child: Text("Other"), value: "Other"),
    ];

    return menuItems;
  }

  String selectedValueTwo = "Select Gender. *";
  String selectedValueObtainMethod = "Select how cattle was obtained. *";
  String selectedValueCattleStage = "-Select cattle stage";
  String selectedValueCattleStageThree = "-Select cattle stage.-";
  String selectedValueCattleStageFour = "-Select cattle stage-";

  List<DropdownMenuItem<String>> menuItemsStage3 = [
    DropdownMenuItem(
        child: Text("-Select cattle stage-"), value: "-Select cattle stage.-"),
    DropdownMenuItem(child: Text("Calf"), value: "Calf"),
    DropdownMenuItem(child: Text("Weaner"), value: "Weaner"),
    DropdownMenuItem(child: Text("Steer"), value: "Steer"),
    DropdownMenuItem(child: Text("Bull"), value: "Bull"),
  ];

  List<DropdownMenuItem<String>> menuItemsStage4 = [
    DropdownMenuItem(
        child: Text("-Select cattle stage-"), value: "-Select cattle stage-"),
    DropdownMenuItem(child: Text("Calf"), value: "Calf"),
    DropdownMenuItem(child: Text("Weaner"), value: "Weaner"),
    DropdownMenuItem(child: Text("Heifer"), value: "Heifer"),
    DropdownMenuItem(child: Text("Cow"), value: "Cow"),
  ];

  List<DropdownMenuItem<String>> get dropdownItemsCattleStage {
    var menuItems;

    setState(() {
      if (selectedValueTwo == "Male") {
        menuItems = menuItemsStage3;
      } else if (selectedValueTwo == "Female") {
        menuItems = menuItemsStage4;
      }
    });

    return menuItems;
  }

  DateTime _date = DateTime.now();

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
          cattleDOBController.text = DateFormat('yyyy-MM-dd').format(_pickDate);
        } else {
          cattleDOEController.text = DateFormat('yyyy-MM-dd').format(_pickDate);
        }
      });
    }
  }

    @override
void dispose() {

  _bannerAd.dispose();
  cattleNameController.dispose();
  cattleTagNoController.dispose();
  cattleWeightController.dispose();
  sourceOfCattleController.dispose();
  cattleNotesController.dispose();
  cattleFatherTagNoController.dispose();
  cattleMotherTagNoController.dispose();
  cattleDOEController.dispose();
  cattleDOBController.dispose();
  
  

  

  super.dispose();
}

  // TimeOfDay _date = TimeOfDay.now();
  

  // _selectTodoDate(BuildContext context, int? i) async {
  //   var _pickDate = await showTimePicker(
  //       context: context,
  //       initialTime: _date,

  //      // firstDate: DateTime(2000),
  //      // lastDate: DateTime(2099)
  //      );
  //   if(_pickDate != null) {
  //     setState(() {
  //       _date = _pickDate;
  //       if (i == 1) {
  //         cattleDOBController.text = _pickDate.format(context);
  //       } else {
  //         cattleDOEController.text =  _pickDate.format(context);
  //       }
  //     });
  //   }
  // }

  String dropdownvalue = "--Select the cattle's breed--";

  CattleBreedService _cattleBreedService = CattleBreedService();
  //List<CattleBreedModel> _list = [];
  List<String> newItems = [];
  List<String> breedIdList = [];
  var checkValue;
 // var newDropdownvalue;

  _getAllCattleBreed() async {
    var response = await _cattleBreedService.getAllTCattleBreeds();
    //print(response);

    response.forEach((data) {
      setState(() {
        var model = CattleBreedModel();

        model.id = data['id'];
        model.cattleBreed = data['cattleBreed'];

        newItems.add(model.cattleBreed.toString());
        breedIdList.add(model.id.toString());
      });

    });

    //newItems.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    setState(() {
      newItems.insert(0, "--Select the cattle's breed--");
      newItems.insert(newItems.length, "Other (Specify)");
      breedIdList.insert(0, "0");
      breedIdList.insert(breedIdList.length, "1000000");
      dropdownvalue = newItems.first.toString();

              //  dropdownvalue = this.widget.index != -1
              // ? provider.singleCattle[0]['cattleBreed']!
              // : newItems.first.toString();
     // cattleBreedId = breedIdList[newItems.indexOf(dropdownvalue)];
    });

  }

  editvalue() async {
    await provider.getCattleById(this.widget.index);
    if (this.widget.index != -1) {
      var cattleBreed = provider.singleCattle[0]['cattleBreed'].toString();
      setState(() {
         dropdownvalue =  provider.singleCattle[0]['cattleBreed']!;
        cattleDOBController.text =
            provider.singleCattle[0]['cattleDOB'].toString();
        cattleDOEController.text =
            provider.singleCattle[0]['cattleDOE'].toString();
        cattleNameController.text =
            provider.singleCattle[0]['cattleName'].toString();
        dropdownvalue = cattleBreed == "-" ? "--Select the cattle's breed--" : cattleBreed;
         cattleBreedId = provider.singleCattle[0]['cattleBreedId'].toString();
        selectedValueTwo = provider.singleCattle[0]['cattleGender'].toString();
        cattleWeightController.text =
            provider.singleCattle[0]['cattleWeight'].toString();
        selectedValueObtainMethod =
            provider.singleCattle[0]['cattleObtainMethod'].toString();
        sourceOfCattleController.text =
            provider.singleCattle[0]['cattleOtherSource'].toString();
        cattleMotherTagNoController.text =
            provider.singleCattle[0]['cattleMotherTagNo'].toString();
        cattleFatherTagNoController.text =
            provider.singleCattle[0]['cattleFatherTagNo'].toString();
        cattleNotesController.text =
            provider.singleCattle[0]['cattleNotes'].toString();
        selectedValueCattleStage =
            provider.singleCattle[0]['cattleStage'].toString();
        cattleMotherTagNoController.text =
            provider.singleCattle[0]['cattleMotherTagNo'].toString();
        cattleTagNoController.text =
            provider.singleCattle[0]['cattleTagNo'].toString();
      });
    }
  }
  
        bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate() && !dropdownvalue.contains("--Select the cattle's breed--") &&
    !selectedValueTwo.contains("Select Gender. *") && 
    !selectedValueCattleStage.contains("-Select cattle stage") &&
    !selectedValueObtainMethod.contains("Select how cattle was obtained. *")) {
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
    provider = Provider.of<CattleProvider>(context, listen: false);
    var cattlestatus =
        selectedValueTwo.toString() == "Female" ? "Non Lactating" : "";

    return Scaffold(
      appBar: AppBar(
        title: Text("New Cattle"),
        actions: [
          IconButton(
              onPressed: () async {
                if(checkValue ==1){
                  setState(() {
                    cattleBreedId = breedIdList[newItems.indexOf(dropdownvalue)];
                  });
                }

                if(validateAndSave()){

                       await provider.saveCattle(
                    dropdownvalue,
                  cattleBreedId,
                    cattleNameController.text,
                    selectedValueTwo,
                    cattleTagNoController.text,
                    selectedValueCattleStage,
                    cattleWeightController.text,
                    cattleDOBController.text,
                    cattleDOEController.text,
                    selectedValueObtainMethod,
                    sourceOfCattleController.text,
                    cattleMotherTagNoController.text,
                    cattleFatherTagNoController.text,
                    cattleNotesController.text,
                    cattlestatus,
                    "All Active",
                    "",
                    "",
                    "",
                    "",
                    this.widget.index != -1
                        ? provider.singleCattle[0]['id']!
                        : -1,
                    this.widget.index);

                if (provider.isSave) {
                  await provider.getAllCattles("All Active");
                  Navigator.pop(context);
                }


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
                 if (_isBannerAdReady)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
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
                    //labelText: "--Select the cattle's breed--",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                value: dropdownvalue,
                //icon: Icon(Icons.keyboard_arrow_down),
                items: newItems.map((String items) {
                  return DropdownMenuItem(value: items, child: Text(items));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                    if (dropdownvalue == "Other (Specify)") {
                      _editCategoryDialog(context);
                    }
        
                    print(newItems.indexOf(dropdownvalue));
                    cattleBreedId = breedIdList[newItems.indexOf(dropdownvalue)];
                    print("checking out $cattleBreedId");
                  });
        
                  // print(newItems.indexOf(dropdownvalue));
                  //  cattleBreedId = breedIdList[newItems.indexOf(dropdownvalue)];
                  // print("checking out $cattleBreedId");
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: cattleNameController,
                validator: (input) => input!.length < 1 ? "Required" : null,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //hintText: "Cattle name. *",
                    labelText: "Cattle name. *",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: cattleTagNoController,
                validator: (input) => input!.length < 1 ? "Required" : null,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //hintText: "Cattle name. *",
                    labelText: "Tag No. *",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
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
                      //labelText: "Select Gender. *",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  //dropdownColor: Colors.blueAccent,
                  value: selectedValueTwo,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValueTwo = newValue!;
                      if (selectedValueTwo == "Male") {
                        selectedValueCattleStage = selectedValueCattleStageThree;
                      } else if (selectedValueTwo == "Female") {
                        selectedValueCattleStage = selectedValueCattleStageFour;
                      }
                    });
                  },
                  items: dropdownItemsTwo),
              selectedValueTwo == "Select Gender. *"
                  ? Container()
                  : SizedBox(
                      height: 20,
                    ),
              selectedValueTwo == "Select Gender. *"
                  ? Container()
                  : DropdownButtonFormField(
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 30,
                      ),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          //hintText: "Cattle name. *",
                          //labelText: "Select Gender. *",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      //dropdownColor: Colors.blueAccent,
                      value: selectedValueCattleStage,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValueCattleStage = newValue!;
                        });
                      },
                      items: dropdownItemsCattleStage),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: cattleWeightController,
                keyboardType: TextInputType.number,
                validator: (input) => input!.length < 1 ? "Required" : null,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //hintText: "Cattle name. *",
                    labelText: "Weight",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: cattleDOBController,
                validator: (input) => input!.length < 1 ? "Required" : null,
                onTap: () {
                  _selectTodoDate(context, 1);
                },
                readOnly: true,
                autofocus: false,
                // enabled: false,
                decoration: InputDecoration(
                    //hintText: 'YY-MM-DD',
        
                    labelText: 'Date of birth',
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
                controller: cattleDOEController,
                validator: (input) => input!.length < 1 ? "Required" : null,
                onTap: () {
                  _selectTodoDate(context, 0);
                },
                readOnly: true,
                autofocus: false,
                // enabled: false,
                decoration: InputDecoration(
                    //hintText: 'YY-MM-DD',
        
                    labelText: 'Date of entry on the farm',
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
                      //labelText: "Select Gender. *",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  //dropdownColor: Colors.blueAccent,
                  value: selectedValueObtainMethod,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValueObtainMethod = newValue!;
                    });
                  },
                  items: dropdownItemsObtainMethod),
              SizedBox(
                height: 20,
              ),
              selectedValueObtainMethod == "Other"
                  ? TextField(
                      controller: sourceOfCattleController,
                      style: TextStyle(fontSize: 20.0),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          //hintText: "Cattle name. *",
                          labelText: "Specify the source of cattle. *",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )
                  : Container(),
              selectedValueObtainMethod == "Other"
                  ? SizedBox(
                      height: 20,
                    )
                  : Container(),
              TextFormField(
                controller: cattleMotherTagNoController,
                validator: (input) => input!.length < 1 ? "Required" : null,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //hintText: "Cattle name. *",
                    labelText: "Mother's Tag No.",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: cattleFatherTagNoController,
                validator: (input) => input!.length < 1 ? "Required" : null,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //hintText: "Cattle name. *",
                    labelText: "Father's Tag No.",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: cattleNotesController,
                minLines: 4,
                maxLines: null,
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

  _editCategoryDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          TextEditingController _cattleBreedName = TextEditingController();
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
                  CattleBreedService breedService = CattleBreedService();
                  var model = CattleBreedModel();
                  model.cattleBreed = _cattleBreedName.text;
                  var response = await breedService.saveCattle(model);

                  print("printing new list $newItems");

                  if (response > 0) {
                    newItems.clear();
                    breedIdList.clear();
                     await _getAllCattleBreed();
    
    
                   
                    print("check me $newItems");
                    setState(() {
                      checkValue = 1;
                      dropdownvalue = _cattleBreedName.text;
                      //newDropdownvalue = _cattleBreedName.text;
                    });
                  } else {
                    print("failed");
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  "ADD",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            title: Text("New Breed"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _cattleBreedName,
                    style: TextStyle(fontSize: 20.0),
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        //hintText: "Cattle name. *",
                        labelText: "Enter breed name ...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
