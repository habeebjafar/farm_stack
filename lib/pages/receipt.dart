import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';

import 'package:farmapp/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class Receipt extends StatefulWidget {
  final searchDateOne;
  final searchDateTwo;
  const Receipt({Key? key, this.searchDateOne, this.searchDateTwo}) : super(key: key);

  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {


  @override
  void initState() {
   Provider.of<TransactionsProvider>(context, listen: false).getAllTransactionsRecord(dateSearch: this.widget.searchDateOne, dateSearchTwo: this.widget.searchDateTwo);
    super.initState();
  }
  var scr = GlobalKey();
  Future getPdf(Uint8List screenShot, time, tempPath) async {
    pw.Document pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Expanded(
            child: pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.contain),
          );
        },
      ),
    );
    var pathurl = "$tempPath/$time.pdf";

    File pdfFile = File(pathurl);
    pdfFile.writeAsBytesSync(await pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Transactions Report PDF',
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  RepaintBoundary(
                    key: scr,
                    child: Consumer<TransactionsProvider>(
                      builder:(_, provider, __) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),

               Padding(
                 padding: const EdgeInsets.only(left: 10),
                 child: Text("Income",
                 style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 18,
                 ),
              //  textAlign: TextAlign.start,
                 ),
               ),

              DataTable(
          

            columnSpacing: 16,
        
            showCheckboxColumn: false,
           
            
            
            columns: [
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Source")),
              DataColumn(label: Text("Amount")),
              DataColumn(label: Text("Note")),
              
            ],
            
            rows: provider.incomeTransListSearch.map((income) =>  DataRow(
                onSelectChanged: (b) {},
                
                cells: [
                  
                  DataCell(Text(income.date!)),
                 DataCell(Text("${income.type == 'Milk Sale' ? income.type! + ' (${income.milkQty})' :
                                                income.type == 'Category Income' ?  income.selectedValueCategory : 
                                                income.type == 'Other (specify)' ?  income.otherIncomeExpense: '' }")),
                  DataCell(Text(income.amount!)),
                  DataCell(Text(income.note!)),
                  // DataCell(Text(package.notes), onTap: (){}),
                  // DataCell(Text(package.rDate)),
            ])).toList(),
           
            
        ),
         Divider(
        thickness: 3,
       ),
       Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Total",
          style: TextStyle(
            fontWeight:  FontWeight.bold
          ),
          ),
          Text(provider.totalIncomeSearch.toString(),
          style: TextStyle(
            fontWeight:  FontWeight.bold
          ),
          )
        ],
       ),
       Divider(
        thickness: 3,
       ),

          SizedBox(height: 15,),

               Padding(
                 padding: const EdgeInsets.only(left: 10),
                 child: Text("Expenses",
                 style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  fontSize: 18,
                 ),
              //  textAlign: TextAlign.start,
                 ),
               ),


         DataTable(
          // Table Displaying Queued Packages

            columnSpacing: 16,
            // dataRowColor: ,
            // headingRowColor: MaterialStateProperty<>.,
            showCheckboxColumn: false,
            
            columns: [
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Expense")),
              DataColumn(label: Text("Amount")),
              DataColumn(label: Text("Note")),
              // DataColumn(label: Text("Notes"),numeric: false, onSort: (i, b) {}),
              // DataColumn(label: Text("Received"),numeric: false, onSort: (i, b) {}),
            ],
            rows: provider.expenseTransListSearch.map((expense) => DataRow(
                onSelectChanged: (b) {},

                cells: [
                  DataCell(Text(expense.date!)),
                  DataCell(Text(expense.type! == "Category Expense" ? expense.selectedValueCategory! : expense.otherIncomeExpense!)),
                  DataCell(Text(expense.amount!)),
                   DataCell(Text(expense.note!)),
                  // DataCell(Text(package.notes), onTap: (){}),
                  // DataCell(Text(package.rDate)),
            ])).toList(),
           
            
        ),

          Divider(
        thickness: 3,
       ),
       Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Total",
          style: TextStyle(
            fontWeight:  FontWeight.bold
          ),
          ),
          Text(provider.totalExpenseSearch.toString(),
          style: TextStyle(
            fontWeight:  FontWeight.bold
          ),
          )
        ],
       ),
       Divider(
        thickness: 3,
       ),
       SizedBox(height: 15,),
       Row(
        mainAxisAlignment: MainAxisAlignment.end,
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("Net:",
          style: TextStyle(
            fontWeight:  FontWeight.bold
          ),
          ),
          SizedBox(width: 30,),
          Text((provider.totalIncome - provider.totalExpense).toString(),
          style: TextStyle(
            fontWeight:  FontWeight.bold
          ),
          ),
           SizedBox(width: 10,)
        ],
       ),
     
            ],
          ),
        )
                      )
                  ),
        
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: GestureDetector(
        onTap: () async {
           RenderRepaintBoundary boundary = scr.currentContext!
                          .findRenderObject() as RenderRepaintBoundary;
                      var image = await boundary.toImage();
                      var byteData =
                          await image.toByteData(format: ImageByteFormat.png);
                      var pngBytes = byteData!.buffer.asUint8List();
                      String tempPath = (await getTemporaryDirectory()).path;
                      var dates = DateTime.now().toString();
                      await getPdf(pngBytes, dates, tempPath);
                      var pathurl = "$tempPath/$dates.pdf";
                      await Share.shareFiles([pathurl]);
     
        },
        child: Container(
          width: 130,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              // boxShadow: [
              //   BoxShadow( spreadRadius: 1, color: Colors.grey, )
              // ],
              color: Colors.green,
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.share, color: Colors.white, size: 18,),
              Text(
                "SHARE PDF",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
  }
}