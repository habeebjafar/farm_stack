// import 'package:flutter/material.dart';  
  
// void main() => runApp(MyApp());  
  
// class MyApp extends StatelessWidget {  
//   // This widget is the root of your application.  
//   @override  
//   Widget build(BuildContext context) {  
//     return MaterialApp(  
//       title: 'Flutter Application',  
//       theme: ThemeData(  
//         primarySwatch: Colors.orange,  
//       ),  
//       home: HeroAnimation(title: 'Hero Animation'),  
//     );  
//   }  
// }  
  
// class HeroAnimation extends StatefulWidget {  
//   HeroAnimation({Key? key, required this.title}) : super(key: key);  
//   final String title;  
  
//   @override  
//   _HeroAnimationState createState() => _HeroAnimationState();  
// }  
  
// class _HeroAnimationState extends State<HeroAnimation> {  
  
//   Widget _greenRectangle() {  
//     return Container(  
//       width: 75,  
//       height: 75,  
//       color: Colors.green,  
//     );  
//   }  
  
//   Widget _detailPageRectangle() {  
//     return Container(  
//       width: 150,  
//       height: 150,  
//       color: Colors.red,  
//     );  
//   }  
  
//   @override  
//   Widget build(BuildContext context) {  
//     return Scaffold(  
//       appBar: AppBar(  
//         title: Text(widget.title),  
//       ),  
//       body: buildDemoWidget(context),  
//     );  
//   }  
  
//   Widget buildDemoWidget(BuildContext context) {  
//     return Center(  
//       child: Column(  
//         crossAxisAlignment: CrossAxisAlignment.start,  
//         children: <Widget>[  
//           SizedBox(  
//             height: 30.0,  
//           ),  
//           ListTile(  
//             leading: GestureDetector(  
//               child: Hero(  
//                 tag: 'hero-rectangle',  
//                 child: _greenRectangle(),  
//               ),  
//               onTap: () => _gotoDetailsPage(context),  
//             ),  
//             title: Text('Tap on the green icon rectangle to analyse hero animation transition.'),  
//           ),  
//         ],  
//       ),  
//     );  
//   }  
  
//   void _gotoDetailsPage(BuildContext context) {  
//     Navigator.of(context).push(MaterialPageRoute(  
//       builder: (ctx) => Scaffold(  
//         body: Center(  
//           child: Column(  
//             mainAxisAlignment: MainAxisAlignment.center,  
//             children: <Widget>[  
//               Hero(  
//                 tag: 'hero-rectangle',  
//                 child: _detailPageRectangle(),  
//               ),  
//               Text('This is a place where you can see details about the icon tapped at previous page.'),  
//             ],  
//           ),  
//         ),  
//       ),  
//     ));  
//   }  

// } 










import 'package:farmapp/pages/home_page.dart';
import 'package:farmapp/provider/cattle_provider.dart';
import 'package:farmapp/provider/events_provider.dart';
import 'package:farmapp/provider/farm_note_provider.dart';
import 'package:farmapp/provider/milk_provider.dart';
import 'package:farmapp/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
       ChangeNotifierProvider<CattleProvider>(
        create: (context) => CattleProvider()),
        ChangeNotifierProvider<EventsProvider>(
          create: (context) => EventsProvider(),
        ),
        ChangeNotifierProvider<MilkProvider>(
          create: (context) => MilkProvider(),
        ),
         ChangeNotifierProvider<TransactionsProvider>(
          create: (context) => TransactionsProvider(),
        ),
         ChangeNotifierProvider<FarmNoteProvider>(
          create: (context) => FarmNoteProvider(),
        ),
      ],
        child: MaterialApp(
          title: 'The Brand Marketing',        
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            
            
            primarySwatch: Colors.green,
          ),
         home: HomePage()
          // home: NewHomeScreen()
        ),
      );
    
  }
}

