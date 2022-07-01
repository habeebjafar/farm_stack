import 'package:farmapp/models/cattle_model.dart';
import 'package:farmapp/pages/cattle_details_page.dart';
import 'package:farmapp/pages/cattle_form_page.dart';
import 'package:farmapp/pages/search_implementation.dart';
import 'package:farmapp/provider/cattle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CattlePage extends StatefulWidget {
  @override
  _CattlePageState createState() => _CattlePageState();
}

class _CattlePageState extends State<CattlePage> {

  bool firstTime = true;

  var provider;
  @override
  void initState() {
    super.initState();

    _groupSelectedValue = "All Active";
    //  provider = Provider.of<CattleProvider>(context, listen: true);
    //   provider.getAllCattles(_groupSelectedValue);
    
  }



  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("View Record"), value: "View Record"),
      DropdownMenuItem(child: Text("Edit Record"), value: "Edit Record"),
    ];
    return menuItems;
  }

  String selectedValue = "View Record";
  
  String? _groupSelectedValue;

  @override
  Widget build(BuildContext context) {
   
     provider = Provider.of<CattleProvider>(context, listen: false);
    provider.getAllCattles("All Active");
    print("Checking the list for ${provider.cattleList}");
   

    return Scaffold(
      appBar: AppBar(
        title: Text("Cattle"),
        actions: [
          IconButton(onPressed: () {
            // => showSearch(context: context, delegate: Search())
            Navigator.push(context, 
            MaterialPageRoute(builder: (context) => SearchImplementation()));
            },
           icon: Icon(Icons.search)),

          popupMenuWidget()
        ],
      ),
      body: FutureBuilder(
          future: Provider.of<CattleProvider>(context, listen: false)
              .getAllCattles(_groupSelectedValue),
          builder: (BuildContext context,
              AsyncSnapshot<List<CattleModel>> snapShot) {
            
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
            
              return Consumer<CattleProvider>(
                builder: (_, newPro, __) => newPro.cattleList.length == 0 ? Center(
          child: Text("No cattle recorded yet!",
          style: TextStyle(
            fontSize: 18,
            color: Colors.orange
          ),)
        ) : ListView.builder(
                    itemCount: newPro.cattleList.length,
                    itemBuilder: (BuildContext context, int index) {

                      String? cattleStageImg = newPro.cattleList[index].cattleStageImg;
                     
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CattleDetailsPage(newPro.cattleList[index].id!)));
                          },
                          child: Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            cattleStageImg!,
                                            width: 70,
                                            height: 70,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${newPro.cattleList[index].cattleTagNo}"),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  "${newPro.cattleList[index].cattleName}")
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 0),
                                                child: Icon(Icons.star_border),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
              
                                              Stack(
                                                children: [
                                                  Container(
                                                    //color: Colors.red,
                                                    // width: 50,
                                                    child: DropdownButton(
                                                        icon:
                                                            Icon(Icons.more_vert),
                                                        //value: selectedValue,
                                                        //itemHeight: 50,
                                                        underline: Container(),
                                                        isExpanded: false,
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            selectedValue =
                                                                newValue!;
                                                            if (selectedValue ==
                                                                "View Record") {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          CattleDetailsPage(newPro.cattleList[index].id!)));
                                                            }
              
                                                            if (selectedValue ==
                                                                "Edit Record") {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          CattleFormPage(newPro.cattleList[index].id!)));
                                                            }
                                                          });
                                                        },
                                                        items: dropdownItems),
                                                  ),
                                                  Positioned(
                                                    //left: 20,
                                                    top: 13,
                                                    bottom: 10,
                                                    child: Text(
                                                      "${newPro.cattleList[index].cattleGender}",
                                                      style:
                                                          TextStyle(fontSize: 18),
                                                    ),
                                                  )
                                                ],
                                              )
                                              // IconButton(
                                              //     onPressed: () {},
                                              //     icon: Icon(Icons.more_vert)
                                              //     )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })

                );
              
                
              
            }
          }),

    

      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CattleFormPage(-1)));
        },
        child: Container(
          width: 110,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              // boxShadow: [
              //   BoxShadow( spreadRadius: 1, color: Colors.grey, )
              // ],
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.add, color: Colors.white),
              Text(
                "ADD",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _groupSelectedValueOnchanged(String? value) async {
  
    setState(() {
      _groupSelectedValue = value!;
    });


    Navigator.pop(context);
    // });
  }

  Widget popupMenuWidget() {
    
    return PopupMenuButton(
      //child: Text("Radio PopupMenuBotton"),
      onSelected: (value) async {
        setState(() {
          _groupSelectedValue = value as String?;
        });
     
      },
      icon: Icon(Icons.filter_list),
      itemBuilder: (context) => [
        PopupMenuItem(
            value: "All Active",
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
                    Text("All Active"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "All Active",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "Unarchive Cattle",
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
                    Text("Archived"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "Unarchive Cattle",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "Cow",
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
                    Text("Cows"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "Cow",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "Heifer",
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
                    Text("Heifers"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "Heifer",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "Bull",
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
                    Text("Bulls"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "Bull",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "Steer",
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
                    Text("Steers"),
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
            value: "Weaner",
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
                    Text("Weaners"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "Weaner",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "Calf",
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
                    Text("Calves"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "Calf",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "Pregnant",
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
                    Text("Pregnant"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "Pregnant",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "Lactating",
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
                    Text("Lactating"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "Lactating",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
        PopupMenuItem(
            value: "Non Lactating",
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
                    Text("Non Lactating"),
                  ],
                ),
                Radio(
                    activeColor: Colors.orange,
                    value: "Non Lactating",
                    groupValue: _groupSelectedValue,
                    onChanged: _groupSelectedValueOnchanged),
              ],
            )),
      ],
    );
  }
}
