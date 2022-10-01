import 'package:farmapp/ad_helper.dart';
import 'package:farmapp/pages/events_report_page.dart';
import 'package:farmapp/pages/milk_report_page.dart';
import 'package:farmapp/pages/pie_chart_page.dart';
import 'package:farmapp/pages/transactions_report_page.dart';
import 'package:farmapp/widget/premium_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  
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
    _loadAds(); 
    super.initState();
  }
  @override
  void dispose() {

    _interstitialAd?.dispose();

    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    if (_isInterstitialAdReady) {
                _interstitialAd?.show();
              } 
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionReportPage()));
                  },
                  child: Card(
                    elevation: 10,
                    child: Container(
                        width: 160,
                        height: 140,
                        color: Colors.orange,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/salary.png",
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Transactions",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
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
                  child: Card(
                    elevation: 10,
                    child: Container(
                        width: 160,
                        height: 140,
                        color: Theme.of(context).primaryColor,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/milk.png",
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Milk Report",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_isInterstitialAdReady) {
                _interstitialAd?.show();
              } 
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PieChartSample2()));
                  },
                  child: Card(
                    elevation: 10,
                    child: Container(
                        width: 160,
                        height: 140,
                        color: Theme.of(context).primaryColor,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/cow3.png",
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Cattle Report",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    SharedPreferences _prefs =
                        await SharedPreferences.getInstance();
                    
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
                  child: Card(
                    elevation: 10,
                    child: Container(
                        width: 160,
                        height: 140,
                        color: Colors.orange,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/notes.png",
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Events Report",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center)
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
        ),
      ),
    );
  }
}
