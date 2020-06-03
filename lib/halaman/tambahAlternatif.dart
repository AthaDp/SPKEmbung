import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_firestore_todo/app_color.dart';
//import 'package:flutter_firestore_todo/widget_background.dart';
//import 'package:intl/intl.dart';

class TambahAlternatif extends StatefulWidget {
  final bool isEdit;
  final String documentId;
  final String name;
  final String nama;
  final String description;
  final String date;
  final String k1;
  final String k2;
  final String k3;
  final String k4;
  final String k0;
  final int index;

  TambahAlternatif({
    @required this.isEdit,
    this.documentId = '',
    this.name = '',
    this.description = '',
    this.date = '',
    this.k1 = '',
    this.k2 = '',
    this.k3 = '',
    this.k4 = '',
    this.k0 = '',
    this.nama = '',
    this.index,
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

  // List<DropdownMenuItem<int>> listDrop = [];
  // void loadData() {
  //   listDrop.add(new DropdownMenuItem(
  //     child: new Text("Hutan"),
  //     value: 1,
  //     ));
  //   listDrop.add(new DropdownMenuItem(
  //     child: new Text("Semak Belukar"),
  //     value: 2,
  //     ));
  //   listDrop.add(new DropdownMenuItem(
  //     child: new Text("Ladang / Tegalan"),
  //     value: 3,
  //     ));
  //   listDrop.add(new DropdownMenuItem(
  //     child: new Text("Tadah Hujan"),
  //     value: 4,
  //     ));
  //   listDrop.add(new DropdownMenuItem(
  //     child: new Text("Perkampungan"),
  //     value: 5,
  //     ));
  // }

  String _myList;
  String _myListResult;
  int kriteria1;
  String alternatifValue;

  @override
  void initState() {
    _myList = '';
    _myListResult = '';
    // loadData();
    // print(listDrop);
    if (widget.isEdit) {
      String k1 = "helloworld"; //prioritas K1
      controllerName.text = widget.nama;
      //kriteria1 = 1; //angka
      if(widget.k0 == "1"){
        alternatifValue = "one";
        k1 = "Hutan";
      } else if(widget.k0 == "2"){
          alternatifValue = "two";
          k1 = "Semak Belukar";
          kriteria1 = 1;
      } else if(widget.k0 == "3"){
          alternatifValue = "three";
          k1 = "Ladang / Tegalan";
          kriteria1 = 2;
      } else if(widget.k0 == "4"){
          alternatifValue = "four";
          k1 = "Sawah Tadah Hujan";
          kriteria1 = 3;
      } else if(widget.k0 == "5"){
          alternatifValue = "five";
          k1 = "Perkampungan";
          kriteria1 = 4;
      } else {
        alternatifValue = null;
        k1 = null;
      }
      controllerK1.text = widget.k1;
      controllerK2.text = widget.k2;
      controllerK3.text = widget.k3;
      controllerK4.text = widget.k4;
      //selectedDropDownValue = "normal";
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
            // TextField(
            //   controller: controllerK0,
            //   decoration: InputDecoration(
            //     labelText: 'K1',
            //     suffixIcon: Column(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: <Widget>[
            //         Icon(Icons.description),
            //       ],
            //     ),
            //   ),
            //   style: TextStyle(fontSize: 18.0),
            // ),
            DropdownButtonFormField(
              hint: Text("Pilih Kategori Vegetasi"),
              value: alternatifValue,
              onChanged: (String value) {
                if (value == 'one') {
                  setState(() {
                    kriteria1 = 1;
                  });
                }
                if (value == 'two') {
                  setState(() {
                    kriteria1 = 2;
                  });
                }
                if (value == 'three') {
                  setState(() {
                    kriteria1 = 3;
                  });
                }
                if (value == 'four') {
                  setState(() {
                    kriteria1 = 4;
                  });
                }
                if (value == 'five') {
                  setState(() {
                    kriteria1 = 5;
                  });
                }
              },
              items: [
                DropdownMenuItem<String>(child: Text('Hutan'), value: 'one'),
                DropdownMenuItem<String>(
                    child: Text('Semak Belukar'), value: 'two'),
                DropdownMenuItem<String>(
                    child: Text('Ladang / Tegalan'), value: 'three'),
                DropdownMenuItem<String>(
                    child: Text('Tadah Hujan'), value: 'four'),
                DropdownMenuItem<String>(
                    child: Text('Perkampungan'), value: 'five'),
              ],
            ),
            TextField(
              controller: controllerK1,
              decoration: InputDecoration(
                labelText: 'K2: Volume Material Timbunan',
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
                labelText: 'K3: Luas Daerah Yang Akan Dibebaskan',
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
                labelText: 'K4: Volume Tampungan Efektif',
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
                labelText: 'K5: Lama Operasi',
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
        child:
            Text(widget.isEdit ? 'PERBARUI ALTERNATIF' : 'TAMBAH ALTERNATIF'),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        onPressed: () async {
          String name = controllerName.text;
          String k1 = kriteria1.toString();
          String k2 = controllerK1.text;
          String k3 = controllerK2.text;
          String k4 = controllerK3.text;
          String k5 = controllerK4.text;
          //String date = controllerDate.text;

          if (name.isEmpty) {
            _showSnackBarMessage('Nama harus diisi!');
            return;
          } else if (k1 == "null") {
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
          // if (widget.isEdit) {
          //   //
          // } 
          
            //print(k1);
            int p1 = int.parse(k1);
            int p2 = 0;
            int p3 = 0;
            int p4 = 0;
            int p5 = 0;
            if (int.parse(k2) < 40000) {
              p2 = 1;
            } else if (int.parse(k2) < 80000) {
              p2 = 2;
            } else if (int.parse(k2) < 120000) {
              p2 = 3;
            } else if (int.parse(k2) < 160000) {
              p2 = 4;
            } else if (int.parse(k2) < 200000) {
              p2 = 5;
            }

            if (double.parse(k3) < 3) {
              p3 = 1;
            } else if (double.parse(k3) < 4.5) {
              p3 = 2;
            } else if (double.parse(k3) < 6) {
              p3 = 3;
            } else if (double.parse(k3) < 7.5) {
              p3 = 4;
            } else if (double.parse(k3) > 7.5) {
              p3 = 5;
            }

            if (int.parse(k4) >= 1500000) {
              p4 = 1;
            } else if (int.parse(k4) < 1500000 && int.parse(k4) >= 750000) {
              p4 = 2;
            } else if (int.parse(k4) < 750000 && int.parse(k4) >= 500000) {
              p4 = 3;
            } else if (int.parse(k4) < 500000 && int.parse(k4) >= 250000) {
              p4 = 4;
            } else if (int.parse(k4) < 250000) {
              p4 = 5;
            }

            if (int.parse(k5) >= 100) {
              p5 = 1;
            } else if (int.parse(k5) < 100 && int.parse(k5) >= 80) {
              p5 = 2;
            } else if (int.parse(k5) < 80 && int.parse(k5) >= 60) {
              p5 = 3;
            } else if (int.parse(k5) < 60 && int.parse(k5) >= 40) {
              p5 = 4;
            } else if (int.parse(k5) < 40) {
              p5 = 5;
            }

            QuerySnapshot getAlt = await firestore
                .collection("alternatif")
                .orderBy("kode_alternatif")
                .getDocuments();
            List<String> kriteria = [k1.toString(), k2, k3, k4, k5];
            List<int> prioritas = [int.parse(k1), p2, p3, p4, p5];
            int kode = getAlt.documents.length + 1;;
            if(widget.isEdit == true){
              kode = widget.index+1;
            }
            CollectionReference tasks = firestore.collection('alternatif');

            await tasks
                .document('Alternatif' + kode.toString())
                .setData(<String, dynamic>{
              'kode_alternatif': kode,
              'kriteria': kriteria,
              'nama_alternatif': name,
              'preferensi': 0,
              'prioritas': prioritas,
            });
            Navigator.pop(context, true);            
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
