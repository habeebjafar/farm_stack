import 'package:farmapp/pages/cattle_page.dart';
import 'package:farmapp/pages/event_page.dart';
import 'package:farmapp/pages/events_report_page.dart';
import 'package:farmapp/pages/farm_notes.dart';
import 'package:farmapp/pages/farm_setup_page.dart';
import 'package:farmapp/pages/milk_record_page.dart';
import 'package:farmapp/pages/newhomepage.dart';
import 'package:farmapp/pages/payment_test.dart';
import 'package:farmapp/pages/pie_chart_page.dart';
import 'package:farmapp/pages/report_page.dart';
import 'package:farmapp/pages/transaction_page.dart';
import 'package:farmapp/pages/transactions_report_page.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDestination = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("The Brand Marketing"),
      ),
      drawer: Container(
          color: Colors.black,
          child: Drawer(
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
                        // MaterialPageRoute(builder: (context) => EventsReportPage()));
                         MaterialPageRoute(builder: (context) => PaymentTest()));
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
          )
          ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(200, 50),
                    bottomLeft: Radius.elliptical(200, 50)),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CattlePage()));
                      },
                      child: Card(
                        elevation: 10,
                        child: Container(
                            width: 160,
                            height: 180,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/cattle.jpg",
                                    width: 100,
                                    height: 100,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Cattle",
                                    style: TextStyle(
                                      fontSize: 16,
                                      // fontWeight: FontWeight.w800
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MilkRecordPage()));
                      },
                      child: Card(
                        elevation: 10,
                        child: Container(
                            width: 160,
                            height: 180,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/milk.png",
                                    width: 100,
                                    height: 100,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Milk Records",
                                    style: TextStyle(
                                      fontSize: 16,
                                      // fontWeight: FontWeight.w800
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 0.5,),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventPage()));
                      },
                      child: Card(
                        elevation: 10,
                        child: Container(
                            width: 160,
                            height: 180,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/notes.png",
                                    width: 100,
                                    height: 100,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Events",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransactiontPage()));
                      },
                      child: Card(
                        elevation: 10,
                        child: Container(
                            width: 160,
                            height: 180,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/money-bag.png",
                                    width: 100,
                                    height: 100,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Transactions",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FarmSetupPage()));
                      },
                      child: Card(
                        elevation: 10,
                        child: Container(
                            width: 160,
                            height: 180,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/agronomy.png",
                                    width: 100,
                                    height: 100,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Farm Setup",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportPage()));
                      },
                      child: Card(
                        elevation: 10,
                        child: Container(
                            width: 160,
                            height: 180,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/increase.png",
                                    width: 100,
                                    height: 100,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Reports",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 20,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
