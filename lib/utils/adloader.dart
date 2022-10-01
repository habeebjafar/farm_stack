import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ad_helper.dart';

class AdLoader{
  static int kAdIndex = 2;
   BannerAd? ad;
   late BannerAd bannerAd;
  AdLoader(){
       bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.fullBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (myad) {
          // setState(() {
            ad = myad as BannerAd;
          // });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
  }
 
  int getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= kAdIndex && ad != null) {
      return rawIndex - 1;
    }
    return rawIndex;
  }
 

   loadBannerAds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //bool _isSubscribed;
    int? isSubscribed = prefs.getInt("subscribed");
    if (isSubscribed != 1) {
      bannerAd.load();
    }
  }
}