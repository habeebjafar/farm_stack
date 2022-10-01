import 'package:farmapp/models/cattle_breed_model.dart';
import 'package:farmapp/models/cattle_model.dart';
import 'package:farmapp/repository/repository.dart';
import 'package:farmapp/services/cattle_breed_service.dart';
import 'package:farmapp/services/cattle_service.dart';
import 'package:flutter/foundation.dart';

class CattleProvider with ChangeNotifier {
  Repository _repository = Repository();

  CattleService _cattleService = CattleService();
  CattleBreedService _cattleBreedService = CattleBreedService();
  List<CattleBreedModel> list = [];
  List<CattleModel> cattleList = [];
   List<CattleModel> archivedcattleList = [];
  List<CattleModel> lostCattleList = [];
  List<CattleModel> deadCattleList = [];
  List<CattleModel> soldCattleList = [];
  List<CattleModel> loanedCattleList = [];
  List<CattleModel> giftedCattleList = [];
  List<CattleModel> otherCattleList = [];
  List<CattleModel> offspringSearchList = [];


  


  bool isSave = false;

  saveCattle(
      cattleBreed,
      cattleBreedId,
      cattleName,
      cattleGender,
      cattleTagNo,
      cattleStage,
      cattleWeight,
      cattleDOB,
      cattleDOE,
      cattleObtainMethod,
      cattleOtherSource,
      cattleMotherTagNo,
      cattleFatherTagNo,
      cattleNote,
      cattleStatus,
      cattleArchive,
      cattleArchiveDate,
      cattleArchiveReason,
      cattleArchiveOtherReason,
      cattleArchiveNotes,
      int id,
      int index) async {

        String? cattleStageImg;
                     

                      if(cattleStage == "Bull"){
                        cattleStageImg = "assets/images/bull.png";
                      } else if(cattleStage == "Cow"){
                        cattleStageImg = "assets/images/cowstage.png";
                      }  else if(cattleStage == "Calf"){
                        cattleStageImg = "assets/images/calf.png";
                      } else{
                        cattleStageImg = "assets/images/cownew.png";

                      }
    var model = CattleModel();
    model.cattleBreed = cattleBreed.toString();
    model.cattleBreedId = cattleBreedId;
    model.cattleName = cattleName;
    model.cattleTagNo = cattleTagNo;
    model.cattleGender = cattleGender;
    model.cattleStage = cattleStage;
    model.cattleStageImg = cattleStageImg;
    model.cattleWeight = cattleWeight;
    model.cattleDOB = cattleDOB;
    model.cattleDOE = cattleDOE;
    model.cattleObtainMethod = cattleObtainMethod;
    model.cattleOtherSource = cattleOtherSource;
    model.cattleMotherTagNo = cattleMotherTagNo;
    model.cattleFatherTagNo = cattleFatherTagNo;
    model.cattleNote = cattleNote;
    model.cattleStatus = model.cattleGender == "Female" ? "Non Lactating" : "";

    model.cattleArchive = "All Active";
    model.cattleArchiveDate = "";
    model.cattleArchiveReason = "";
    model.cattleArchiveOtherReason = "";
    model.cattleArchiveNotes = "";

    var response;

    if (index != -1) {
      if (cattleArchive == "Archive Cattle") {
        model.cattleArchiveDate = cattleArchiveDate;
        model.cattleArchiveReason = cattleArchiveReason;
        model.cattleArchiveOtherReason = cattleArchiveOtherReason;
        model.cattleArchiveNotes = cattleArchiveNotes;
        model.cattleArchive = "Unarchive Cattle";
      }
      model.cattleStatus = cattleStatus;
      model.id = id;
      response = await _cattleService.updateCattle(model);
    } else {
      response = await _cattleService.saveCattle(model);
    }

    if (response > 0) {
      isSave = true;
    } else {
      isSave = false;
    }

    notifyListeners();
  }

  Future<List<CattleModel>> getAllCattles(String? searchtext, {String? offspringSearch, DateTime? dateSearch, DateTime? dateSearchTwo}) async {
    var response = await _cattleService.getAllTCattles();
    print(response);

    cattleList.clear();
    archivedcattleList.clear();
    lostCattleList.clear();
    deadCattleList.clear();
    soldCattleList.clear();
    loanedCattleList.clear();
    giftedCattleList.clear();
    otherCattleList.clear();
    offspringSearchList.clear();

    response.forEach((data) {
      var model = CattleModel();
      model.id = data['id'];
      model.cattleName = data['cattleName'];
      model.cattleTagNo = data['cattleTagNo'];
      model.cattleGender = data['cattleGender'];
      model.cattleStage = data['cattleStage'];
      model.cattleStageImg = data['cattleStageImg'];
      model.cattleBreed = data['cattleBreed'];
      model.cattleBreedId = data['cattleBreedId'];
      model.cattleWeight = data['cattleWeight'];
      model.cattleDOB = data['cattleDOB'];
      model.cattleDOE = data['cattleDOE'];
      model.cattleObtainMethod = data['cattleObtainMethod'];
      model.cattleOtherSource = data['cattleOtherSource'];
      model.cattleMotherTagNo = data['cattleMotherTagNo'];
      model.cattleFatherTagNo = data['cattleFatherTagNo'];
      model.cattleNote = data['cattleNotes'];
      model.cattleStatus = data['cattleStatus'];
      model.cattleArchive = data['cattleArchive'];
      model.cattleArchiveReason = data['cattleArchiveReason'];
      model.cattleArchiveDate = data['cattleArchiveDate'];
      model.cattleArchiveOtherReason = data['cattleArchiveOtherReason'];
      model.cattleArchiveNotes = data['cattleArchiveNotes'];

      if (searchtext == model.cattleStage! &&
          model.cattleArchive! == "All Active") {
        // _stageSearchList.add(model);
        cattleList.add(model);
      } else if (searchtext == model.cattleStatus! &&
          model.cattleArchive! == "All Active") {
        // _stageSearchList.add(model);
        cattleList.add(model);
      } else if (searchtext == model.cattleArchive!) {
        cattleList.add(model);
      }

  

     if (model.cattleArchive == "Unarchive Cattle") {
  if (dateSearch != null && dateSearchTwo == null) {
     if (dateSearch.compareTo(DateTime.parse(model.cattleArchiveDate!)) <= 0) {
  
       _cattleDateIf(model);
  
    }
      
     }
   
  
   else if (dateSearchTwo != null && dateSearch == null) {
     DateTime date = new  DateTime.now();
     DateTime currentDate = new DateTime(date.year, date.month, 01);
     if (dateSearchTwo.compareTo(DateTime.parse(model.cattleArchiveDate!)) <= 0 && currentDate.compareTo(DateTime.parse(model.cattleArchiveDate!)) > 0 ) {
  
         _cattleDateIf(model);
  
    }
      
     }
   
  
   else if (dateSearch != null && dateSearchTwo != null) {
     if (dateSearch.compareTo(DateTime.parse(model.cattleArchiveDate!)) <= 0 &&
         dateSearchTwo.compareTo(DateTime.parse(model.cattleArchiveDate!)) >= 0) {
  
             _cattleDateIf(model);
    }
      
     }
}

      if (searchtext == "All") {
        cattleList.add(model);
      }
      if(offspringSearch == model.cattleFatherTagNo || offspringSearch == model.cattleMotherTagNo){
        offspringSearchList.add(model);

      }
    });

    notifyListeners();

    return cattleList;
  }



  updateCattleSingleField(conditionalColumn, colunmName, colunmValue, id) async{
   await _cattleService.updateCattleSingleField(conditionalColumn, colunmName, colunmValue, id);
    notifyListeners();
  }

  var singleCattle;

  getCattleById(id, {offspringSearch}) async {
    var response = await _cattleService.getCattleById(id);
    var responseSearch = await _cattleService.getAllTCattles();
    singleCattle = response;
    offspringSearchList.clear();


        responseSearch.forEach((data) {
      var model = CattleModel();
      model.id = data['id'];
      model.cattleName = data['cattleName'];
      model.cattleTagNo = data['cattleTagNo'];
      model.cattleGender = data['cattleGender'];
      model.cattleStage = data['cattleStage'];
      model.cattleBreed = data['cattleBreed'];
      model.cattleBreedId = data['cattleBreedId'];
      model.cattleWeight = data['cattleWeight'];
      model.cattleDOB = data['cattleDOB'];
      model.cattleDOE = data['cattleDOE'];
      model.cattleObtainMethod = data['cattleObtainMethod'];
      model.cattleOtherSource = data['cattleOtherSource'];
      model.cattleMotherTagNo = data['cattleMotherTagNo'];
      model.cattleFatherTagNo = data['cattleFatherTagNo'];
      model.cattleNote = data['cattleNotes'];
      model.cattleStatus = data['cattleStatus'];
      model.cattleArchive = data['cattleArchive'];
      model.cattleArchiveReason = data['cattleArchiveReason'];
      model.cattleArchiveDate = data['cattleArchiveDate'];
      model.cattleArchiveOtherReason = data['cattleArchiveOtherReason'];
      model.cattleArchiveNotes = data['cattleArchiveNotes'];

      if(offspringSearch == model.cattleFatherTagNo || offspringSearch == model.cattleMotherTagNo){
        offspringSearchList.add(model);

      }
    });

    
    notifyListeners();
    return response;
  }

  getAllCattleBreeds() async {
    var response = await _cattleBreedService.getAllTCattleBreeds();
    print(response);

    list.clear();

    response.forEach((data) {
      var model = CattleBreedModel();
      model.id = data['id'];
      model.cattleBreed = data['cattleBreed'];
      list.add(model);
     
    });

     notifyListeners();
  }

  // getCattlesBreedNo(String? breedName) async {
  //   var response = await _cattleService.getAllTCattles();
  //   breedSearchList.clear();
  //   response.forEach((data) {
  //     var model = CattleModel();
  //     model.cattleBreed = data['cattleBreed'];
  //     if (model.cattleBreed.toString() == breedName) {
  //       breedSearchList.add(model);

  //     }

  //      notifyListeners();
  //   });

  // }

//   getCattlesBreedNo2() async {
//     var response = await _cattleService.getAllTCattles();
//     response.forEach((data) {
//       var model = CattleModel();
//       model.cattleBreed = data['cattleBreed'];
//       breedSearchList.add(model);
//     });

// //notifyListeners();

//     return breedSearchList;
//   }

deleteCattleById(cattleId) async{

    var response = await _cattleService.deleteTodoById(cattleId);

    if(response > 0){

     

       var cattleIdResponse =  await _repository.deleteByColunmName("eventIndividual", "cattleId", cattleId);
           if(cattleIdResponse > 0){
        print("Cattle event deleted");

      } else { print("No Cattle event deleted"); }
      
      var cowTagResponse = await _repository.deleteByColunmName("milk", "cattleId", cattleId);
      if(cowTagResponse > 0){
        print("Cow milk deleted");

      } else { print(" No Cow milk deleted"); }

     


    }else {
      print("No Cattle deleted");
    }

    notifyListeners();

}


void _cattleDateIf(model){
  archivedcattleList.add(model);
   if (model.cattleArchiveReason == "Lost") {
        lostCattleList.add(model);
      } else if (model.cattleArchiveReason == "Dead") {
        deadCattleList.add(model);
      } else if (model.cattleArchiveReason == "Sold") {
        soldCattleList.add(model);
      } else if (model.cattleArchiveReason == "Loaned") {
        loanedCattleList.add(model);
      } else if (model.cattleArchiveReason == "Gifted") {
        giftedCattleList.add(model);
      } else if (model.cattleArchiveReason == "Other") {
        otherCattleList.add(model);
      }
}

}
