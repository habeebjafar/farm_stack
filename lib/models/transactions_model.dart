class TransactionsModel{
  int? id;
  String? transactionType;
  String? date;
  String? type;
  String? milkQty;
  String? selectedValueCategory;
  String? categoryId;
  String? otherIncomeExpense;
  String? note;
  String? amount;
  String? receiptNo;
 
  createMap(){
    return{
      if(id != null) "id" : id.toString(),
      "transactionType": this.transactionType,
      "date": this.date,
      "type": this.type,
      "milkQty": this.milkQty,
      "selectedValueCategory": this.selectedValueCategory,
      "otherIncomeExpense": this.otherIncomeExpense,
      "categoryId": this.categoryId,
      "note": this.note,
      "amount": this.amount,
      "receiptNo": this.receiptNo
      
    };
  }


}