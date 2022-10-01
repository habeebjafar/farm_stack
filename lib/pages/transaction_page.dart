
import 'package:farmapp/pages/income_page.dart';

import 'package:flutter/material.dart';

import 'expense_page.dart';

class TransactiontPage extends StatefulWidget {
  final toExpensePage;
  const TransactiontPage({this.toExpensePage});
  @override
  _TransactiontPageState createState() => _TransactiontPageState();
}

class _TransactiontPageState extends State<TransactiontPage> with TickerProviderStateMixin {

  late TabController   tabController;

  @override
  void initState() {
  
    tabController = TabController(
      length: 2, 
      vsync: this,
      //  initialIndex: 1,
       
       );

       if (widget.toExpensePage == 1) {
  tabController.index = 1;
}
     
      
    super.initState();
  }

  @override
  void dispose() {
   tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            //backgroundColor: Colors.black,
            //centerTitle: true,
           // titleSpacing: 0.0,
            toolbarHeight: 100,
            title: Text("Transactions"),
            bottom: PreferredSize(
              preferredSize: Size.zero,
              child: Container(
                color: Colors.white,
                child: TabBar(
                  controller: tabController,
                  indicatorColor: Colors.orange,
                  //indicatorWeight: 10,
                  //indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.green ,
                  tabs: [
                    Tab(
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 8,),
                          Text("INCOME",
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
                          SizedBox(width: 8,),
                          Text("EXPENSES")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: tabController,
            
            


            children: [IncomePage(), ExpensesPage()],
          ),
        ),
      ),
    );
  }
}
