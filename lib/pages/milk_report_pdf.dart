import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:farmapp/provider/milk_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class MilkReportPDF extends StatefulWidget {
  
    final searchDateOne;
  final searchDateTwo;
  const MilkReportPDF({Key? key, this.searchDateOne, this.searchDateTwo}) : super(key: key);


  @override
  State<MilkReportPDF> createState() => _MilkReportPDFState();
}

class _MilkReportPDFState extends State<MilkReportPDF> {
  
  @override
  void initState() {
   Provider.of<MilkProvider>(context, listen: false).getAllMilkRecord(dateSearch: this.widget.searchDateOne, dateSearchTwo: this.widget.searchDateTwo);
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
            'Milk Report PDF',
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
                    child: Consumer<MilkProvider>(
                      builder:(_, provider, __) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),

               Padding(
                 padding: const EdgeInsets.only(left: 10),
                 child: Text("Individual",
                 style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 18,
                 ),
              //  textAlign: TextAlign.start,
                 ),
               ),

              DataTable(
          // Table Displaying Queued Packages

            columnSpacing: 16,
            // dataRowColor: ,
            // headingRowColor: MaterialStateProperty.all<Color>(Colors.orange),
            // dataRowColor: MaterialStateProperty.all<Color>(Colors.orange),
            showCheckboxColumn: false,
            // showBottomBorder: true,
            
            
            columns: [
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("TagNo")),
              DataColumn(label: Text("Produced")),
              DataColumn(label: Text("Used")),
              DataColumn(label: Text("Left")),
              // DataColumn(label: Text("Notes"),numeric: false, onSort: (i, b) {}),
              // DataColumn(label: Text("Received"),numeric: false, onSort: (i, b) {}),
            ],
            
            rows: provider.milkRecordListDateSearch.map((milk) =>  DataRow(
                onSelectChanged: (b) {},
                
                cells: [
                  
                  DataCell(Text(
                    DateFormat('dd/MM/yy').format(DateTime.parse((milk.milkDate!))
                   
                        ))),
                 DataCell(Text("${milk.milkType == 'Individual Milk' ? milk.cowMilked! : 'Bulk-Milk   \n\t\t\t (${milk.noOfCattleMilked!})' }")),
                  DataCell(Text(milk.milkTotalProduced!)),
                  DataCell(Text(milk.milkTotalUsed!)),
                   DataCell(Text("${double.parse(milk.milkTotalProduced
                              .toString()) -
                          double.parse(milk.milkTotalUsed
                              .toString())}")),
                  // DataCell(Text(package.notes), onTap: (){}),
                  // DataCell(Text(package.rDate)),
            ])).toList(),
           
            
        ),
         Divider(
        thickness: 3,
       ),
      //  Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     Text("Total",
      //     style: TextStyle(
      //       fontWeight:  FontWeight.bold
      //     ),
      //     ),
      //     Text(provider..toString(),
      //     style: TextStyle(
      //       fontWeight:  FontWeight.bold
      //     ),
      //     )
      //   ],
      //  ),
      //  Divider(
      //   thickness: 3,
      //  ),

      //     SizedBox(height: 15,),

      //          Padding(
      //            padding: const EdgeInsets.only(left: 10),
      //            child: Text("Expenses",
      //            style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //             color: Colors.orange,
      //             fontSize: 18,
      //            ),
      //         //  textAlign: TextAlign.start,
      //            ),
      //          ),


      //    DataTable(

      //       columnSpacing: 16,

      //       showCheckboxColumn: false,
            
      //       columns: [
      //         DataColumn(label: Text("Date")),
      //         DataColumn(label: Text("Source")),
      //         DataColumn(label: Text("Amount")),
      //         DataColumn(label: Text("Note")),

      //       ],
      //       rows: provider.expenseTransListSearch.map((expense) => DataRow(
      //           onSelectChanged: (b) {},

      //           cells: [
      //             DataCell(Text(expense.date!)),
      //             DataCell(Text(expense.type! == "Category Expense" ? expense.selectedValueCategory! : expense.otherIncomeExpense!)),
      //             DataCell(Text(expense.amount!)),
      //              DataCell(Text(expense.note!)),

      //       ])).toList(),
           
            
      //   ),

      //     Divider(
      //   thickness: 3,
      //  ),
      //  Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     Text("Total",
      //     style: TextStyle(
      //       fontWeight:  FontWeight.bold
      //     ),
      //     ),
      //     Text(provider.totalExpenseSearch.toString(),
      //     style: TextStyle(
      //       fontWeight:  FontWeight.bold
      //     ),
      //     )
      //   ],
      //  ),
      //  Divider(
      //   thickness: 3,
      //  ),
      //  SizedBox(height: 15,),
      //  Row(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   // crossAxisAlignment: CrossAxisAlignment.end,
      //   children: [
      //     Text("Net:",
      //     style: TextStyle(
      //       fontWeight:  FontWeight.bold
      //     ),
      //     ),
      //     SizedBox(width: 30,),
      //     Text((provider.totalIncome - provider.totalExpense).toString(),
      //     style: TextStyle(
      //       fontWeight:  FontWeight.bold
      //     ),
      //     ),
      //      SizedBox(width: 10,)
      //   ],
      //  ),
     
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