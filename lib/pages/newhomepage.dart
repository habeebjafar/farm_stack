import 'dart:ui';

import 'package:farmapp/models/income_model.dart';
import 'package:farmapp/pages/cattle_page.dart';
import 'package:farmapp/pages/events_report_page.dart';
import 'package:farmapp/pages/farm_notes.dart';
import 'package:farmapp/pages/milk_record_page.dart';
import 'package:farmapp/pages/pie_chart_page.dart';
import 'package:farmapp/pages/transactions_report_page.dart';
import 'package:farmapp/services/income_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';


class NewHomeScreen extends StatefulWidget {
  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  var _selectedDestination;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static final List<String> _listViewData = [
    "Inducesmile.com",
    "Flutter Dev",
    "Android Dev",
    "iOS Dev!",
    "React Native Dev!",
    "React Dev!",
    "express Dev!",
    "Laravel Dev!",
    "Angular Dev!",
  ];

  var _totalncome = 0.0;

  IconData myNavIcon = Icons.tune;

  @override
  void initState() {
    super.initState();
    _getTotalIncome();
  }

  _getTotalIncome() async {
    IncomeService incomeService = IncomeService();
    var response = await incomeService.getAllIncomeRecord();
    response.forEach((data) {
      setState(() {
        var model = IncomeModel();
        model.amountEarned = data['amountEarned'];
        _totalncome = _totalncome + double.parse(model.amountEarned.toString());
      });
    });
  }

   final _advancedDrawerController = AdvancedDrawerController();
    void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    // if(_advancedDrawerController.value == AdvancedDrawerValue.visible()){
    //   _advancedDrawerController.hideDrawer();
    //   print("it opening now");
    //   //  _advancedDrawerController.value = AdvancedDrawerValue.hidden();

    // }
 

    

    _advancedDrawerController.addListener((){

      //  _advancedDrawerController.value = AdvancedDrawerValue.visible();

      if(_advancedDrawerController.value == AdvancedDrawerValue.visible()){
       
        //  _advancedDrawerController.value = AdvancedDrawerValue.hidden();
     
        print("it showing now");
         setState(() {
           myNavIcon = Icons.close;
         });
    }


      if(_advancedDrawerController.value == AdvancedDrawerValue.hidden()){
       
        //  _advancedDrawerController.value = AdvancedDrawerValue.visible();
     
        print("it closing now");
         setState(() {
           myNavIcon = Icons.tune;
         });
    }

    
    });

        _advancedDrawerController.showDrawer();
    
    

    
  }


  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
        backdropColor: Colors.greenAccent,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: true,
      
      
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      drawer: Drawer(


         child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text('The Brand Marketing'),
                  accountEmail: Text('support@thebrandmarketing.net'),
                  currentAccountPictureSize: const Size.square(80),
                  currentAccountPicture: GestureDetector(
                    child: Image.asset(
                        "assets/images/cattlec.png",
                       width: 150,
                       height: 150,
                      ),

                  ),
                ),
                // Divider(
                //   height: 1,
                //   thickness: 1,
                // ),

                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Text(
                //     'Want more features?',
                //   ),
                // ),
                // ListTile(
                //   leading: Icon(Icons.favorite),
                //   title: Text('Go Premium'),
                //   selected: _selectedDestination == 0,
                //   //onTap: () => selectDestination(0),
                // ),

                // Divider(
                //   height: 1,
                //   thickness: 2,
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Text(
                //     'Premium Only',
                //   ),
                // ),

               
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Reports',
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.my_library_books_rounded),
                  title: Text('Milk Report'),
                  selected: _selectedDestination == 3,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                       // MaterialPageRoute(builder: (context) => MilkReportPage()));
                        MaterialPageRoute(builder: (context) => NewHomeScreen()));
                  },
                  // onTap: () => selectDestination(3),
                ),
                ListTile(
                  leading: Icon(Icons.my_library_books),
                  title: Text('Events Report'),
                  selected: _selectedDestination == 1,
                  //onTap: () => selectDestination(1),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EventsReportPage()));
                  },
                ),

                 ListTile(
                  leading: Icon(Icons.event_available),
                  title: Text('Cattle Report'),
                  selected: _selectedDestination == 1,
                  //onTap: () => selectDestination(1),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PieChartSample2()));
                  },
                ),

                 ListTile(
                  leading: Icon(Icons.event_available_outlined),
                  title: Text('Transaction'),
                  selected: _selectedDestination == 1,
                  //onTap: () => selectDestination(1),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TransactionReportPage()));
                  },
                ),
                
                // ListTile(
                //   leading: Icon(Icons.label),
                //   title: Text('Back & Restore'),
                //   selected: _selectedDestination == 2,
                //   //onTap: () => selectDestination(2),
                // ),

                // Divider(
                //   height: 1,
                //   thickness: 2,
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Text(
                //     'Farm Account',
                //   ),
                // ),
                // ListTile(
                //   leading: Icon(Icons.bookmark),
                //   title: Text('Login Or create Account'),
                //   selected: _selectedDestination == 3,
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) => LoginPage()));
                //   },
                // ),

                Divider(
                  height: 1,
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Preferences',
                  ),
                ),

                   // ListTile(
                //   leading: Icon(Icons.bookmark),
                //   title: Text('Settings'),
                //   selected: _selectedDestination == 3,
                //   // onTap: () => selectDestination(3),
                // ),

                   // ListTile(
                //   leading: Icon(Icons.bookmark),
                //   title: Text('Reminders'),
                //   selected: _selectedDestination == 3,
                //   // onTap: () => selectDestination(3),
                // ),

                ListTile(
                  leading:  Icon(Icons.note),
                  title: Text('Farm Notes'),
                  selected: _selectedDestination == 3,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FarmNote()));
                  },
                 
                ),

                ListTile(
                  leading: Icon(Icons.share_sharp),
                  title: Text('Share'),
                  selected: _selectedDestination == 1,
                  onTap: (){
                     Navigator.pop(context);
                    Share.share(''' 

                    A powerful app for livestock farming. Track cattle, events, milk production and revenue. \n\n

Click on the Link below to download it from App Store. \n\n

https://apps.apple.com/us/app/track-my-brand/id1597499479
                   
                    
                    ''', 
                    subject: 'The Brand Marketing');
                  }
                ),
                // ListTile(
                //   leading: Icon(Icons.policy),
                //   title: Text('Privacy Policy'),
                //   selected: _selectedDestination == 2,
                //   //onTap: () => selectDestination(2),
                // ),
                // ListTile(
                //   leading: Icon(Icons.help),
                //   title: Text('User Guide/Manual'),
                //   selected: _selectedDestination == 2,
                //   //onTap: () => selectDestination(2),
                // ),
                // ListTile(
                //   leading: Icon(Icons.feedback),
                //   title: Text('Help & Feedback'),
                //   selected: _selectedDestination == 2,
                //   //onTap: () => selectDestination(2),
                // ),
              ],
            ),



          //  child: ListView(
          //   padding: EdgeInsets.all(10.0),
          //   children: _listViewData
          //       .map((data) => ListTile(
          //     title: Text(data),
          //   ))
          //       .toList(),
          // ),
        ),
      child: Scaffold(
        key: _scaffoldKey,
        // appBar: AppBar(),
      
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: Colors.green,
            child: Stack(
              children: <Widget>[
                //Container for top data
                Container(
                  margin: EdgeInsets.only(left: 32, top: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            // "\$$_totalncome",
                            "JS Cattle Manager",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                IconButton(
                                    onPressed: () {
                                      // _bottomSheet();
                                      // _myDrawer();
                                      // _newmodal();
                                      _handleMenuButtonPressed();
                                      // _scaffoldKey.currentState!.openDrawer();
                                    },
                                    icon: Icon(
                                      myNavIcon,
                                      color: Colors.white,
                                    )),
    
                                // _popupMenuWidget(),
    
                                // CircleAvatar(
                                //   radius: 25,
                                //   backgroundColor: Colors.white,
                                //   child: ClipOval(
                                //    // child: Image.asset("assets/dp.jpg", fit: BoxFit.contain,),
                                //   ),
                                // )
                              ],
                            ),
                          )
                        ],
                      ),
    
                      // Text(
                      //   "Total Income",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 16,
                      //       color: Colors.white),
                      // ),
    
                      //SizedBox(height : 24,),
    
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     Container(
                      //       child: Column(
                      //         children: <Widget>[
                      //           Container(
                      //             decoration: BoxDecoration(
                      //               color: Colors.white,
                      //               borderRadius: BorderRadius.all(Radius.circular(18))
                      //             ),
                      //             child: Icon(Icons.feedback,
                      //             color: Colors.green, size: 30,),
                      //             padding: EdgeInsets.all(12),
                      //           ),
                      //           SizedBox(
                      //             height: 4,
                      //           ),
                      //           Text("Help", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white),),
                      //         ],
                      //       ),
                      //     ),
    
                      //     Container(
                      //       child: Column(
                      //         children: <Widget>[
                      //           Container(
                      //             decoration: BoxDecoration(
                      //                 //color: Color.fromRGBO(243, 245, 248, 1),
                      //                 color: Colors.white,
                      //                 borderRadius: BorderRadius.all(Radius.circular(18))
                      //             ),
                      //             child: Icon(Icons.integration_instructions_sharp,
                      //             color: Colors.green, size: 30,),
                      //             padding: EdgeInsets.all(12),
                      //           ),
                      //           SizedBox(
                      //             height: 4,
                      //           ),
                      //           Text("Manual", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white),),
                      //         ],
                      //       ),
                      //     ),
    
                      //     Container(
                      //       child: Column(
                      //         children: <Widget>[
                      //           Container(
                      //             decoration: BoxDecoration(
                      //                 color: Colors.white,
                      //                 borderRadius: BorderRadius.all(Radius.circular(18))
                      //             ),
                      //             child: Icon(Icons.notes, color: Colors.green, size: 30,),
                      //             padding: EdgeInsets.all(12),
                      //           ),
                      //           SizedBox(
                      //             height: 4,
                      //           ),
                      //           Text("Notes", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white),),
                      //         ],
                      //       ),
                      //     ),
    
                      //     Container(
                      //       child: Column(
                      //         children: <Widget>[
                      //           Container(
                      //             decoration: BoxDecoration(
                      //                 color: Colors.white,
                      //                 borderRadius: BorderRadius.all(Radius.circular(18))
                      //             ),
                      //             child: Icon(Icons.settings,
                      //              color: Colors.green, size: 30,),
                      //             padding: EdgeInsets.all(12),
                      //           ),
                      //           SizedBox(
                      //             height: 4,
                      //           ),
                      //           Text("Settings", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white),),
                      //         ],
                      //       ),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ),
    
                Positioned(
                  right: 0,
                  left: 0,
                  top: 120,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 24,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Recent Transactions",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 24,
                                      color: Colors.black),
                                ),
                                //  Text("See all", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.grey[800]),)
                              ],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                          SizedBox(
                            height: 20,
                          ),
    
                          //Container for buttons
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "All",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.grey[900]),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade400,
                                            blurRadius: 5.0,
                                            spreadRadius: 2.0)
                                      ]),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 8,
                                        backgroundColor: Colors.green,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Income",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: Colors.grey[900]),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade400,
                                            blurRadius: 5.0,
                                            spreadRadius: 2.0)
                                      ]),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 8,
                                        backgroundColor: Colors.orange,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Expenses",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: Colors.grey[900]),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade400,
                                            blurRadius: 5.0,
                                            spreadRadius: 2.0)
                                      ]),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                )
                              ],
                            ),
                          ),
    
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CattlePage()));
                                      },
                                      child: Container(
                                          width: 150,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.shade400,
                                                    blurRadius: 5.0,
                                                    spreadRadius: 2.0)
                                              ]),
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/cownew.png",
                                                  width: 60,
                                                  height: 60,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Cattle",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14,
                                                      color: Colors.grey[900]),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MilkRecordPage()));
                                      },
                                      child: Container(
                                          width: 150,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.shade400,
                                                    blurRadius: 5.0,
                                                    spreadRadius: 2.0)
                                              ]),
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/milk-bottle1.png",
                                                  width: 60,
                                                  height: 60,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Milk",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14,
                                                      color: Colors.grey[900]),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
    
                                SizedBox(
                                  height: 16,
                                ),
    
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CattlePage()));
                                      },
                                      child: Container(
                                          width: 150,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.shade400,
                                                    blurRadius: 5.0,
                                                    spreadRadius: 2.0)
                                              ]),
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/notebook.png",
                                                  width: 60,
                                                  height: 60,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Events",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14,
                                                      color: Colors.grey[900]),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MilkRecordPage()));
                                      },
                                      child: Container(
                                          width: 150,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.shade400,
                                                    blurRadius: 5.0,
                                                    spreadRadius: 2.0)
                                              ]),
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/growth.png",
                                                  width: 60,
                                                  height: 60,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Transactions",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14,
                                                      color: Colors.grey[900]),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
    
                                SizedBox(
                                  height: 16,
                                ),
    
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CattlePage()));
                                      },
                                      child: Container(
                                          width: 150,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.shade400,
                                                    blurRadius: 5.0,
                                                    spreadRadius: 2.0)
                                              ]),
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/plant.png",
                                                  width: 60,
                                                  height: 60,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Farm setup",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14,
                                                      color: Colors.grey[900]),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MilkRecordPage()));
                                      },
                                      child: Container(
                                          width: 150,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.shade400,
                                                    blurRadius: 5.0,
                                                    spreadRadius: 2.0)
                                              ]),
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/analysis.png",
                                                  width: 60,
                                                  height: 60,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Reports",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14,
                                                      color: Colors.grey[900]),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                // SizedBox(height: 0.5,),
    
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
    
                          //now expense
                          SizedBox(
                            height: 16,
                          ),
    
                          Container(
                            child: Text(
                              "YESTERDAY",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[500]),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 32),
                          ),
    
                          SizedBox(
                            height: 16,
                          ),
    
                          ListView.builder(
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 32),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(18))),
                                      child: Icon(
                                        Icons.directions_car,
                                        color: Colors.green,
                                      ),
                                      padding: EdgeInsets.all(12),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Petrol",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey[900]),
                                          ),
                                          Text(
                                            "Payment from Saad",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey[500]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "-\$500.5",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.orange),
                                        ),
                                        Text(
                                          "26 Jan",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey[500]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            shrinkWrap: true,
                            itemCount: 2,
                            padding: EdgeInsets.all(0),
                            controller: ScrollController(keepScrollOffset: false),
                          ),
    
                          //now expense
                        ],
                      ),
                      //controller: scrollController,
                    ),
                  ),
                ),
    
                //draggable sheet
                // DraggableScrollableSheet(
                //   expand: true,
    
                //   builder: (context, scrollController){
                //     return Container(
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                //       ),
                //       child: SingleChildScrollView(
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: <Widget>[
                //             SizedBox(height: 24,),
                //             Container(
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("Recent Transactions", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: Colors.black),),
                //                 //  Text("See all", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.grey[800]),)
                //                 ],
                //               ),
                //                padding: EdgeInsets.symmetric(horizontal: 16),
                //             ),
                //             SizedBox(height: 20,),
    
                //             //Container for buttons
                //             Container(
                //                padding: EdgeInsets.symmetric(horizontal: 16),
                //               child: Row(
                //                 children: <Widget>[
                //                   Container(
                //                     child: Text("All", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey[900]),),
                //                     decoration: BoxDecoration(
                //                       color: Colors.white,
                //                       borderRadius: BorderRadius.all(Radius.circular(20)),
                //                       boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 5.0, spreadRadius: 2.0)]
                //                     ),
                //                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //                   ),
                //                   SizedBox(width: 16,),
                //                   Container(
                //                     child: Row(
                //                       children: <Widget>[
                //                         CircleAvatar(
                //                           radius: 8,
                //                           backgroundColor: Colors.green,
                //                         ),
                //                         SizedBox(
                //                           width: 8,
                //                         ),
                //                         Text("Income", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey[900]),),
                //                       ],
                //                     ),
                //                     decoration: BoxDecoration(
                //                         color: Colors.white,
                //                         borderRadius: BorderRadius.all(Radius.circular(20)),
                //                         boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 5.0, spreadRadius: 2.0)]
                //                     ),
                //                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //                   ),
    
                //                   SizedBox(width: 16,),
                //                   Container(
                //                     child: Row(
                //                       children: <Widget>[
                //                         CircleAvatar(
                //                           radius: 8,
                //                           backgroundColor: Colors.orange,
                //                         ),
                //                         SizedBox(
                //                           width: 8,
                //                         ),
                //                         Text("Expenses", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey[900]),),
                //                       ],
                //                     ),
                //                     decoration: BoxDecoration(
                //                         color: Colors.white,
                //                         borderRadius: BorderRadius.all(Radius.circular(20)),
                //                          boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 5.0, spreadRadius: 2.0)]
                //                     ),
                //                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //                   )
                //                 ],
                //               ),
                //             ),
    
                //             SizedBox(height: 16,),
                //            Container(
                //               padding: EdgeInsets.symmetric(horizontal: 16),
                //              child: Column(
                //   children: [
    
                //     Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //               Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                       builder: (context) => CattlePage()));
                //           },
    
                //               child: Container(
                //                   width: 150,
                //                   height: 100,
                //                    decoration: BoxDecoration(
                //                           color: Colors.white,
                //                           borderRadius: BorderRadius.all(Radius.circular(20)),
                //                           boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 5.0, spreadRadius: 2.0)]
                //                       ),
                //                   child: Center(
                //                     child: Column(
                //                       crossAxisAlignment: CrossAxisAlignment.center,
                //                       mainAxisAlignment: MainAxisAlignment.center,
                //                       children: [
                //                         Image.asset(
                //                           "assets/images/cownew.png",
                //                           width: 60,
                //                           height: 60,
                //                         ),
                //                         SizedBox(
                //                           height: 10,
                //                         ),
                //                         Text(
                //                           "Cattle",
                //                           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey[900]),
                //                         )
                //                       ],
                //                     ),
                //                   )
                //                   ),
    
                //         ),
    
                //         SizedBox(width: 16,),
    
                //         GestureDetector(
                //           onTap: () {
                //               Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                       builder: (context) => MilkRecordPage()));
                //           },
    
                //               child: Container(
                //                   width: 150,
                //                   height: 100,
                //                    decoration: BoxDecoration(
                //                           color: Colors.white,
                //                           borderRadius: BorderRadius.all(Radius.circular(20)),
                //                           boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 5.0, spreadRadius: 2.0)]
                //                       ),
                //                   child: Center(
                //                     child: Column(
                //                       crossAxisAlignment: CrossAxisAlignment.center,
                //                       mainAxisAlignment: MainAxisAlignment.center,
                //                       children: [
                //                         Image.asset(
                //                           "assets/images/milk-bottle1.png",
                //                           width: 60,
                //                           height: 60,
                //                         ),
                //                         SizedBox(
                //                           height: 10,
                //                         ),
                //                         Text(
                //                           "Milk",
                //                           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey[900]),
                //                         )
                //                       ],
                //                     ),
                //                   )
                //                   ),
    
                //         ),
                //       ],
                //     ),
    
                //     SizedBox(height: 16,),
    
                //     Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //               Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                       builder: (context) => CattlePage()));
                //           },
    
                //               child: Container(
                //                   width: 150,
                //                   height: 100,
                //                    decoration: BoxDecoration(
                //                           color: Colors.white,
                //                           borderRadius: BorderRadius.all(Radius.circular(20)),
                //                           boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 5.0, spreadRadius: 2.0)]
                //                       ),
                //                   child: Center(
                //                     child: Column(
                //                       crossAxisAlignment: CrossAxisAlignment.center,
                //                       mainAxisAlignment: MainAxisAlignment.center,
                //                       children: [
                //                         Image.asset(
                //                           "assets/images/notebook.png",
                //                           width: 60,
                //                           height: 60,
                //                         ),
                //                         SizedBox(
                //                           height: 10,
                //                         ),
                //                         Text(
                //                           "Events",
                //                           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey[900]),
                //                         )
                //                       ],
                //                     ),
                //                   )
                //                   ),
    
                //         ),
    
                //         SizedBox(width: 16,),
    
                //         GestureDetector(
                //           onTap: () {
                //               Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                       builder: (context) => MilkRecordPage()));
                //           },
    
                //               child: Container(
                //                   width: 150,
                //                   height: 100,
                //                    decoration: BoxDecoration(
                //                           color: Colors.white,
                //                           borderRadius: BorderRadius.all(Radius.circular(20)),
                //                           boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 5.0, spreadRadius: 2.0)]
                //                       ),
                //                   child: Center(
                //                     child: Column(
                //                       crossAxisAlignment: CrossAxisAlignment.center,
                //                       mainAxisAlignment: MainAxisAlignment.center,
                //                       children: [
                //                         Image.asset(
                //                           "assets/images/growth.png",
                //                           width: 60,
                //                           height: 60,
                //                         ),
                //                         SizedBox(
                //                           height: 10,
                //                         ),
                //                         Text(
                //                           "Transactions",
                //                           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey[900]),
                //                         )
                //                       ],
                //                     ),
                //                   )
                //                   ),
    
                //         ),
                //       ],
                //     ),
    
                //      SizedBox(height: 16,),
    
                //     Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //               Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                       builder: (context) => CattlePage()));
                //           },
    
                //               child: Container(
                //                   width: 150,
                //                   height: 100,
                //                    decoration: BoxDecoration(
                //                           color: Colors.white,
                //                           borderRadius: BorderRadius.all(Radius.circular(20)),
                //                           boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 5.0, spreadRadius: 2.0)]
                //                       ),
                //                   child: Center(
                //                     child: Column(
                //                       crossAxisAlignment: CrossAxisAlignment.center,
                //                       mainAxisAlignment: MainAxisAlignment.center,
                //                       children: [
                //                         Image.asset(
                //                           "assets/images/plant.png",
                //                           width: 60,
                //                           height: 60,
                //                         ),
                //                         SizedBox(
                //                           height: 10,
                //                         ),
                //                         Text(
                //                           "Farm setup",
                //                           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey[900]),
                //                         )
                //                       ],
                //                     ),
                //                   )
                //                   ),
    
                //         ),
    
                //         SizedBox(width: 16,),
    
                //         GestureDetector(
                //           onTap: () {
                //               Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                       builder: (context) => MilkRecordPage()));
                //           },
    
                //               child: Container(
                //                   width: 150,
                //                   height: 100,
                //                    decoration: BoxDecoration(
                //                           color: Colors.white,
                //                           borderRadius: BorderRadius.all(Radius.circular(20)),
                //                           boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 5.0, spreadRadius: 2.0)]
                //                       ),
                //                   child: Center(
                //                     child: Column(
                //                       crossAxisAlignment: CrossAxisAlignment.center,
                //                       mainAxisAlignment: MainAxisAlignment.center,
                //                       children: [
                //                         Image.asset(
                //                           "assets/images/increase.png",
                //                           width: 60,
                //                           height: 60,
                //                         ),
                //                         SizedBox(
                //                           height: 10,
                //                         ),
                //                         Text(
                //                           "Reports",
                //                           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey[900]),
                //                         )
                //                       ],
                //                     ),
                //                   )
                //                   ),
    
                //         ),
                //       ],
                //     ),
                //     // SizedBox(height: 0.5,),
    
                //     SizedBox(
                //       height: 20,
                //     )
                //   ],
                // ),
                //            ),
    
                //             //now expense
                //             SizedBox(height: 16,),
    
                //             Container(
                //               child: Text("YESTERDAY", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[500]),),
                //               padding: EdgeInsets.symmetric(horizontal: 32),
                //             ),
    
                //             SizedBox(height: 16,),
    
                //             ListView.builder(
                //               itemBuilder: (context, index){
                //                 return Container(
                //                   margin: EdgeInsets.symmetric(horizontal: 32),
                //                   padding: EdgeInsets.all(16),
                //                   decoration: BoxDecoration(
                //                       color: Colors.white,
                //                       borderRadius: BorderRadius.all(Radius.circular(20))
                //                   ),
                //                   child: Row(
                //                     children: <Widget>[
                //                       Container(
                //                         decoration: BoxDecoration(
                //                             color: Colors.grey[100],
                //                             borderRadius: BorderRadius.all(Radius.circular(18))
                //                         ),
                //                         child: Icon(Icons.directions_car, color: Colors.green,),
                //                         padding: EdgeInsets.all(12),
                //                       ),
    
                //                       SizedBox(width: 16,),
                //                       Expanded(
                //                         child: Column(
                //                           crossAxisAlignment: CrossAxisAlignment.start,
                //                           children: <Widget>[
                //                             Text("Petrol", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.grey[900]),),
                //                             Text("Payment from Saad", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[500]),),
                //                           ],
                //                         ),
                //                       ),
    
                //                       Column(
                //                         crossAxisAlignment: CrossAxisAlignment.end,
                //                         children: <Widget>[
                //                           Text("-\$500.5", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.orange),),
                //                           Text("26 Jan", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[500]),),
                //                         ],
                //                       ),
                //                     ],
                //                   ),
                //                 );
                //               },
                //               shrinkWrap: true,
                //               itemCount: 2,
                //               padding: EdgeInsets.all(0),
                //               controller: ScrollController(keepScrollOffset: false),
                //             ),
    
                //             //now expense
    
                //           ],
                //         ),
                //         controller: scrollController,
                //       ),
                //     );
                //   },
                //   initialChildSize: 0.65,
                //   minChildSize: 0.65,
                //   maxChildSize: 1,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _popupMenuWidget() {
    return PopupMenuButton(
      icon: Icon(
        Icons.tune,
        color: Colors.white,
      ),
      onSelected: (value) {
        setState(() {});
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: "Milk Report",
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
              Text("Milk Report"),
              SizedBox(
                width: 35,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "Events Report",
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
              Text("Events Report"),
              SizedBox(
                width: 35,
              ),
            ],
          ),
        ),
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
          value: 'All Active',
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
              Text("'Archive Cattle"),
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


  _newmodal(){
    
showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  barrierColor: Colors.transparent,
  builder: (context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 20.0,
            sigmaY: 20.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                color: Colors.black26,
                width: 0.5,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                       ListTile(
                    leading: Icon(Icons.my_library_books),
                    title: Text('Events Report'),
                    selected: _selectedDestination == 1,
                    //onTap: () => selectDestination(1),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventsReportPage()));
                    },
                  ),
                      
                  ListTile(
                    leading: Icon(Icons.event_available),
                    title: Text('Cattle Report'),
                    selected: _selectedDestination == 1,
                    //onTap: () => selectDestination(1),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PieChartSample2()));
                    },
                  ),
                      
                  ListTile(
                    leading: Icon(Icons.event_available_outlined),
                    title: Text('Transaction'),
                    selected: _selectedDestination == 1,
                    //onTap: () => selectDestination(1),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransactionReportPage()));
                    },
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.label),
                  //   title: Text('Back & Restore'),
                  //   selected: _selectedDestination == 2,
                  //   //onTap: () => selectDestination(2),
                  // ),
                      
                  // Divider(
                  //   height: 1,
                  //   thickness: 2,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Text(
                  //     'Farm Account',
                  //   ),
                  // ),
                  ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text('Login Or create Account'),
                    selected: _selectedDestination == 3,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                      
                  ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text('Settings'),
                    selected: _selectedDestination == 3,
                    // onTap: () => selectDestination(3),
                  ),
                      
                  ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text('Reminders'),
                    selected: _selectedDestination == 3,
                    // onTap: () => selectDestination(3),
                  ),
                      
                  ListTile(
                    leading: Icon(Icons.note),
                    title: Text('Farm Notes'),
                    selected: _selectedDestination == 3,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FarmNote()));
                    },
                  ),
                      
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Setttings'),
                    selected: _selectedDestination == 3,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FarmNote()));
                    },
                  ),
                
                ],
              ),
            ),
          ),
        ),
      ),
    );
  },
);
  }

  _bottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      enableDrag: true,

      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Text(
                //     'Want more features?',
                //   ),
                // ),
                // ListTile(
                //   leading: Icon(Icons.favorite),
                //   title: Text('Go Premium'),
                //   selected: _selectedDestination == 0,
                //   //onTap: () => selectDestination(0),
                // ),
          
                // Divider(
                //   height: 1,
                //   thickness: 2,
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Text(
                //     'Premium Only',
                //   ),
                // ),
          
                // ListTile(
                // leading: Icon(Icons.my_library_books_rounded),
                // title: Text('Milk Report'),
                // selected: _selectedDestination == 3,
                // onTap: () {
                //   Navigator.pop(context);
                //   Navigator.push(context,
                //      // MaterialPageRoute(builder: (context) => MilkReportPage()));
                //       MaterialPageRoute(builder: (context) => NewHomeScreen()));
                // },
                // // onTap: () => selectDestination(3),
                // ),
                ListTile(
                  leading: Icon(Icons.my_library_books),
                  title: Text('Events Report'),
                  selected: _selectedDestination == 1,
                  //onTap: () => selectDestination(1),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventsReportPage()));
                  },
                ),
          
                ListTile(
                  leading: Icon(Icons.event_available),
                  title: Text('Cattle Report'),
                  selected: _selectedDestination == 1,
                  //onTap: () => selectDestination(1),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PieChartSample2()));
                  },
                ),
          
                ListTile(
                  leading: Icon(Icons.event_available_outlined),
                  title: Text('Transaction'),
                  selected: _selectedDestination == 1,
                  //onTap: () => selectDestination(1),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionReportPage()));
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.label),
                //   title: Text('Back & Restore'),
                //   selected: _selectedDestination == 2,
                //   //onTap: () => selectDestination(2),
                // ),
          
                // Divider(
                //   height: 1,
                //   thickness: 2,
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Text(
                //     'Farm Account',
                //   ),
                // ),
                // ListTile(
                //   leading: Icon(Icons.bookmark),
                //   title: Text('Login Or create Account'),
                //   selected: _selectedDestination == 3,
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) => LoginPage()));
                //   },
                // ),
          
                // ListTile(
                //   leading: Icon(Icons.bookmark),
                //   title: Text('Settings'),
                //   selected: _selectedDestination == 3,
                //   // onTap: () => selectDestination(3),
                // ),
          
                // ListTile(
                //   leading: Icon(Icons.bookmark),
                //   title: Text('Reminders'),
                //   selected: _selectedDestination == 3,
                //   // onTap: () => selectDestination(3),
                // ),
          
                ListTile(
                  leading: Icon(Icons.note),
                  title: Text('Farm Notes'),
                  selected: _selectedDestination == 3,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FarmNote()));
                  },
                ),
          
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Setttings'),
                  selected: _selectedDestination == 3,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FarmNote()));
                  },
                ),
          
                ListTile(
                    leading: Icon(Icons.share_sharp),
                    title: Text('Share'),
                    selected: _selectedDestination == 1,
                    onTap: () {
                      Navigator.pop(context);
                      Share.share(''' 
                
                    A powerful app for livestock farming. Track cattle, events, milk production and revenue. \n\n
                
                Click on the Link below to download it from App Store. \n\n
                
                https://apps.apple.com/us/app/track-my-brand/id1597499479
                    
                    
                    ''', subject: 'The Brand Marketing');
                    }),
                // ListTile(
                //   leading: Icon(Icons.policy),
                //   title: Text('Privacy Policy'),
                //   selected: _selectedDestination == 2,
                //   //onTap: () => selectDestination(2),
                // ),
                // ListTile(
                //   leading: Icon(Icons.help),
                //   title: Text('User Guide/Manual'),
                //   selected: _selectedDestination == 2,
                //   //onTap: () => selectDestination(2),
                // ),
                // ListTile(
                //   leading: Icon(Icons.feedback),
                //   title: Text('Help & Feedback'),
                //   selected: _selectedDestination == 2,
                //   //onTap: () => selectDestination(2),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

   _myDrawer(){

  showCupertinoModalPopup(
    context: context,
     builder: (BuildContext context){

      return Container(
     child: ListView(
       padding: EdgeInsets.zero,
       children: [
         

                
               Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Text(
                   'Reports',
                 ),
               ),
               ListTile(
                 leading: Icon(Icons.my_library_books_rounded),
                 title: Text('Milk Report'),
                 selected: _selectedDestination == 3,
                 onTap: () {
                   Navigator.pop(context);
                   Navigator.push(context,
                      // MaterialPageRoute(builder: (context) => MilkReportPage()));
                       MaterialPageRoute(builder: (context) => NewHomeScreen()));
                 },
                 // onTap: () => selectDestination(3),
               ),
       ],

     ),
   );

     }
     );

   

  }
}
