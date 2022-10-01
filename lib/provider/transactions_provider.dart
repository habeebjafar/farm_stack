import 'package:farmapp/models/expense_category_model.dart';
import 'package:farmapp/models/expense_model.dart';
import 'package:farmapp/models/income_category_model.dart';
import 'package:farmapp/models/income_model.dart';
import 'package:farmapp/models/transactions_model.dart';
import 'package:farmapp/repository/repository.dart';
import 'package:farmapp/services/expense_category_service.dart';
import 'package:farmapp/services/expense_service.dart';
import 'package:farmapp/services/income_category_service.dart';
import 'package:farmapp/services/income_service.dart';
import 'package:farmapp/services/transactions_service.dart';
import 'package:flutter/cupertino.dart';

class TransactionsProvider with ChangeNotifier {
  List<TransactionsModel> transactionList = [];
  Repository _repository = Repository();
  IncomeService _incomeService = IncomeService();
  TransactionsService _transService = TransactionsService();
  List<IncomeModel> incomeList = [];
  List<TransactionsModel> incomeTransList = [];
  List<TransactionsModel> expenseTransList = [];

  IncomeCategoryService _incomeCategoryService = IncomeCategoryService();
  List<IncomeCategoryModel> incomeCategoryList = [];
  List<String> incomeCategoryNameList = [];
  List<String> incomeCategoryIdList = [];

  ExpenseService _expenseService = ExpenseService();
  List<ExpenseModel> expenseList = [];

  ExpenseCategoryService _expenseCategoryService = ExpenseCategoryService();
  List<ExpenseCategoryModel> expenseCategoryList = [];
  List<String> expenseCategoryNameList = [];
  List<String> expenseCategoryIdList = [];

  String selectedValueIncomeCategory = "";

  String selectedValueExpenseCategory = "";

  double totalIncome = 0.0;
  double totalExpense = 0.0;

  List<TransactionsModel> incomeTransListSearch = [];
  double totalIncomeSearch = 0.0;

  List<TransactionsModel> expenseTransListSearch = [];
  double totalExpenseSearch = 0.0;



  saveIncome(incomeDate, incomeNote, incomeType, milkQty, receiptNum,
      amountEarned, selectedValueIncomeCategory, incomeCategoryId, otherSource,
      {updateId}) async {
    var transModel = IncomeModel();

    transModel.incomeDate = incomeDate;
    transModel.incomeNotes = incomeNote;
    transModel.incomeType = incomeType;
    transModel.milkQty = milkQty;
    transModel.receiptNo = receiptNum;
    transModel.amountEarned = amountEarned;
    transModel.selectedValueIncomeCategory = selectedValueIncomeCategory;
    transModel.incomeCategoryId = incomeCategoryId;
    transModel.otherSource = otherSource;

    var response;
    if (updateId != null) {
      transModel.id = updateId;
      response = await _incomeService.updateIncome(transModel);
    } else {
      response = await _incomeService.saveIncome(transModel);
    }

    if (response > 0) {
      print("added successfully $response");
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (_) => MassEvent()));
    } else {
      print("no value added");
    }
    notifyListeners();
  }

  saveTrans(transactionType, date, note, type, milkQty, receiptNum, amount,
      selectedValueCategory, categoryId, otherIncomeExpense,
      {updateId}) async {
    var transModel = TransactionsModel();

    transModel.transactionType = transactionType;
    transModel.date = date;
    transModel.note = note;
    transModel.type = type;
    transModel.milkQty = milkQty;
    transModel.receiptNo = receiptNum;
    transModel.amount = amount;
    transModel.selectedValueCategory = selectedValueCategory;
    transModel.categoryId = categoryId;
    transModel.otherIncomeExpense = otherIncomeExpense;

    var response;
    if (updateId != null) {
      transModel.id = updateId;
      response = await _transService.updateTransactions(transModel);
    } else {
      response = await _transService.saveTransactions(transModel);
    }

    if (response > 0) {
      print("added successfully $response");
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (_) => MassEvent()));
    } else {
      print("no value added");
    }
    notifyListeners();
  }

  getAllIncomeRecord() async {
    var response = await _incomeService.getAllIncomeRecord();
    print(response);
    incomeList.clear();

    response.forEach((data) {
      var model = IncomeModel();

      model.id = data['id'];
      model.incomeDate = data['incomeDate'];
      model.incomeType = data['incomeType'];
      model.milkQty = data['milkQty'];
      model.selectedValueIncomeCategory = data['selectedValueIncomeCategory'];
      model.incomeCategoryId = data['incomeCategoryId'];
      model.otherSource = data['otherSource'];
      model.amountEarned = data['amountEarned'];
      model.receiptNo = data['receiptNo'];
      model.incomeNotes = data['incomeNotes'];

      incomeList.add(model);
    });
    notifyListeners();
  }

  Future<List<IncomeCategoryModel>> getAllIncomeCategory() async {
    var response = await _incomeCategoryService.getAllIncomeCategories();
    print(response);
    incomeCategoryList.clear();
    incomeCategoryIdList.clear();
    incomeCategoryNameList.clear();

    response.forEach((data) {
      var model = IncomeCategoryModel();
      model.id = data['id'];
      model.incomeCategory = data['incomeCategory'];

      incomeCategoryList.add(model);
      incomeCategoryNameList.add(model.incomeCategory!);
      incomeCategoryIdList.add(model.id.toString());
    });

    notifyListeners();

    return incomeCategoryList;
  }

  updateIncomeSingleField(
      conditionalColumn, colunmName, colunmValue, id) async {
    await _incomeService.updateIncomeSingleField(
        conditionalColumn, colunmName, colunmValue, id);
    notifyListeners();
  }

  deleteIncomeCategoryById(incomeCategoryId) async {
    var response =
        await _incomeCategoryService.deleteIncomeCategoryById(incomeCategoryId);

    if (response > 0) {
      print("incomeCategoryId deleted");

      var incomeIdResponse = await _repository.deleteByColunmName(
          "income", "incomeCategoryId", incomeCategoryId);
      if (incomeIdResponse > 0) {
        print("incomeIdResponse event deleted");
      } else {
        print("No incomeIdResponse event deleted");
      }
    } else {
      print("No Income Category deleted");
    }

    notifyListeners();
  }

  saveExpense(expenseDate, expenseNote, expenseType, receiptNum, amountSpent,
      selectedValueExpenseCategory, expenseCategoryId, otherExpense,
      {updateId}) async {
    var expenseModel = ExpenseModel();

    expenseModel.expenseDate = expenseDate;
    expenseModel.expenseNotes = expenseNote;
    expenseModel.expenseType = expenseType;
    expenseModel.receiptNo = receiptNum;
    expenseModel.amountSpent = amountSpent;
    expenseModel.selectedValueExpenseCategory = selectedValueExpenseCategory;
    expenseModel.expenseCategoryId = expenseCategoryId;
    expenseModel.otherExpense = otherExpense;

    var response;
    if (updateId != null) {
      expenseModel.id = updateId;
      response = await _expenseService.updateExpense(expenseModel);
    } else {
      response = await _expenseService.saveIncome(expenseModel);
    }

    if (response > 0) {
      
    } else {
     
    }
    notifyListeners();
  }

  Future<List<TransactionsModel>> getAllTransactionsRecord(
      {DateTime? dateSearch, DateTime? dateSearchTwo}) async {
    var response = await _transService.getAllTransactions();
    // print(response);

    transactionList.clear();
    incomeTransList.clear();
    expenseTransList.clear();
    totalIncome = 0.0;
    totalExpense = 0.0;

    totalIncomeSearch = 0.0;
    incomeTransListSearch.clear();

    totalExpenseSearch = 0.0;
    expenseTransListSearch.clear();

    response.forEach((data) {
      var model = TransactionsModel();

      model.id = data['id'];
      model.transactionType = data['transactionType'];
      model.date = data['date'];
      model.type = data['type'];
      model.milkQty = data['milkQty'];
      model.selectedValueCategory = data['selectedValueCategory'];
      model.categoryId = data['categoryId'];
      model.otherIncomeExpense = data['otherIncomeExpense'];
      model.amount = data['amount'];
      model.receiptNo = data['receiptNo'];
      model.note = data['note'];

      if (model.transactionType == "Income") {

        incomeTransList.add(model);
        totalIncome += double.parse(model.amount.toString());
      }

      if (model.transactionType == "Expense") {
        expenseTransList.add(model);
        totalExpense += double.parse(model.amount.toString());
      }
      transactionList.add(model);

      if (dateSearch != null && dateSearchTwo == null) {
        if (dateSearch.compareTo(DateTime.parse(model.date!)) <= 0) {
          if (model.transactionType == "Income") {
            incomeTransListSearch.add(model);
            totalIncomeSearch += double.parse(model.amount.toString());
          } else {
            expenseTransListSearch.add(model);
            totalExpenseSearch += double.parse(model.amount.toString());
          }
        }
      }

      if (dateSearchTwo != null && dateSearch == null) {
        DateTime date = new  DateTime.now();
        DateTime currentDate = new DateTime(date.year, date.month, 01);
        if (dateSearchTwo.compareTo(DateTime.parse(model.date!)) <= 0 && currentDate.compareTo(DateTime.parse(model.date!)) > 0 ) {
          if (model.transactionType == "Income") {
            incomeTransListSearch.add(model);
            totalIncomeSearch += double.parse(model.amount.toString());
          } else {
            expenseTransListSearch.add(model);
            totalExpenseSearch += double.parse(model.amount.toString());
          }
        }
      }

      if (dateSearch != null && dateSearchTwo != null) {
        if (dateSearch.compareTo(DateTime.parse(model.date!)) <= 0 &&
            dateSearchTwo.compareTo(DateTime.parse(model.date!)) >= 0) {
           if (model.transactionType == "Income") {
            incomeTransListSearch.add(model);
            totalIncomeSearch += double.parse(model.amount.toString());
          } else {
            expenseTransListSearch.add(model);
            totalExpenseSearch += double.parse(model.amount.toString());
          }
        }
      }
    });
    notifyListeners();
    return transactionList;
  }

  getAllExpensesRecord() async {
    var response = await _expenseService.getAllExpenseRecord();
    print(response);
    expenseList.clear();

    response.forEach((data) {
      var model = ExpenseModel();

      model.id = data['id'];
      model.expenseDate = data['expenseDate'];
      model.expenseType = data['expenseType'];
      model.amountSpent = data['amountSpent'];
      model.receiptNo = data['receiptNo'];
      model.expenseNotes = data['expenseNotes'];
      model.selectedValueExpenseCategory = data['selectedValueExpenseCategory'];
      model.expenseCategoryId = data['expenseCategoryId'];
      model.otherExpense = data['otherExpense'];

      expenseList.add(model);
    });
    notifyListeners();
  }

  Future<List<ExpenseCategoryModel>> getAllExpenseCategory() async {
    var response = await _expenseCategoryService.getAllExpenseCategories();
    expenseCategoryList.clear();
    expenseCategoryNameList.clear();
    expenseCategoryIdList.clear();

    response.forEach((data) {
      var model = ExpenseCategoryModel();

      model.id = data['id'];
      model.expenseCategory = data['expenseCategory'];

      expenseCategoryList.add(model);
      expenseCategoryNameList.add(model.expenseCategory!);
      expenseCategoryIdList.add(model.id.toString());
    });

    notifyListeners();

    return expenseCategoryList;
  }

  updateExpenseSingleField(
      conditionalColumn, colunmName, colunmValue, id) async {
    await _expenseService.updateExpenseSingleField(
        conditionalColumn, colunmName, colunmValue, id);
    notifyListeners();
  }

  deleteExpenseById(expenseCategoryId) async {
    var response = await _expenseCategoryService
        .deleteExpensiveCategoryById(expenseCategoryId);

    if (response > 0) {
      print("expenseCategoryId deleted");

      var expenseCategoryResponse = await _repository.deleteByColunmName(
          "expenses", "expenseCategoryId", expenseCategoryId);
      if (expenseCategoryResponse > 0) {
        print("expenseCategoryId event deleted");
      } else {
        print("No expenseCategoryId event deleted");
      }
    } else {
      print("No expenseCategoryId Category deleted");
    }

    notifyListeners();
  }
}
