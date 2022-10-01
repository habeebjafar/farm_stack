class EventModel{
  int? id;
  String? eventDate;
  String? numOfCattles;
  String? eventType;
  String? nameOfMedicine;
  String? eventNotes;
 
  createMap(){
    return{
      if(id != null) "id" : id.toString(),
      "eventDate": this.eventDate,
      "numOfCattles": this.numOfCattles,
      "eventType": this.eventType,
      "nameOfMedicine": this.nameOfMedicine,
      "eventNotes": this.eventNotes,
      
    };
  }
}

