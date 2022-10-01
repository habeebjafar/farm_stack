import 'package:farmapp/ad_helper.dart';
import 'package:farmapp/models/milk_model.dart';
import 'package:farmapp/pages/milk_record_form_page.dart';
import 'package:farmapp/pages/milk_search_page.dart';
import 'package:farmapp/provider/milk_provider.dart';
import 'package:farmapp/services/milk_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MilkRecordPage extends StatefulWidget {
  @override
  _MilkRecordPageState createState() => _MilkRecordPageState();
}

class _MilkRecordPageState extends State<MilkRecordPage> {
  double leastProductive = 0.0;
  double highestProductive = 0.0;

  static final _kAdIndex = 1;
  BannerAd? _ad;
  late BannerAd _bannerAd;
 
  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _ad != null) {
      return rawIndex - 1;
    }
    return rawIndex;
  }
  

  


 InterstitialAd? _interstitialAd;
 bool _isInterstitialAdReady = false;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {},
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

  _loadInterAds() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    //bool _isSubscribed;
    int? isSubscribed = _prefs.getInt("subscribed");
    if (isSubscribed != 1) {
       _bannerAd.load();
      _loadInterstitialAd();
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

    
     _loadInterAds();
    
  }
  @override
  void dispose() {
    _ad?.dispose();
    _bannerAd.dispose();
     _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Milk Records"),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, 
            MaterialPageRoute(builder: (context) => MilkSearchPage()));

          }, 
          icon: Icon(Icons.search)),
        ],
      ),
      body: FutureBuilder(
          future: Provider.of<MilkProvider>(context, listen: false)
              .getAllMilkRecord(),
          builder:
              (BuildContext context, AsyncSnapshot<List<MilkModel>> snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              
            
            return Consumer<MilkProvider>(
                builder: (_, milkProvider, __) =>  milkProvider.milkRecordList.length == 0 ? Center(
          child: Text("No milk recorded yet!",
          style: TextStyle(
            fontSize: 18,
            color: Colors.orange
          ),)
        ) : ListView.builder(
                    itemCount: milkProvider.milkRecordList.length + (_ad != null ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                       final newIndex = _getDestinationItemIndex(index);
                      double result = double.parse(milkProvider
                              .milkRecordList[newIndex].milkTotalProduced
                              .toString()) -
                          double.parse(milkProvider
                              .milkRecordList[newIndex].milkTotalUsed
                              .toString());

                              var date = DateFormat('MMMM dd, yyyy').format(DateTime.parse(
                    "${milkProvider.milkRecordList[newIndex].milkDate.toString()}"));

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
                        child: Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${milkProvider.milkRecordList[newIndex].milkType == 'Individual Milk' ? milkProvider.milkRecordList[newIndex].cowMilked : '${milkProvider.milkRecordList[newIndex].milkType}(${milkProvider.milkRecordList[newIndex].noOfCattleMilked})'}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              //color: Colors.blueGrey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "$date",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${milkProvider.milkRecordList[newIndex].milkTotalProduced}",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text("Produced")
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${milkProvider.milkRecordList[newIndex].milkTotalUsed}",
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text("Used")
                                      ],
                                    ),
                                    // Column(
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.start,
                                    //   children: [
                                    //     Text(""),
                                    //     SizedBox(
                                    //       height: 2,
                                    //     ),
                                    //     Text("Left:")
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: 15,
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Left: $result",
                                    style: TextStyle(
                                        color: result > 0
                                            ? Theme.of(context).primaryColor
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  popupMenuWidget(newIndex,
                                      milkProvider.milkRecordList[newIndex].id)
                                ],
                              ),
                             
                            ],
                          ),
                        ),
                      );
                            }
                    }));
            }
          }),
      floatingActionButton: GestureDetector(
        onTap: () {
           if (_isInterstitialAdReady) {
            _interstitialAd?.show();
          }
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MilkFormPage()));
        },
        child: Container(
          width: 130,
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
                "ADD MILK",
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

  Widget popupMenuWidget(index, id) {
    var selectedValue;
    return PopupMenuButton(
        onSelected: (value) {
          setState(() {
            selectedValue = value as String;

            if (selectedValue == "Edit Record") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MilkFormPage(
                            index: index,
                          )));
            } else if (selectedValue == "Delete") {
              deleteCattleDialog(id);
            }
          });
        },
        itemBuilder: (_) => [
              PopupMenuItem(value: "Edit Record", child: Text("Edit Record")),
              PopupMenuItem(value: "Delete", child: Text("Delete")),
            ]);
  }


  deleteCattleDialog(id) {
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
                    MilkService milkService = MilkService();
                    var response = await milkService.deleteTodoById(id);

                    if (response > 0) {
                      print("successfully deleted");
                      await Provider.of<MilkProvider>(context, listen: false)
                          .getAllMilkRecord();
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
              title: Text("Deleting milk!"),
              content: Text(
                  "This milk record will be deleted permanently! Do you wish to continue?"));
        });
  }
}
