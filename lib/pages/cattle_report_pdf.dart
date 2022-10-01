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

class CattleReportPDF extends StatefulWidget {

  @override
  State<CattleReportPDF> createState() => _CattleReportPDFState();
}

class _CattleReportPDFState extends State<CattleReportPDF> {
  final scr = GlobalKey();

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
    var provider = Provider.of<CattleProvider>(context, listen: false);
    // provider.getAllCattles("All Active");
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text(
            'Cattle Report PDF',
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
          ),
        ),
        body: FutureBuilder(
          future: Provider.of<CattleProvider>(context, listen: false).getAllCattles("All Active"),
         builder: (BuildContext context,
                AsyncSnapshot<List<CattleModel>> snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return SingleChildScrollView(
            child: RepaintBoundary(
             key: scr,
             child: SingleChildScrollView(
               child: DataTable(
              
            columnSpacing: 10,
            
            showCheckboxColumn: false,
            showBottomBorder: true,
            horizontalMargin: 5,
        
            columns: [
        
             DataColumn(label: Text("Tag")),
             DataColumn(label: Text("Name")),
             DataColumn(label: Text("Gender")),
             DataColumn(label: Text("Stage")),
             DataColumn(label: Text("D.O.B")),
             DataColumn(label: Text("Breed")),
             DataColumn(label: Text("Wgt")),
             
            
            ],
            
            rows: provider.cattleList.map((cattle) =>  DataRow(
               onSelectChanged: (b) {},
               cells: [
        
                DataCell(Text(cattle.cattleTagNo!)),
                DataCell(Text(cattle.cattleName!)),
                 DataCell(Text(cattle.cattleGender!)),
                  DataCell(Text(cattle.cattleStage!)),
                 DataCell(Text(
                  DateFormat('dd/MM/yy').format(DateTime.parse((cattle.cattleDOB!))
                  ))),
                 DataCell(Text(cattle.cattleBreed!)),
                 DataCell(Text(cattle.cattleWeight!)),
        
            ])).toList(),
           
            
          ),
        
             )
        
            )
            );
              }
                }
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