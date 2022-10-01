
import 'package:farmapp/ad_helper.dart';
import 'package:farmapp/provider/transactions_provider.dart';
import 'package:farmapp/services/transactions_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'income_form_test.dart';



class AllTransaction extends StatefulWidget {
  const AllTransaction({ Key? key }) : super(key: key);

  @override
  State<AllTransaction> createState() => _AllTransactionState();
}

class _AllTransactionState extends State<AllTransaction> {

    static final _kAdIndex = 1;
  BannerAd? _ad;
  late BannerAd _bannerAd;
 
  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _ad != null) {
      return rawIndex - 1;
    }
    return rawIndex;
  }
  

   _loadBannerAds() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    //bool _isSubscribed;
    int? isSubscribed = _prefs.getInt("subscribed");
    if (isSubscribed != 1) {
      _bannerAd.load();
    }
  }

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.fullBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _loadBannerAds();


     Provider.of<TransactionsProvider>(context, listen: false).getAllTransactionsRecord();
     
   
  }

   @override
  void dispose() {
      _ad?.dispose();
       _bannerAd.dispose();
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Transactions"),
      ),
      body: Consumer<TransactionsProvider> (
        builder: (_, provider, __) =>  provider.transactionList.length == 0 ? Center(
          child: Text("No transaction recorded yet!",
          style: TextStyle(
            fontSize: 18,
            color: Colors.orange
          ),)
        ) : SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                    itemCount: provider.transactionList.length + (_ad != null ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {

                       final newIndex = _getDestinationItemIndex(index);
        
                      String incomeType = provider.transactionList[newIndex].type.toString();
                      String transType = provider.transactionList[newIndex].transactionType.toString();
                      var formatAmountEarned = NumberFormat('#,###.00').format(num.parse("${provider.transactionList[newIndex].amount.toString()}"));
                       var date = DateFormat('MMMM dd, yyyy').format(DateTime.parse(
                    "${provider.transactionList[newIndex].date.toString()}"));
                     
                      if (_ad != null && index == _kAdIndex) {
                              return Card(
                                child: Container(
                                  width: _ad!.size.width.toDouble(),
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  height: 90.0,
                                  alignment: Alignment.center,
                                  child: AdWidget(ad: _ad!),
                                ),
                              );
                            } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             CattleDetailsPage(_list, index)));
                          },
                          child: Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: 4,),
                                          
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("${incomeType == 'Milk Sale' ? incomeType + ' (${provider.transactionList[newIndex].milkQty})' :
                                                incomeType == 'Category Income' || incomeType == 'Category Expense' ?  provider.transactionList[newIndex].selectedValueCategory : 
                                                incomeType == 'Other (specify)' ?  provider.transactionList[newIndex].otherIncomeExpense: '' }",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15
                                                ),),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text("$date")
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                child: transType == "Income" ? Text(
                                                  "Income",
                                                  style: TextStyle(
                                                    color: Colors.green
                                                  )
                                                  ) : Text(
                                                    "Expense",
                                                    style: TextStyle(
                                                    color: Colors.orange
                                                  )
                                                    ) ,
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Text(
                                                "$formatAmountEarned",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    0, 10, 0, 0),
                                                child: Icon(Icons.star_border),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              popupMenuWidget(newIndex, provider.transactionList[newIndex].id, provider.transactionList[newIndex].transactionType)
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
                            }
                    }),
                    SizedBox(height: 60,)
            ],
          ),
        )
        ),

    );
  }

   Widget popupMenuWidget(index, id, transType) {
    var selectedValue;
    return PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: Colors.black,
        ),
        onSelected: (value) {
          setState(() {
            selectedValue = value as String;

            if (selectedValue == "Edit Event") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IncomeFormTest(index: index, transType: transType)));
            } else if (selectedValue == "Delete") {
              _deleteEventDialog(id);
            }
          });
        },
        itemBuilder: (_) => [
              PopupMenuItem(value: "Edit Event", child: Padding(
                padding: const EdgeInsets.only(right: 60),
                child: Text("Edit Event"),
              )),
              PopupMenuItem(value: "Delete", child: Padding(
                 padding: const EdgeInsets.only(right: 60),
                child: Text("Delete"),
              )),
            ]);
  }

  _deleteEventDialog(id) {
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
                    
                    TransactionsService service = TransactionsService();
                    var response = await service.deleteTransactionsById(id);

                    if (response > 0) {
                      print("successfully deleted");
                      await Provider.of<TransactionsProvider>(context, listen: false)
                          .getAllTransactionsRecord();
                    } else {
                      print("successfully failed");
                    }

                    Navigator.pop(context);
                  },
                  child: Text(
                    "DELETE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              title: Text("Deleting farm income!"),
              content: Text(
                "Are you sure you want to delete this income?"));
        });
  }


}