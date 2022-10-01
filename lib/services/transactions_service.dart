import 'package:farmapp/models/transactions_model.dart';
import 'package:farmapp/repository/repository.dart';


class TransactionsService {
  late Repository _repository;

  TransactionsService() {
    _repository = Repository();
  }

  saveTransactions(TransactionsModel transactions) async {
    return await _repository.saveItem("transactions", transactions.createMap());
   
  }

  getAllTransactions() async {
    return await _repository.getAllItem("transactions");
    
  }

  

  getTransactionsById(transactionsId) async {
    return await _repository.getItemById("transactions", transactionsId);
  }

  updateTransactions(TransactionsModel transactionsId) async {
    return await _repository.updateItem("transactions", transactionsId.createMap());
    
  }

   updateTransactionsSingleField(conditionalColumn, colunmName, colunmValue, id) async{

    return await _repository.updateSingleField("transactions", conditionalColumn, colunmName, colunmValue, id);
  }

  deleteTransactionsById(transactionsId) async {
    return await _repository.deleteItemById("transactions", transactionsId);
  }

}
