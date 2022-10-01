import 'package:farmapp/ad_helper.dart';
import 'package:farmapp/models/expense_category_model.dart';
import 'package:farmapp/pages/expense_category_search_page.dart';
import 'package:farmapp/provider/transactions_provider.dart';
import 'package:farmapp/services/expense_category_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseCategoryPage extends StatefulWidget {
  @override
  _ExpenseCategoryPageState createState() => _ExpenseCategoryPageState();
}

class _ExpenseCategoryPageState extends State<ExpenseCategoryPage> {
 

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
    // _getAllIncomeCategory();
    Provider.of<TransactionsProvider>(context, listen: false).getAllExpenseCategory();
     _loadInterAds();
  }

    @override
  void dispose(){
    
     _incomeCategoryName.dispose();
   
     _interstitialAd?.dispose();
    super.dispose();
    
  }

  _editCategoryDialog(BuildContext context, {int? id}) {
    var expenseProvider =
        Provider.of<TransactionsProvider>(context, listen: false);
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
                  ExpenseCategoryService expenseCategoryService =
                      ExpenseCategoryService();
                  var model = ExpenseCategoryModel();
                  model.expenseCategory = _incomeCategoryName.text;
                  var response;
                  if (id != null) {
                    model.id = id;
                    response =
                        await expenseCategoryService.updateExpensiveCategory(model);
                        await expenseProvider.updateExpenseSingleField("expenseCategoryId", "selectedValueExpenseCategory", _incomeCategoryName.text, id);
                  } else {
                    response =
                        await expenseCategoryService.saveExpenseCategory(model);
                        
                  }

                  if (response > 0) {
                    await expenseProvider.getAllExpenseCategory();
                    expenseProvider.selectedValueExpenseCategory =
                          expenseProvider.expenseCategoryNameList.isNotEmpty
                              ? expenseProvider.expenseCategoryNameList.first
                                  .toString()
                              : "";
                    
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
            title: Text("New Expense Category"),
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
                        labelText: "Enter expense category ...",
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
        title: Text("Expense Categories"),
        actions: [
          IconButton(onPressed: () {
             Navigator.push(
              context, MaterialPageRoute(builder: (context) => ExpenseCategorySearchPage()));
          }, 
          icon: Icon(Icons.search)),
          //IconButton(onPressed: () {}, icon: Icon(Icons.filter_list)),
        ],
      ),
      body: Consumer<TransactionsProvider>(
          builder: (_, expenseProvider, __) => expenseProvider.expenseCategoryList.length == 0 ?Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("No expense categories have recorded yet!",
            style: TextStyle(
              fontSize: 18,
              color: Colors.orange
            ),),
          )
        ) :  ListView.builder(
              itemCount: expenseProvider.expenseCategoryList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${expenseProvider.expenseCategoryList[index].expenseCategory}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              popupMenuWidget(
                                  expenseProvider.expenseCategoryList[index].id,
                                  expenseProvider.expenseCategoryList[index].expenseCategory)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })),
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
    var expenseProvider =
        Provider.of<TransactionsProvider>(context, listen: false);
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

                    // ExpenseCategoryService service = ExpenseCategoryService();
                    // var response = await service.deleteExpensiveCategoryById(id);

                    await expenseProvider.deleteExpenseById(id);

                    
                      await expenseProvider.getAllExpenseCategory();
                      
                      expenseProvider.selectedValueExpenseCategory =
                          expenseProvider.expenseCategoryNameList.isNotEmpty
                              ? expenseProvider.expenseCategoryNameList.first
                                  .toString()
                              : "";
                   

                    Navigator.pop(context);
                  },
                  child: Text(
                    "DELETE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              title: Text("Deleting category!"),
              content: Text(
                  "All expenses attached to this category will be deleted as well. Please proceed with caution!"));
        });
  }
}
