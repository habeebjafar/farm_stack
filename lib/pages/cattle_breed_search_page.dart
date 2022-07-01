import 'package:farmapp/models/cattle_breed_model.dart';
import 'package:farmapp/provider/cattle_provider.dart';
import 'package:farmapp/services/cattle_breed_service.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CattleBreedSearchPage extends StatefulWidget {
  @override
  _CattleBreedSearchPageState createState() => _CattleBreedSearchPageState();
}

class _CattleBreedSearchPageState extends State<CattleBreedSearchPage> {
  TextEditingController _incomeCategoryName = TextEditingController();
  CattleBreedService _service = CattleBreedService();

  @override
  void initState() {
    super.initState();
    Provider.of<CattleProvider>(context, listen: false).getAllCattleBreeds();
    _getCattleBreed();
  }

  
List<CattleBreedModel> duplicateItems  = [];

  List<CattleBreedModel> items   = [];

  bool? noDataFound;
  
    void filterSearchResults(String query) {
    List<CattleBreedModel> dummySearchList = [];
    dummySearchList.addAll(duplicateItems);
    if(query.isNotEmpty) {
      List<CattleBreedModel> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.cattleBreed.toString().toLowerCase().contains(query) ) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
        if(items.length == 0 ){
          noDataFound = true;
        }else{
          noDataFound = false;
        }
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
        if(items.length == 0 ){
          noDataFound = true;
        }else{
          noDataFound = false;
        }
      });
    }

  }



  _getCattleBreed() async{
    var response = await _service.getAllTCattleBreeds();

    response.forEach((data){
     
     setState(() {
        var model = CattleBreedModel();
         model.id = data['id'];
      model.cattleBreed = data['cattleBreed'];

        duplicateItems.add(model);

     });


    });
     items.addAll(duplicateItems);
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
         appBar: AppBar(title:  TextField(
        onChanged: (value) {
          filterSearchResults(value);
        },
        cursorColor: Colors.orange,
        //mcursorHeight: 30,
        autofocus: true,
        
        style: TextStyle(
          color: Colors.white
        ),
        
        
        
        decoration: InputDecoration(
            //labelText: "Search",
          
            hintText: "Search...",
            border: InputBorder.none,

            hintStyle: TextStyle(
              color: Colors.white60
            ),
             

                ),
      ),
            ),
      body: noDataFound == true ? Center(
          child: Text("No Data matches your search!",
          style: TextStyle(
            fontSize: 18,
            color: Colors.orange
          ),)
        ) : ListView.builder(
              itemCount: items.length,
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
                                "${items[index].cattleBreed}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              popupMenuWidget(items[index].id,
                                  items[index].cattleBreed)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              ),
      floatingActionButton: GestureDetector(
        onTap: () {
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
              title: Text("Deleting Cattle!"),
              content: Text(
                  "This cattle will be deleted completely from the app. This will also permanently delete all records such milk, events, expenses and revenue attached to this cattle!"));
        });
  }
}
