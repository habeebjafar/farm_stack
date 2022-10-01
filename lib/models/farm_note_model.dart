class FarmNoteModel{
  int? id;
  String? title;
  String? message;
  String? date;

  createMap(){
    return{
       "id" : this.id,
      "title": this.title,
      "message": this.message,
      "date": this.date
      
    };
  }
}