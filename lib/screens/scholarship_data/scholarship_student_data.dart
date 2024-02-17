import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ScholarshipQuizStudentData extends StatefulWidget {
  const ScholarshipQuizStudentData({Key? key}) : super(key: key);

  @override
  State<ScholarshipQuizStudentData> createState() =>
      _ScholarshipQuizStudentDataState();
}

class _ScholarshipQuizStudentDataState
    extends State<ScholarshipQuizStudentData> {
  bool _isLoading = true;
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  @override
  void initState() {
 
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        double height  = MediaQuery.of(context).size.height;
    double width  = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ScholarShip Quiz Student Data',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: MyColors.primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(onPressed: (){exportDataGridToExcel();}, icon: Icon(Icons.download, color: Colors.white,)),
          )
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: SfDataGrid(
                key: _key,
                  allowSorting: true,
                  allowFiltering: true,
                  source: EmployeeDataSource(),
                  columns: getColumns(height: height,width: width),
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  columnWidthMode: ColumnWidthMode.fill),
            ),
    );
  }

  List<GridColumn> getColumns({required double height, required double width}) {
    // final bool isMobileView =
    //     !isWebOrDesktop || (isWebOrDesktop && model.isMobileResolution);
    return <GridColumn>[
      GridColumn(
          columnName: 'Date',
          columnWidthMode:
        width < 750 ?
        ColumnWidthMode.none :
        ColumnWidthMode.fill,
          width:
               width < 750 ? 120.0 :
              double.nan,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: const Text(
                'Date',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )),
      GridColumn(
          columnName: 'Name',
          columnWidthMode:
            width < 750 ?
        ColumnWidthMode.none :
        ColumnWidthMode.fill,
          width:
               width < 750 ?120.0 :
              double.nan,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: const Text(
                'Name',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )),
      GridColumn(
          columnName: 'Email',
          columnWidthMode:
               width < 750 ?
        ColumnWidthMode.none :
        ColumnWidthMode.fill,
          width:
               width < 750 ? 150.0 :
              double.nan,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: const Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )),
      GridColumn(
          columnName: 'Phone',
          columnWidthMode:
               width < 750 ?
        ColumnWidthMode.none :
        ColumnWidthMode.fill,
          width:
               width < 750 ? 120.0 :
              double.nan,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: const Text(
                'Phone',
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )),
      GridColumn(
        columnName: 'Quiz Score',
         columnWidthMode:
               width < 750 ?
        ColumnWidthMode.none :
        ColumnWidthMode.fill,
        width:
            width < 750 ? 120.0 :
            double.nan,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: const Text(
              'Quiz Score',
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Coupen Code',
         columnWidthMode:
               width < 750 ?
        ColumnWidthMode.none :
        ColumnWidthMode.fill,
        width:
            width < 750 ? 120.0 :
            double.nan,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: const Text(
              'Coupen Code',
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Coupen Type',
         columnWidthMode:
               width < 750 ?
        ColumnWidthMode.none :
        ColumnWidthMode.fill,
        width:
             width < 750 ? 120.0 :
            double.nan,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: const Text(
              'Coupen Type',
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Coupen Value',
         columnWidthMode:
               width < 750 ?
        ColumnWidthMode.none :
        ColumnWidthMode.fill,
        width:
             width < 750 ? 120.0 :
            double.nan,
        label: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: const Text(
              'Coupen Value',
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
     
    ];
  }

void saveFile(List<int> bytes, String fileName) {
  final blob = html.Blob([Uint8List.fromList(bytes)]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", fileName)
    ..click();
  html.Url.revokeObjectUrl(url);
}

    Future<void> exportDataGridToExcel() async {
       final Workbook workbook = _key.currentState!.exportToExcelWorkbook();
    final List<int> bytes = workbook.saveAsStream();

    saveFile(bytes, 'scholarshipData.xlsx');
   // File('DataGrid.xlsx').writeAsBytes(bytes);
    
      workbook.dispose();
    }

  getData() async {
    try {
      List studentData = [];
      _scholarShipQuizData.clear();
      await FirebaseFirestore.instance
          .collection('Users')
          .where('list_of_attempted_scholarshipquiz', isNotEqualTo: '')
          .get()
          .then((value) {
        value.docs.forEach((element) {

        


         studentData.add(element);
        });
      });
      
      
      studentData.forEach((ele)async {
        Map coupenData = await getCoupenData(coupenCode: ele['schlrcupn']);

        if (ele['list_of_attempted_scholarshipquiz'].isNotEmpty &&
            ele['quiztrack'].isNotEmpty) {
              
          ele['quiztrack'].forEach((data)  {
        
            if (data['scholarshipQuiz']) {

             
              _scholarShipQuizData.add(ScholarShipQuizStudentData(
                  date: DateFormat('dd-MM-yyyy').parse(
                      DateFormat('dd-MM-yyyy').format(data['date'].toDate())),
                  name: ele['name'],
                  email: ele['email'],
                  phone: ele['mobilenumber'],
                  quizScore: double.parse(data['quizScore'].toStringAsFixed(2)),
                  coupenCode: ele['schlrcupn'],
                  coupenType: coupenData['type'] == '' ? 'Not Applied' : coupenData['type'],
                  coupenValue: double.parse(coupenData['value'] == '' ? '0' : coupenData['value']),
                 
                  ));
            }
          });
        }
      });

      

      // _scholarShipQuizData.sort((a, b) => b.date.compareTo(a.date));

      setState(() {
        _isLoading = false;
      });
      
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error in getting data $e');
    }
  }



 Future<Map<String, dynamic>> getCoupenData({required String coupenCode})async{
   Map <String, dynamic> data = {'type' : '', 'value' : ''};
    try {
     
      await FirebaseFirestore.instance.collection('coupons').where('couponCode', isEqualTo: coupenCode
      
      
      ).get().then((value) {
        
      if(value.docs.length != 0){
        data['type'] = value.docs[0].get('couponValue')['type'];
        data['value'] = value.docs[0].get('couponValue')['value'];
       
    }
      });
      setState(() {
        
      });
      print('Coupen data $data');
      return data;
    } catch (e) {
        print('Error in getting coupen data $e');
       return data;
     
    }
  }




}

class ScholarShipQuizStudentData {
  final DateTime date;
  final String name;
  final String email;
  final String phone;
  final double quizScore;
  final String coupenCode;
  final String coupenType;
  final double coupenValue;

  ScholarShipQuizStudentData({
    required this.date,
    required this.name,
    required this.email,
    required this.phone,
    required this.quizScore,
    required this.coupenCode,
    required this.coupenType,
    required this.coupenValue,
  });
}

final List<ScholarShipQuizStudentData> _scholarShipQuizData =
    <ScholarShipQuizStudentData>[];

class EmployeeDataSource extends DataGridSource {
  @override
  List<DataGridRow> get rows => _scholarShipQuizData
      .map<DataGridRow>((dataRow) => DataGridRow(cells: [
            DataGridCell<DateTime>(columnName: 'Date', value: dataRow.date),
            DataGridCell<String>(columnName: 'Name', value: dataRow.name),
            DataGridCell<String>(columnName: 'Email', value: dataRow.email),
            DataGridCell<String>(columnName: 'Phone', value: dataRow.phone),
            DataGridCell<double>(
                columnName: 'Quiz Score', value: dataRow.quizScore),
            DataGridCell<String>(
                columnName: 'Coupen Code', value: dataRow.coupenCode),
            DataGridCell<String>(
                columnName: 'Coupen Type', value: dataRow.coupenType),
            DataGridCell<double>(
                columnName: 'Coupen Value', value: dataRow.coupenValue),
              
          ]))
      .toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataCell) {
      return Center(
          child: Text(
        dataCell.value.toString(),
        textAlign: TextAlign.center,
      ));
    }).toList());
  }
}
