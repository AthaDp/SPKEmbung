import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_firestore_todo/app_color.dart';
//import 'package:flutter_firestore_todo/widget_background.dart';
//import 'package:intl/intl.dart';

class TambahAlternatif extends StatefulWidget {
  final bool isEdit;
  final String documentId;
  final String name;
  final String description;
  final String date;

  TambahAlternatif({
    @required this.isEdit,
    this.documentId = '',
    this.name = '',
    this.description = '',
    this.date = '',
  });

  @override
  _TambahAlternatifState createState() => _TambahAlternatifState();
}

class _TambahAlternatifState extends State<TambahAlternatif> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final Firestore firestore = Firestore.instance;
  //final AppColor appColor = Color(0xFF21BFBD);
  final TextEditingController controllerName = TextEditingController();

  final TextEditingController controllerK0 = TextEditingController();

  final TextEditingController controllerK1 = TextEditingController();
    final TextEditingController controllerK2 = TextEditingController();
      final TextEditingController controllerK3 = TextEditingController();
        final TextEditingController controllerK4 = TextEditingController();

  double widthScreen;
  double heightScreen;
  DateTime date = DateTime.now().add(Duration(days: 1));
  bool isLoading = false;

  @override
  void initState() {
    if (widget.isEdit) {
      //date = DateFormat('dd MMMM yyyy').parse(widget.date);
      // controllerName.text = widget.name;
      // controllerDescription.text = widget.description;
      // controllerK1.text = widget.date;
    } else {
      //controllerDate.text = DateFormat('dd MMMM yyyy').format(date);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    widthScreen = mediaQueryData.size.width;
    heightScreen = mediaQueryData.size.height;

    return Scaffold(
      key: scaffoldState,
      //backgroundColor: appColor.colorPrimary,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            //WidgetBackground(),
            Container(
              width: widthScreen,
              height: heightScreen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildWidgetFormPrimary(),
                  SizedBox(height: 16.0),
                  _buildWidgetFormSecondary(),
                  isLoading
                      ? Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              //valueColor: AlwaysStoppedAnimation<Color>(appColor.colorTertiary),
                            ),
                          ),
                        )
                      : _buildWidgetButtonCreateTask(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetFormPrimary() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            widget.isEdit ? 'Edit Alternatif' : 'Tambah Alternatif',
            style: Theme.of(context).textTheme.display1.merge(
                  TextStyle(color: Colors.grey[800]),
                ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: controllerName,
            decoration: InputDecoration(
              labelText: 'Nama Alternatif',
            ),
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetFormSecondary() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: controllerK0,
              decoration: InputDecoration(
                labelText: 'K1',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.description),
                  ],
                ),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              controller: controllerK1,
              decoration: InputDecoration(
                labelText: 'K2',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.description),
                  ],
                ),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              controller: controllerK2,
              decoration: InputDecoration(
                labelText: 'K3',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.description),
                  ],
                ),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              controller: controllerK3,
              decoration: InputDecoration(
                labelText: 'K4',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.description),
                  ],
                ),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              controller: controllerK4,
              decoration: InputDecoration(
                labelText: 'K5',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.description),
                  ],
                ),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            
            SizedBox(height: 16.0),
            /*TextField(
              controller: controllerDate,
              decoration: InputDecoration(
                labelText: 'Date',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.today),
                  ],
                ),
              ),
              style: TextStyle(fontSize: 18.0),
              readOnly: true,
              onTap: () async {
                DateTime today = DateTime.now();
                DateTime datePicker = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: today,
                  lastDate: DateTime(2021),
                );
                if (datePicker != null) {
                  date = datePicker;
                  //controllerDate.text = DateFormat('dd MMMM yyyy').format(date);
                }
              },
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetButtonCreateTask() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: RaisedButton(
        color: Color(0xFF21BFBD),
        child: Text(widget.isEdit ? 'PERBARUI ALTERNATIF' : 'TAMBAH ALTERNATIF'),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        onPressed: () async {
          String name = controllerName.text;
          String k1 = controllerK0.text;
          String k2 = controllerK1.text;
          String k3 = controllerK2.text;
          String k4 = controllerK3.text;
          String k5 = controllerK4.text;
          //String date = controllerDate.text;
          if (name.isEmpty) {
            _showSnackBarMessage('Nama harus diisi!');
            return;
          } else if (k1.isEmpty) {
            _showSnackBarMessage('Nilai Kriteria 1 harus diisi!');
            return;
          } else if (k2.isEmpty) {
            _showSnackBarMessage('Nilai Kriteria 2 harus diisi!');
            return;
          } else if (k3.isEmpty) {
            _showSnackBarMessage('Nilai Kriteria 3 harus diisi!');
            return;
          } else if (k4.isEmpty) {
            _showSnackBarMessage('Nilai Kriteria 4 harus diisi!');
            return;
          } else if (k5.isEmpty) {
            _showSnackBarMessage('Nilai Kriteria 5 harus diisi!');
            return;
          }
          setState(() => isLoading = true);
          if (widget.isEdit) {
            //
          }else {
            // CollectionReference tasks = firestore.collection('tasks');
            // DocumentReference result = await tasks.add(<String, dynamic>{
            //   'name': name,
            //   'description': description,
            //   'date': date,
            // });
            // if (result.documentID != null) {
            //   Navigator.pop(context, true);
            // }
          }
          // if (widget.isEdit) {
          //   DocumentReference documentTask = firestore.document('tasks/${widget.documentId}');
          //   firestore.runTransaction((transaction) async {
          //     DocumentSnapshot task = await transaction.get(documentTask);
          //     if (task.exists) {
          //       await transaction.update(
          //         documentTask,
          //         <String, dynamic>{
          //           'name': name,
          //           'description': description,
          //           'date': date,
          //         },
          //       );
          //       Navigator.pop(context, true);
          //     }
          //   });
          // } else {
          //   CollectionReference tasks = firestore.collection('tasks');
          //   DocumentReference result = await tasks.add(<String, dynamic>{
          //     'name': name,
          //     'description': description,
          //     'date': date,
          //   });
          //   if (result.documentID != null) {
          //     Navigator.pop(context, true);
          //   }
          //}
        },
      ),
    );
  }

  void _showSnackBarMessage(String message) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}