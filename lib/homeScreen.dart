import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton(onPressed: _createPDF, child: Text('Create Basic PDF')),
        RaisedButton(
            onPressed: _orderUnorderListPdf, child: Text('Types of List PDF')),
        RaisedButton(onPressed: _createPdfWithTable, child: Text('Table PDF')),
        RaisedButton(onPressed: _sendPDFByMail, child: Text('Send PDF via E-mail')),
      ],
    )));
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<void> _createPDF() async {
    //Create a new PDF document
    PdfDocument document = PdfDocument();

    //Set the page size
    document.pageSettings.size = PdfPageSize.a4;

    //Change the page orientation to landscape
    document.pageSettings.orientation = PdfPageOrientation.landscape;

    //Set the compression level
    document.compressionLevel = PdfCompressionLevel.best;

//Set margin for all the pages
    document.pageSettings.margins.all = 200;

    //Add a new page and draw text
    document.pages.add().graphics.drawString(
        'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 20),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, 0, 500, 50),
        pen: PdfPens.aquamarine);

    File f = await getImageFileFromAssets('pic.png');
    document.pages.add().graphics.drawImage(
        PdfBitmap(f.readAsBytesSync()),
        // PdfBitmap(File(AssetImage('assets/pic.png').toString()).readAsBytesSync()),
        Rect.fromLTWH(0, 0, 100, 100));

    //Create and draw the web link in the PDF page
    PdfTextWebLink(
            url: 'www.google.co.in',
            text: 'www.google.com',
            font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)),
            pen: PdfPens.brown,
            format: PdfStringFormat(
                alignment: PdfTextAlignment.center,
                lineAlignment: PdfVerticalAlignment.middle))
        .draw(document.pages.add(), Offset(50, 40));
    //Get external storage directory
    final directory = await getExternalStorageDirectory();

//Get directory path
    final path = directory.path;
    print(path);
    //Create an empty file to write PDF data
    //Write PDF data
    File('$path/Output.pdf').writeAsBytes(document.save());

    //Dispose the document
    document.dispose();

//Open the PDF document in mobile
    OpenFile.open('$path/Output.pdf');
  }

  Future<void> _createPdfWithTable() async {
    //Creates a new PDF document
    PdfDocument document = PdfDocument();

//Create a PdfGrid
    PdfGrid grid = PdfGrid();

//Add the columns to the grid
    grid.columns.add(count: 3);

//Add header to the grid
    grid.headers.add(1);

//Add the rows to the grid
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'RollNo';
    header.cells[1].value = 'Name';
    header.cells[2].value = 'Class';

//Add rows to grid
    PdfGridRow row = grid.rows.add();

    row.cells[0].value = '1';
    row.cells[1].value = 'Arya';
    row.cells[2].value = '6';
    row = grid.rows.add();
    row.cells[0].value = '12';
    row.cells[1].value = 'John';
    row.cells[2].value = '9';
    row = grid.rows.add();
    row.cells[0].value = '42';
    row.cells[1].value = 'Tony';
    row.cells[2].value = '8';

    //Create the PDF grid row style. Assign to second row
    PdfGridRowStyle rowStyle = PdfGridRowStyle(
      backgroundBrush: PdfBrushes.lightGoldenrodYellow,
      textPen: PdfPens.indianRed,
      textBrush: PdfBrushes.lightYellow,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
    );
    row.style = rowStyle;

//Draw grid to the page of the PDF document
    grid.draw(
      page: document.pages.add(),
      bounds: const Rect.fromLTWH(0, 0, 0, 0),
    );

    final directory = await getExternalStorageDirectory();

//Get directory path
    final path = directory.path;
    print(path);
    //Create an empty file to write PDF data
    //Write PDF data
    File('$path/Output2.pdf').writeAsBytes(document.save());

    //Dispose the document
    document.dispose();

//Open the PDF document in mobile
    OpenFile.open('$path/Output2.pdf');
  }

  Future<void> _orderUnorderListPdf() async {
    //Create a new PDF document
    PdfDocument document = PdfDocument();

//Create ordered list and draw on page
    PdfOrderedList(
            items: PdfListItemCollection(<String>[
              'Mammals',
              'Reptiles',
              'Birds',
              'Insects',
              'Aquatic Animals'
            ]),
            font: PdfStandardFont(PdfFontFamily.timesRoman, 20,
                style: PdfFontStyle.italic),
            indent: 20,
            format: PdfStringFormat(lineSpacing: 10,))
        .draw(page: document.pages.add(), bounds: Rect.fromLTWH(0, 20, 0, 0));

//Create unordered list and draw list on page
    PdfUnorderedList(
            text: 'Mammals\nReptiles\nBirds\nInsects\nAquatic Animals',
            style: PdfUnorderedMarkerStyle.disk,
            font: PdfStandardFont(PdfFontFamily.helvetica, 12),
            indent: 10,
            textIndent: 10,
            format: PdfStringFormat(lineSpacing: 10))
        .draw(page: document.pages.add(), bounds: Rect.fromLTWH(0, 10, 0, 0));

    final directory = await getExternalStorageDirectory();

//Get directory path
    final path = directory.path;
    print(path);
    //Create an empty file to write PDF data
    //Write PDF data
    File('$path/Output3.pdf').writeAsBytes(document.save());

    //Dispose the document
    document.dispose();

//Open the PDF document in mobile
    OpenFile.open('$path/Output3.pdf');
  }

  Future<void> _sendPDFByMail() async{
    final directory = await getExternalStorageDirectory();
    final path = directory.path;
    var attachment=File('$path/Output3.pdf').path;
    final Email email = Email(
      body: 'Your Invoice ',
      subject: 'Flutter Studio',
      recipients: ['codestudio0110@gmail.com'],
      attachmentPaths: [attachment],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);

  }
}
