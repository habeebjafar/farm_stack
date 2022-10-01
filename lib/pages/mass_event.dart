import 'package:farmapp/ad_helper.dart';
import 'package:farmapp/pages/mass_event_form.dart';
import 'package:farmapp/provider/events_provider.dart';
import 'package:farmapp/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MassEvent extends StatefulWidget {
  @override
  _MassEventState createState() => _MassEventState();
}

class _MassEventState extends State<MassEvent> {

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



  var eventProvider;

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

    eventProvider.getAllMassEventRecord(getAll: "All");
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
          future: eventProvider.getAllMassEventRecord(getAll: "All"),
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
              // if (eventProvider.massEventsList.length == 0) {
              //   return Container(
              //     child: Text("No data"),
              //   );
              // }

              return Consumer<EventsProvider>(
                builder: (_, eventProvider, __) =>  eventProvider.massEventsList.length == 0 ? Center(
          child: Text("No event recorded yet!",
          style: TextStyle(
            fontSize: 18,
            color: Colors.orange
          ),)
        ) : ListView.builder(
                    padding: EdgeInsets.only(bottom: 70),
                    itemCount: eventProvider.massEventsList.length + (_ad != null ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                       final newIndex = _getDestinationItemIndex(index);
                      String med = eventProvider.massEventsList[newIndex].eventType.toString();
                      var date = DateFormat('MMMM dd, yyyy').format(DateTime.parse(
                    "${eventProvider.massEventsList[newIndex].eventDate.toString()}"));

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
                                            "${med == 'Other' ? eventProvider.massEventsList[newIndex].nameOfMedicine : eventProvider.massEventsList[newIndex].eventType}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                       popupMenuWidget(newIndex, eventProvider.massEventsList[newIndex].id),
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
                                      "$date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
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
                                            "${eventProvider.massEventsList[newIndex].nameOfMedicine}",
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
                                        "${eventProvider.massEventsList[newIndex].eventNotes}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Theme.of(context).primaryColor,
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
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MassEventForm()));
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
                "ADD EVENT",
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
                      builder: (context) => MassEventForm(index: index,)));
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
                    
                    EventService service = EventService();
                    var response = await service.deleteEventById(id);

                    if (response > 0) {
                      print("successfully deleted");
                      await Provider.of<EventsProvider>(context, listen: false)
                          .getAllMassEventRecord(getAll: "All");
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
                  "This mass event will be completely deleted. Click delete to continue."));
        });
  }

}
