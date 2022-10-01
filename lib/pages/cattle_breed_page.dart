import 'package:farmapp/ad_helper.dart';
import 'package:farmapp/models/cattle_breed_model.dart';
import 'package:farmapp/pages/cattle_breed_search_page.dart';
import 'package:farmapp/provider/cattle_provider.dart';
import 'package:farmapp/services/cattle_breed_service.dart';


import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CattleBreedPage extends StatefulWidget {
  @override
  _CattleBreedPageState createState() => _CattleBreedPageState();
}

class _CattleBreedPageState extends State<CattleBreedPage> {
  TextEditingController _incomeCategoryName = TextEditingController();

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
      
      _loadInterstitialAd();
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<CattleProvider>(context, listen: false).getAllCattleBreeds();

     _loadInterAds();
  }

    @override
  void dispose(){
    
     _incomeCategoryName.dispose();
    
     _interstitialAd?.dispose();
    super.dispose();
    
  }

  _editCategoryDialog(BuildContext context, {int? id}) {
    var cattleProvider = Provider.of<CattleProvider>(context, listen: false);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
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
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary),
                ),
                onPressed: () async {
                  CattleBreedService cattleBreedService = CattleBreedService();
                  var model = CattleBreedModel();
                  model.cattleBreed = _incomeCategoryName.text;
                  var response;
                  if (id != null) {
                    model.id = id;
                    response = await cattleBreedService.updateCattle(model);
                    await cattleProvider
                          .updateCattleSingleField("cattleBreedId", "cattleBreed", _incomeCategoryName.text, id);
                  } else {
                    response = await cattleBreedService.saveCattle(model);
                  }

                  if (response > 0) {
                    await cattleProvider.getAllCattleBreeds();
                    print("added");
                  } else {
                    print("failed");
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  "ADD",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            title: Text("New Breed"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _incomeCategoryName,
                    style: TextStyle(fontSize: 20.0),
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        //hintText: "Cattle name. *",
                        labelText: "Enter breed name ...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cattle Breeds"),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => CattleBreedSearchPage()));
          },
           icon: Icon(Icons.search)),
          //IconButton(onPressed: () {}, icon: Icon(Icons.filter_list)),
        ],
      ),
      body: Consumer<CattleProvider> (
          builder: (_, cattleProvider, __) => cattleProvider.list.length == 0 ? Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("No cattle breeds have recorded yet!",
            style: TextStyle(
              fontSize: 18,
              color: Colors.orange
            ),),
          )
        ) : ListView.builder(
              itemCount: cattleProvider.list.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 2, 0, 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${cattleProvider.list[index].cattleBreed}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              popupMenuWidget(cattleProvider.list[index].id,
                                  cattleProvider.list[index].cattleBreed)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              )
              ),
      floatingActionButton: GestureDetector(
        onTap: () {
           if (_isInterstitialAdReady) {
            _interstitialAd?.show();
          }
          _incomeCategoryName.clear();
          _editCategoryDialog(context);
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

  Widget popupMenuWidget(id, incomeName) {
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
              _incomeCategoryName.text = incomeName;

              _editCategoryDialog(context, id: id);
            } else if (selectedValue == "Delete") {
              _deleteEventDialog(id, incomeName);
            }
          });
        },
        itemBuilder: (_) => [
              PopupMenuItem(value: "Edit Event", child: Text("Edit Event")),
              PopupMenuItem(value: "Delete", child: Text("Delete")),
            ]);
  }

  _deleteEventDialog(id, incomeName) {
    var cattleProvider = Provider.of<CattleProvider>(context, listen: false);
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
                   
                    CattleBreedService cattleBreedService =
                        CattleBreedService();
                    var response =
                        await cattleBreedService.deleteCattleBreedById(id);

                    if (response > 0) {
                      print("successfully deleted");
                       await cattleProvider
                          .updateCattleSingleField("cattleBreedId", "cattleBreed", "-", id);
                      // if (delResponse > 0) {
                      //   print("breed deleted");
                      // } else {
                      //   print("breed not deleted");
                      // }
                      await cattleProvider.getAllCattleBreeds();
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
              title: Text("Deleting breed!"),
              content: Text(
                  "All cattle associated with this breed will have no breed attached to them. Please proceed with caution!"));
        });
  }
}
