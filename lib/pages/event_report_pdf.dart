import 'package:farmapp/provider/cattle_provider.dart';
import 'package:farmapp/provider/events_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:farmapp/models/cattle_model.dart';
import 'package:farmapp/provider/cattle_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

class EventReportPDF extends StatefulWidget {
  final searchDateOne;
  final searchDateTwo;
  const EventReportPDF({ Key? key, this.searchDateOne, this.searchDateTwo}) : super(key: key);

  @override
  State<EventReportPDF> createState() => _EventReportPDFState();
}

class _EventReportPDFState extends State<EventReportPDF> {

  @override
  void initState() {
   Provider.of<EventsProvider>(context, listen: false).getAllIndividualEventRecord(dateSearch: this.widget.searchDateOne, dateSearchTwo: this.widget.searchDateTwo);
   Provider.of<EventsProvider>(context, listen: false).getAllMassEventRecord(dateSearch: this.widget.searchDateOne, dateSearchTwo: this.widget.searchDateTwo);
    Provider.of<CattleProvider>(context, listen: false).getAllCattles("Unarchive Cattle", dateSearch: this.widget.searchDateOne, dateSearchTwo: this.widget.searchDateTwo);
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
                    child: Column(
                      children: [
                        Consumer<EventsProvider>(
                          builder:(_, provider, __) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),

               Padding(
                 padding: const EdgeInsets.only(left: 10),
                 child: Text("Individual Event",
                 style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 18,
                 ),
              //  textAlign: TextAlign.start,
                 ),
               ),

              DataTable(
          

            columnSpacing: 20,
        
            showCheckboxColumn: false,
           
            
            
            columns: [
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("TagNo")),
              DataColumn(label: Text("Event")),
              DataColumn(label: Text("Note")),
              
            ],
            
            rows: provider.individualEventsListByDate.map((individualEvent) =>  DataRow(
                onSelectChanged: (b) {},
                
                cells: [
                  
                  DataCell(Text(individualEvent.eventDate!)),
                 DataCell(Text(individualEvent.cattleTagNo!)),
                  DataCell(Text(individualEvent.eventType!)),
                  DataCell(Text(individualEvent.eventNotes!)),
                  // DataCell(Text(package.notes), onTap: (){}),
                  // DataCell(Text(package.rDate)),
            ])).toList(),
           
            
        ),
       
       Divider(
        thickness: 3,
       ),

          SizedBox(height: 15,),

               Padding(
                 padding: const EdgeInsets.only(left: 10),
                 child: Text("Mass Event",
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

            columnSpacing: 20,
            // dataRowColor: ,
            // headingRowColor: MaterialStateProperty<>.,
            showCheckboxColumn: false,
            
            columns: [
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Event")),
              DataColumn(label: Text("No of\nCattles")),
              DataColumn(label: Text("Note")),
              // DataColumn(label: Text("Notes"),numeric: false, onSort: (i, b) {}),
              // DataColumn(label: Text("Received"),numeric: false, onSort: (i, b) {}),
            ],
            rows: provider.massEventsListByDate.map((massEvent) => DataRow(
                onSelectChanged: (b) {},

                cells: [
                  DataCell(Text(massEvent.eventDate!)),
                  DataCell(Text(massEvent.eventType!)),
                  DataCell(Text(massEvent.numOfCattles!)),
                   DataCell(Text(massEvent.eventNotes!)),
                  // DataCell(Text(package.notes), onTap: (){}),
                  // DataCell(Text(package.rDate)),
            ])).toList(),
           
            
        ),

      
     
            ],
          ),
        )
                          ),


                           Consumer<CattleProvider>(
                          builder:(_, cprovider, __) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),

               Padding(
                 padding: const EdgeInsets.only(left: 10),
                 child: Text("Archived Cattles",
                 style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 18,
                 ),
              //  textAlign: TextAlign.start,
                 ),
               ),

              DataTable(
          

            columnSpacing: 20,
        
            showCheckboxColumn: false,
           
            
            
            columns: [
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("TagNo")),
              DataColumn(label: Text("Event")),
              DataColumn(label: Text("Note")),
              
            ],
            
            rows: cprovider.archivedcattleList.map((cattleEvent) =>  DataRow(
                onSelectChanged: (b) {},
                
                cells: [
                  
                  DataCell(Text(cattleEvent.cattleArchiveDate!)),
                 DataCell(Text(cattleEvent.cattleTagNo!)),
                  DataCell(Text(cattleEvent.cattleArchiveReason!)),
                  DataCell(Text(cattleEvent.cattleArchiveNotes!)),
                  // DataCell(Text(package.notes), onTap: (){}),
                  // DataCell(Text(package.rDate)),
            ])).toList(),
           
            
        ),
        
     
            ],
          ),
        )
                          ),
                       ],
                    )
                  ),
        
                ],
              ),
            ),
          ),
        ),
      //   floatingActionButton: GestureDetector(
      //   onTap: () async {
      //      RenderRepaintBoundary boundary = scr.currentContext!
      //                     .findRenderObject() as RenderRepaintBoundary;
      //                 var image = await boundary.toImage();
      //                 var byteData =
      //                     await image.toByteData(format: ImageByteFormat.png);
      //                 var pngBytes = byteData!.buffer.asUint8List();
      //                 String tempPath = (await getTemporaryDirectory()).path;
      //                 var dates = DateTime.now().toString();
      //                 await getPdf(pngBytes, dates, tempPath);
      //                 var pathurl = "$tempPath/$dates.pdf";
      //                 await Share.shareFiles([pathurl]);
     
      //   },
      //   child: Container(
      //     width: 130,
      //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //     decoration: BoxDecoration(
      //         // boxShadow: [
      //         //   BoxShadow( spreadRadius: 1, color: Colors.grey, )
      //         // ],
      //         color: Colors.green,
      //         borderRadius: BorderRadius.circular(20)),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: [
      //         Icon(Icons.share, color: Colors.white, size: 18,),
      //         Text(
      //           "SHARE PDF",
      //           style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 16,
      //               fontWeight: FontWeight.w600),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
  }
}