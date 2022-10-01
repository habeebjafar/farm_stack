import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'farmDB');
    var database = await openDatabase(path, version: 1, onCreate: _onCreateDB);
    return database;
  }

  _onCreateDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE cattle(id INTEGER PRIMARY KEY AUTOINCREMENT,
     cattleBreed TEXT,
     cattleBreedId TEXT,
     cattleName TEXT,
     cattleTagNo TEXT,
     cattleGender TEXT,
     cattleStage TEXT,
     cattleStageImg TEXT,
     cattleWeight TEXT,
     cattleDOB TEXT,
     cattleDOE TEXT,
     cattleObtainMethod TEXT,
     cattleOtherSource TEXT,
     cattleMotherTagNo TEXT,
     cattleFatherTagNo TEXT,
     cattleStatus TEXT,
     cattleArchive TEXT,
     cattleArchiveReason TEXT,
     cattleArchiveOtherReason TEXT,
     cattleArchiveDate TEXT,
     cattleArchiveNotes TEXT,
     cattleNotes TEXT)
    
    ''');

    await db.execute('''
    CREATE TABLE cattleBreed(id INTEGER PRIMARY KEY AUTOINCREMENT,
     cattleBreed TEXT)
    
    ''');

    await db.execute('''
    CREATE TABLE milk(id INTEGER PRIMARY KEY AUTOINCREMENT,
     milkDate TEXT,
     milkType TEXT,
     milkTotalUsed TEXT,
     milkTotalProduced TEXT,
     cowMilked TEXT,
     cattleId TEXT,
     noOfCattleMilked TEXT)
    
    ''');

    await db.execute('''
    CREATE TABLE event(id INTEGER PRIMARY KEY AUTOINCREMENT,
     eventDate TEXT,
     numOfCattles,
     eventType TEXT,
     nameOfMedicine TEXT,
     eventNotes TEXT)
    
    ''');

    await db.execute('''
    CREATE TABLE eventIndividual(id INTEGER PRIMARY KEY AUTOINCREMENT,
     eventDate TEXT,
     eventType TEXT,
     nameOfMedicine TEXT,
     eventNotes TEXT,
     cattleId TEXT,
     cattleTagNo TEXT)
    
    ''');

    await db.execute('''
    CREATE TABLE income(id INTEGER PRIMARY KEY AUTOINCREMENT,
     incomeDate TEXT,
     incomeType TEXT,
     milkQty TEXT,
     selectedValueIncomeCategory TEXT,
     incomeCategoryId TEXT,
     otherSource TEXT,
     amountEarned TEXT,
     receiptNo TEXT,
     incomeNotes TEXT)
    
    ''');

    await db.execute('''
    CREATE TABLE incomeCategory(id INTEGER PRIMARY KEY AUTOINCREMENT,
     incomeCategory TEXT)
    
    ''');

    await db.execute('''
    CREATE TABLE expenses(id INTEGER PRIMARY KEY AUTOINCREMENT,
     expenseDate TEXT,
     expenseType TEXT,
     selectedValueExpenseCategory TEXT,
     expenseCategoryId TEXT,
     otherExpense TEXT,
     expenseNotes TEXT,
     amountSpent TEXT,
     receiptNo TEXT)
    
    ''');

    await db.execute('''
    CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT,
     transactionType TEXT,
     date TEXT,
     type TEXT,
     milkQty TEXT,
     selectedValueCategory TEXT,
     categoryId TEXT,
     otherIncomeExpense TEXT,
     amount TEXT,
     receiptNo TEXT,
     note TEXT)
    
    ''');

    await db.execute('''
    CREATE TABLE expenseCategory(id INTEGER PRIMARY KEY AUTOINCREMENT,
     expenseCategory TEXT)
    
    ''');
    await db.execute('''
    CREATE TABLE farmNotes(id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    date TEXT,
    message TEXT)
    
    ''');
  }
}
