import 'package:farmapp/pages/cattle_details_page.dart';
import 'package:farmapp/provider/cattle_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CattleDetailsGeneral extends StatefulWidget {
  //final List<CattleModel> _list;
  final int index;

  CattleDetailsGeneral(this.index);

  @override
  _CattleDetailsGeneralState createState() => _CattleDetailsGeneralState();
}

class _CattleDetailsGeneralState extends State<CattleDetailsGeneral> {
  var provider;

  @override
  void initState() {
    //provider = Provider.of<CattleProvider>(context, listen: false);
    super.initState();
    //print(calculateAge("2019-11-21"));

    String _data = '16-04-2020';

    DateTime _dateTime = DateTime(
      int.parse(_data.substring(6)),
      int.parse(_data.substring(3, 5)),
      int.parse(_data.substring(0, 2)),
    );
    int yeardiff = DateTime.fromMillisecondsSinceEpoch(
                DateTime.now().difference(_dateTime).inMilliseconds)
            .year -
        1970;

    int monthdiff = DateTime.fromMillisecondsSinceEpoch(
                DateTime.now().difference(_dateTime).inMilliseconds)
            .month -
        12;
    print("printing another age $yeardiff, $monthdiff");
  }

  String calculateAge(String birthDateString) {
    String datePattern = 'MMMM dd, yyyy';

    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);
    DateTime today = DateTime.now();

    int yearDiff = today.year - birthDate.year;
    int monthDiff = today.month - birthDate.month;
    int dayDiff = today.day - birthDate.day;
    print(dayDiff);
    print(monthDiff);
    print(yearDiff);
    //setState(() {
    if (monthDiff < 0) {
      yearDiff--;
      monthDiff = monthDiff + 12;
      if (dayDiff <= 0) {
        monthDiff--;
        dayDiff = dayDiff + 30;
      }
    } else if (monthDiff == 0) {
      if (dayDiff <= 0) {
        yearDiff--;
        monthDiff = 11;
        dayDiff = dayDiff + 30;
      } else {
        monthDiff = 0;
      }
    }
    // });

    return "$yearDiff yrs, $monthDiff mons, $dayDiff days";
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CattleProvider>(context, listen: false);

    return Scaffold(
      body: FutureBuilder(
          future: provider.getCattleById(this.widget.index,
              offspringSearch: provider.singleCattle[0]['cattleTagNo']),
          builder: (BuildContext context, snapShot) {
            var dob = DateFormat('MMMM dd, yyyy').format(
                DateTime.parse("${provider.singleCattle[0]['cattleDOB']}"));
            //String age = calculateAge(dob);
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Consumer<CattleProvider>(
                  builder: (_, newPro, __) => Column(
                    children: [
                      newPro.singleCattle[0]['cattleArchive'] ==
                              "Unarchive Cattle"
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 16, 8, 16),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(2, 7, 0, 7),
                                        width: double.infinity,
                                        color: Theme.of(context).primaryColor,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Archive details",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
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
                                            width: 105,
                                          ),
                                          Text(
                                            "${newPro.singleCattle[0]['cattleArchiveDate']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 16),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Reason:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            width: 80,
                                          ),
                                          Text(
                                            "${newPro.singleCattle[0]['cattleArchiveReason']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 16),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Notes:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            width: 91,
                                          ),
                                          Text(
                                            "${newPro.singleCattle[0]['cattleArchiveNotes']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 16),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Padding(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "General details",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
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
                                      width: 80,
                                    ),
                                    Text(
                                      "${newPro.singleCattle[0]['cattleTagNo']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Name:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 90,
                                    ),
                                    Text(
                                      "${newPro.singleCattle[0]['cattleName']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "D.O.B:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 91,
                                    ),
                                    Text(
                                      "$dob",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Age:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 103,
                                    ),
                                    Text(
                                      "${calculateAge(dob)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Gender:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 77,
                                    ),
                                    Text(
                                      "${newPro.singleCattle[0]['cattleGender']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Weight:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 80,
                                    ),
                                    Text(
                                      "${newPro.singleCattle[0]['cattleWeight']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Stage:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 85,
                                    ),
                                    Text(
                                      "${newPro.singleCattle[0]['cattleStage']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                newPro.singleCattle[0]['cattleGender']
                                            .toString() ==
                                        "Female"
                                    ? Row(
                                        children: [
                                          Text(
                                            "Status:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            width: 80,
                                          ),
                                          Text(
                                            "${newPro.singleCattle[0]['cattleStatus']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 16),
                                          )
                                        ],
                                      )
                                    : Container(),
                                newPro.singleCattle[0]['cattleGender']
                                            .toString() ==
                                        "Female"
                                    ? SizedBox(
                                        height: 15,
                                      )
                                    : Container(),
                                Row(
                                  children: [
                                    Text(
                                      "Breed:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 84,
                                    ),
                                    Text(
                                      "${newPro.singleCattle[0]['cattleBreed']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Joined On:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text(
                                      "${newPro.singleCattle[0]['cattleDOE']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Source:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 76,
                                    ),
                                    Text(
                                      "${newPro.singleCattle[0]['cattleObtainMethod']! == 'Other' ? newPro.singleCattle[0]['cattleOtherSource']! : newPro.singleCattle[0]['cattleObtainMethod']!}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Mother:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 76,
                                    ),
                                    Text(
                                      "${newPro.singleCattle[0]['cattleMotherTagNo']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Father:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 80,
                                    ),
                                    Text(
                                      "${newPro.singleCattle[0]['cattleFatherTagNo']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Notes:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 80,
                                    ),
                                    Text(
                                      "${newPro.singleCattle[0]['cattleNotes'] == null ? '' : newPro.singleCattle[0]['cattleNotes']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Cattle's offspring",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                newPro.offspringSearchList.length == 0
                                    ? Center(
                                        child: Text(
                                        "Cattle has no offspring linked yet!",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.orange),
                                      ))
                                    : ListView.builder(
                                        itemCount:
                                            newPro.offspringSearchList.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return Card(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${newPro.offspringSearchList[index].cattleTagNo}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      "${newPro.offspringSearchList[index].cattleName}",
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 105,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CattleDetailsPage(newPro
                                                                      .offspringSearchList[
                                                                          index]
                                                                      .id!)));
                                                    },
                                                    icon: Icon(
                                                      Icons.search,
                                                      color: Colors.orange,
                                                    ))
                                              ],
                                            ),
                                          );
                                        })
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );

            
            }
          }),
    );
  }
}
