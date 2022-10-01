import 'package:farmapp/ad_helper.dart';
import 'package:farmapp/provider/events_provider.dart';
import 'package:farmapp/services/event_individual_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cattle_details_page.dart';
import 'individual_event_form.dart';

class IndividualEvent extends StatefulWidget {
  

  @override
  _IndividualEventState createState() => _IndividualEventState();
}

class _IndividualEventState extends State<IndividualEvent> {


  var eventProvider;

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

    eventProvider = Provider.of<EventsProvider>(context, listen: false);

    eventProvider.getAllIndividualEventRecord(searchEventType: "All");

  //  _getAllIndividualEventRecord();
    //_searchResearch();
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
       body: FutureBuilder(
          future: eventProvider.getAllIndividualEventRecord(searchEventType: "All"),
          builder: (BuildContext context, snapShot) {
            // var dob = DateFormat('yyyy MMM, dd').format(
            //     DateTime.parse("${provider.singleCattle[0]['cattleDOB']}"));
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              // if (eventProvider.individualEventsList.length == 0) {
              //   return Container(
              //     child: Text("No data"),
              //   );
              // }

              return Consumer<EventsProvider>(
                builder: (_, eventProvider, __) =>  eventProvider.individualEventsList.length == 0 ? Center(
          child: Text("No event recorded yet!",
          style: TextStyle(
            fontSize: 18,
            color: Colors.orange
          ),)
        ) : ListView.builder(
                    padding: EdgeInsets.only(bottom: 70),
                    itemCount: eventProvider.individualEventsList.length + (_ad != null ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                     
                      final newIndex = _getDestinationItemIndex(index);
                      String med = eventProvider
                          .individualEventsList[newIndex].eventType
                          .toString();

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
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(2, 7, 0, 7),
                                  width: double.infinity,
                                  color: Theme.of(context).primaryColor,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.multitrack_audio_outlined,
                                            color: Colors.white70,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "${med == 'Other' ? eventProvider.individualEventsList[newIndex].nameOfMedicine : eventProvider.individualEventsList[newIndex].eventType}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      popupMenuWidget(newIndex, eventProvider.individualEventsList[newIndex].id ,eventProvider.individualEventsList[newIndex].cattleId)
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Date:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 80,
                                    ),
                                    Text(
                                      "${eventProvider.individualEventsList[newIndex].eventDate}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Tag No:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 60,
                                    ),
                                    Text(
                                      "${eventProvider.individualEventsList[newIndex].cattleTagNo}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    ),
                                     SizedBox(
                                      width: 110,
                                    ), 
                                    IconButton(
                                      onPressed: (){
                                         Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CattleDetailsPage(int.parse(eventProvider.individualEventsList[newIndex].cattleId!))));
                                      }, 
                                      icon: Icon(Icons.search, color: Colors.orange,)
                                      )
                                  ],
                                ),
                                med == "Vacination/Injection" ||
                                        med == "Deworming" ||
                                        med == "Treatment/Medication"
                                    ? SizedBox(
                                        height: 15,
                                      )
                                    : Container(),
                                med == "Vacination/Injection" ||
                                        med == "Deworming" ||
                                        med == "Treatment/Medication"
                                    ? Row(
                                        children: [
                                          Text(
                                            "Medicine:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            width: 45,
                                          ),
                                          Text(
                                            "${eventProvider.individualEventsList[newIndex].nameOfMedicine}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 16),
                                          )
                                        ],
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Notes:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 70,
                                    ),
                                    Container(
                                      width: 200,
                                      child: Text(
                                        "${eventProvider.individualEventsList[newIndex].eventNotes}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                      );
                            }
                    }),
              );
            }
          }),

    );
  }

    Widget popupMenuWidget(index, id, cattleId) {
    var selectedValue;
    return PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        onSelected: (value) {
          setState(() {
            selectedValue = value as String;

            if (selectedValue == "Edit Event") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IndividualEventForm(
                          index: cattleId, eventIndex: index)));
            } else if (selectedValue == "Delete") {
              _deleteEventDialog(id);
            }
          });
        },
        itemBuilder: (_) => [
              PopupMenuItem(value: "Edit Event", child: Text("Edit Event")),
              PopupMenuItem(value: "Delete", child: Text("Delete")),
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
                    print("checking this now $id");
                    
                    EventIndividualService service = EventIndividualService();
                    var response = await service.deleteEventById(id);

                    if (response > 0) {
                      print("successfully deleted");
                      await Provider.of<EventsProvider>(context, listen: false)
                          .getAllIndividualEventRecord(searchEventType: "All");
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
              title: Text("Deleting event!"),
              content: Text(
                  "Deleting this event will not revert any changes to the cattle's stage and status. Click delete to continue."));
        });
  }

}