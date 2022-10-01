import 'dart:ui';

import 'package:farmapp/ad_helper.dart';
import 'package:farmapp/models/income_model.dart';
import 'package:farmapp/pages/cattle_page.dart';
import 'package:farmapp/pages/event_page.dart';
import 'package:farmapp/pages/events_report_page.dart';
import 'package:farmapp/pages/farm_notes.dart';
import 'package:farmapp/pages/farm_setup_page.dart';
import 'package:farmapp/pages/feedback_page.dart';
import 'package:farmapp/pages/milk_record_page.dart';
import 'package:farmapp/pages/pie_chart_page.dart';
import 'package:farmapp/pages/receipt.dart';
import 'package:farmapp/pages/report_page.dart';
import 'package:farmapp/pages/testcode.dart';
import 'package:farmapp/pages/transaction_page.dart';
import 'package:farmapp/pages/transactions_all.dart';
import 'package:farmapp/pages/transactions_report_page.dart';
import 'package:farmapp/services/income_service.dart';
import 'package:farmapp/widget/premium_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'milk_report_page.dart';
import 'paystack_payment._page.dart';

class NewHomeScreen extends StatefulWidget {
  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  var _selectedDestination;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _totalncome = 0.0;

  IconData myNavIcon = Icons.tune;

   InterstitialAd? _interstitialAd;

  
  bool _isInterstitialAdReady = false;

  subPrem() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
      //bool _isSubscribed;
      _prefs.setInt("subscribed", 1);
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
             
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

   _loadAds() async{
    SharedPreferences _prefs =
                        await SharedPreferences.getInstance();
                    //bool _isSubscribed;
                    int? isSubscribed = _prefs.getInt("subscribed");
                    if (isSubscribed != 1) {
                       _loadInterstitialAd();

                    }
  }


  @override
  void initState() {
    super.initState();
     _loadAds(); 
    _getTotalIncome();
    subPrem();
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

     Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  final _advancedDrawerController = AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    _advancedDrawerController.addListener(() {

      if (_advancedDrawerController.value == AdvancedDrawerValue.visible()) {
        setState(() {
          myNavIcon = Icons.close;
        });
      }

      if(_advancedDrawerController.value == AdvancedDrawerValue.hidden()) {
     
      
        setState(() {
          myNavIcon = Icons.tune;
        });
      }
    });

    _advancedDrawerController.showDrawer();
  }

  @override
  void dispose() {
    _advancedDrawerController.dispose();
     _interstitialAd?.dispose();

    super.dispose();
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
             onTap: () async {
              _advancedDrawerController.hideDrawer();
                    SharedPreferences _prefs =
                        await SharedPreferences.getInstance();
                    //bool _isSubscribed;
                    int? isSubscribed = _prefs.getInt("subscribed");
                    if (isSubscribed == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MilkReportPage()));
                    }else{
                     
                      PremiumWidget.activateDialog(context);
                    }
                  },
             
            ),
            ListTile(
              leading: Icon(Icons.my_library_books),
              title: Text('Events Report'),
              // selected: _selectedDestination == 1,
              //onTap: () => selectDestination(1),
               onTap: () async {
                 _advancedDrawerController.hideDrawer();
                    SharedPreferences _prefs =
                        await SharedPreferences.getInstance();
                    //bool _isSubscribed;
                    int? isSubscribed = _prefs.getInt("subscribed");
                    if (isSubscribed == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventsReportPage()));
                    }else{
                     
                      PremiumWidget.activateDialog(context);
                    }
                  },
            ),

            ListTile(
              leading: Icon(Icons.event_available),
              title: Text('Cattle Report'),
              // selected: _selectedDestination == 1,
              //onTap: () => selectDestination(1),
              onTap: () {
                _advancedDrawerController.hideDrawer();
                if (_isInterstitialAdReady) {
                _interstitialAd?.show();
              } 
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
               _advancedDrawerController.hideDrawer();
               if (_isInterstitialAdReady) {
                _interstitialAd?.show();
              } 
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
              leading: Icon(Icons.note),
              title: Text('Farm Notes'),
              selected: _selectedDestination == 3,
              onTap: () {
               _advancedDrawerController.hideDrawer();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FarmNote()));
              },
            ),

            ListTile(
                leading: Icon(Icons.share_sharp),
                title: Text('Share'),
                selected: _selectedDestination == 1,
                onTap: () {
                 _advancedDrawerController.hideDrawer();
                  Share.share(''' 

                    A powerful app for livestock farming. Track cattle, events, milk production and revenue. \n\n

Click on the Link below to download it from App Store. \n\n

https://apps.apple.com/us/app/track-my-brand/id1597499479
                   
                    
                    ''', subject: 'The Brand Marketing');
                }),
                ListTile(
              leading: Icon(Icons.search),
              title: Text('Related Farming Apps'),
              selected: _selectedDestination == 2,
              onTap: () async{
                _advancedDrawerController.hideDrawer();
                await _launchInBrowser(Uri.parse('https://www.google.com'));
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_outlined),
              title: Text('Privacy Policy'),
              selected: _selectedDestination == 2,
             onTap: () async{
                _advancedDrawerController.hideDrawer();
                await _launchInBrowser(Uri.parse('https://www.google.com'));
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('User Guide/Manual'),
              selected: _selectedDestination == 2,
              onTap: () async{
                _advancedDrawerController.hideDrawer();
                await _launchInBrowser(Uri.parse('https://www.google.com'));
              },
            ),
            ListTile(
              leading: Icon(Icons.email_outlined),
              title: Text('Help & Feedback'),
              selected: _selectedDestination == 2,
              onTap: () async{
                _advancedDrawerController.hideDrawer();
                Navigator.push(
                  context, 
                MaterialPageRoute(builder: (context) => FeedbackPage())
                );


              },
            ),
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
                                IconButton(
                                  onPressed: (){
                                    Navigator.push(context,
                                    //  MaterialPageRoute(builder: (context) => Receipt())
                                    MaterialPageRoute(builder: (context) => TestCode())
                                     );
                                  },
                                  icon: Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                IconButton(
                                    onPressed: () {
                                 
                                      _handleMenuButtonPressed();
                                     
                                    },
                                    icon: Icon(
                                      myNavIcon,
                                      color: Colors.white,
                                    )),

                             
                              ],
                            ),
                          )
                        ],
                      ),

                    
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
                                InkWell(
                                   onTap: (){

                                    Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AllTransaction()));

                                  },
                                  child: Container(
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
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                InkWell(
                                  onTap: (){
                                     Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TransactiontPage()));
                                  },
                                  child: Container(
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
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                InkWell(
                                  onTap: (){

                                    Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TransactiontPage(toExpensePage: 1,)));

                                  },
                                  
                                  child: Container(
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
                                  ),
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
                                                  // "assets/images/cownew.png",
                                                  "assets/images/cow3.png",
                                                  width: 60,
                                                  height: 60,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Cattle",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                    EventPage()));
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
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                    TransactiontPage()));
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
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                    FarmSetupPage()));
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
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                    ReportPage()));
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
                                                      fontWeight:
                                                          FontWeight.w700,
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

                        
                        ],
                      ),
                     
                    ),
                  ),
                ),

            
              ],
            ),
          ),
        ),
      ),
    );
  }


}
