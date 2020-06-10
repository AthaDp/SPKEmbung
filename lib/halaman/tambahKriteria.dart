import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
//import 'package:flutter_firestore_todo/app_color.dart';
//import 'package:flutter_firestore_todo/widget_background.dart';
//import 'package:intl/intl.dart';


class TambahKriteria extends StatefulWidget {
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
  final String k5;
  final String k6;
  final String k0;
  final int index;
  final Timestamp timestamp;

  TambahKriteria({
    @required this.isEdit,
    this.documentId = '',
    this.name = '',
    this.description = '',
    this.date = '',
    this.k1 = '',
    this.k2 = '',
    this.k3 = '',
    this.k4 = '',
    this.k5 = '',
    this.k6 = '',
    this.k0 = '',
    this.nama = '',
    this.index,
    this.timestamp
  });

  @override
  _TambahKriteriaState createState() => _TambahKriteriaState();
}

class _TambahKriteriaState extends State<TambahKriteria> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final Firestore firestore = Firestore.instance;
  //final AppColor appColor = Color(0xFF21BFBD);
  final TextEditingController controllerName = TextEditingController();

  final TextEditingController controllerK0 = TextEditingController();

  final TextEditingController controllerK1 = TextEditingController();
  final TextEditingController controllerK2 = TextEditingController();
  final TextEditingController controllerK3 = TextEditingController();
  final TextEditingController controllerK4 = TextEditingController();
  final TextEditingController controllerK5 = TextEditingController();
  final TextEditingController controllerK6 = TextEditingController();

  double widthScreen;
  double heightScreen;
  DateTime date = DateTime.now().add(Duration(days: 1));
  bool isLoading = false;

  int kriteria1;
  int kriteria7;
  String alternatifValue;
  String alternatifValue2;

  @override
  void initState() {
    if (widget.isEdit) {
      String k1 = "helloworld";
      String k7 = "helloworld";
      controllerName.text = widget.nama;

      if(widget.k6 == "1"){
        alternatifValue2 = "one";
        k7 = "tersedia jalan aspal sampai site";
        kriteria7= 1;
      } else if(widget.k6 == "2"){
          alternatifValue2 = "two";
          k7 = "jalan makadam/tanah sampai site";
          kriteria7 = 2;
      } else if(widget.k6 == "3"){
          alternatifValue2 = "three";
          k7 = "jalan setapak";
          kriteria7 = 3;
      } else if(widget.k6 == "4"){
          alternatifValue2 = "four";
          k7 = "tidak tersedia jalan";
          kriteria7 = 4;
      } else {
        alternatifValue2 = null;
        k7 = null;
      }

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
      controllerK5.text = widget.k5;

      
      //selectedDropDownValue = "normal";
    } 
    super.initState();
  }

  normalisasi() async {
    List<int> prioritas = new List<int>();
    List<double> content = [];
    QuerySnapshot getAlt = await firestore
        .collection("alternatif")
        .orderBy("timestamp", descending: false)
        .getDocuments();
    QuerySnapshot getKri = await firestore
        .collection("kriteria")
        .orderBy("id")
        .getDocuments();
    int panjang = getAlt.documents.length;
    int preferensi = 0;
    for (int a = 0; a < 7; a++) {
      for (int b = 0; b < panjang; b++) {
        prioritas.add((getAlt.documents[b]["prioritas"][a]));
      }
      print("prioritas :" + prioritas.toString());
      for (int c = 0; c < panjang; c++) {
        if (getKri.documents[a]["keterangan"] == "Keuntungan") {
          content.add(prioritas[c] / prioritas.reduce(max));
        } else {
          content.add(prioritas.reduce(min) / prioritas[c]);
        }
      }
      print(content);
      await firestore
          .collection("preferensi")
          .document(preferensi < 10? "preferensi00"+ preferensi.toString() : "preferensi0"+ preferensi.toString() )
          // .document("preferensi" + preferensi.toString())
          .setData({
        'hitung' : [],
        'preferensi': content,
        'id': preferensi < 10? "00"+ preferensi.toString() : "0"+ preferensi.toString(),
      }, merge: true).then((documentReference) {
        //print(documentReference.documentID);
      }).catchError((e) {
        print(e);
      });
      content.clear();
      prioritas.clear();
      preferensi++;
    }
    content.clear();
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
          SizedBox(height: 12.0),
          Text(
            widget.isEdit ? 'Edit Kriteria' : 'Tambah Alternatif',
            style: Theme.of(context).textTheme.display1.merge(
                  TextStyle(color: Colors.grey[800]),
                ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: controllerName,
            decoration: InputDecoration(
              labelText: 'Nama Kriteria',
            ),
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetFormSecondary() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          children: <Widget>[

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
              keyboardType: TextInputType.number,
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
              keyboardType: TextInputType.number,
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
              keyboardType: TextInputType.number,
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
              keyboardType: TextInputType.number,
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
            TextField(
              keyboardType: TextInputType.number,
              controller: controllerK5,
              decoration: InputDecoration(
                labelText: 'K6: Harga air/m3',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.description),
                  ],
                ),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            DropdownButtonFormField(
              hint: Text("Pilih Akses Jalan Site"),
              value: alternatifValue2,
              onChanged: (String value2) {
                if (value2 == 'one') {
                  setState(() {
                    kriteria7 = 1;
                  });
                }
                if (value2 == 'two') {
                  setState(() {
                    kriteria7 = 2;
                  });
                }
                if (value2 == 'three') {
                  setState(() {
                    kriteria7 = 3;
                  });
                }
                if (value2 == 'four') {
                  setState(() {
                    kriteria7 = 4;
                  });
                }
                if (value2 == 'five') {
                  setState(() {
                    kriteria7 = 5;
                  });
                }
              },
              items: [
                DropdownMenuItem<String>(child: Text('tersedia jalan aspal sampai site'), value: 'one'),
                DropdownMenuItem<String>(
                    child: Text('jalan makadam/tanah sampai site'), value: 'two'),
                DropdownMenuItem<String>(
                    child: Text('jalan setapak'), value: 'three'),
                DropdownMenuItem<String>(
                    child: Text('tidak tersedia jalan'), value: 'four'),
              ],
            ),
            SizedBox(height: 16.0),      
          ],
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
          String k6 = controllerK5.text;
          String k7 = kriteria7.toString();

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
          } else if (k6.isEmpty) {
            _showSnackBarMessage('Nilai Kriteria 6 harus diisi!');
            return;
          } else if (k7 == "null") {
            _showSnackBarMessage('Nilai Kriteria 7 harus diisi!');
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
            int p6 = 0;

            if (double.parse(k2) < 40000) {
              p2 = 1;
            } else if (double.parse(k2) < 80000) {
              p2 = 2;
            } else if (double.parse(k2) < 120000) {
              p2 = 3;
            } else if (double.parse(k2) < 160000) {
              p2 = 4;
            } else if (double.parse(k2) < 200000) {
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

            if (double.parse(k4) >= 1500000) {
              p4 = 1;
            } else if (double.parse(k4) < 1500000 && double.parse(k4) >= 750000) {
              p4 = 2;
            } else if (double.parse(k4) < 750000 && double.parse(k4) >= 500000) {
              p4 = 3;
            } else if (double.parse(k4) < 500000 && double.parse(k4) >= 250000) {
              p4 = 4;
            } else if (double.parse(k4) < 250000) {
              p4 = 5;
            }

            if (double.parse(k5) >= 100) {
              p5 = 1;
            } else if (double.parse(k5) < 100 && double.parse(k5) >= 80) {
              p5 = 2;
            } else if (double.parse(k5) < 80 && double.parse(k5) >= 60) {
              p5 = 3;
            } else if (double.parse(k5) < 60 && double.parse(k5) >= 40) {
              p5 = 4;
            } else if (double.parse(k5) < 40) {
              p5 = 5;
            }

            if (double.parse(k6) < 10000) {
              p6 = 1;
            } else if (double.parse(k6) < 20000 && double.parse(k6) >= 10000) {
              p6 = 2;
            } else if (double.parse(k6) < 30000 && double.parse(k6) >= 20000) {
              p6 = 3;
            } else if (double.parse(k6) < 40000 && double.parse(k6) >= 30000) {
              p6 = 4;
            } else if (double.parse(k6) >= 40000) {
              p6 = 5;
            }

            String n1;
            if(k1 == "1"){
              n1 = "Hutan";
            } else if(k1 == "2"){
              n1 = "Semak Belukar";
            } else if(k1 == "3"){
              n1 = "Ladang / Tegalan";
            } else if(k1 == "4"){
              n1 = "Tadah Hujan";
            } else if(k1 == "5"){
              n1 = "Perkampungan";
            }

            String n7;
            if(k7 == "1"){
              n7 = "Tersedia Jalan Aspal";
            } else if(k7 == "2"){
              n7 = "Jalan Makadam / Tanah";
            } else if(k7 == "3"){
              n7 = "Jalan Setapak";
            } else if(k7 == "4"){
              n7 = "Tidak Tersedia Jalan";
            } 

            if(widget.isEdit){
              QuerySnapshot getAlt = await firestore
                .collection("alternatif")
                .orderBy("kode_alternatif")
                .getDocuments();
            List<String> kriteria = [n1.toString(), k2, k3, k4, k5,k6,n7.toString()];
            List<int> prioritas = [int.parse(k1), p2, p3, p4, p5, p6, int.parse(k7)];
            String kode = "empty";
            if(getAlt.documents.length < 9){
              kode = "00"+(getAlt.documents.length + 1).toString();
            } else if(getAlt.documents.length >= 9){
              kode = "0"+(getAlt.documents.length + 1).toString();
            }
            // String alternate = 'Alternatif' + kode.toString();
            // if(widget.isEdit == true){
            //   alternate = widget.documentId;
            // }
            CollectionReference tasks = firestore.collection('alternatif');

            await tasks
                .document(widget.documentId)
                .setData(<String, dynamic>{
              //'kode_alternatif': kode,
              'kriteria': kriteria,
              'nama_alternatif': name,
              'preferensi': 0,
              'prioritas': prioritas,
              'timestamp' : widget.timestamp
            });

            await normalisasi();
            Navigator.pop(context, true);

            } else {
            QuerySnapshot getAlt = await firestore
                .collection("alternatif")
                .orderBy("kode_alternatif")
                .getDocuments();
            List<String> kriteria = [n1.toString(), k2, k3, k4, k5,k6,n7.toString()];
            List<int> prioritas = [int.parse(k1), p2, p3, p4, p5, p6, int.parse(k7)];
            String kode = "empty";
            if(getAlt.documents.length < 9){
              kode = "00"+(getAlt.documents.length + 1).toString();
            } else if(getAlt.documents.length >= 9){
              kode = "0"+(getAlt.documents.length + 1).toString();
            }
            // String alternate = 'Alternatif' + kode.toString();
            // if(widget.isEdit == true){
            //   alternate = widget.documentId;
            // }
            CollectionReference tasks = firestore.collection('alternatif');

            await tasks
                .document()
                .setData(<String, dynamic>{
              //'kode_alternatif': kode,
              'kriteria': kriteria,
              'nama_alternatif': name,
              'preferensi': 0,
              'prioritas': prioritas,
              'timestamp' : Timestamp.now()
            });
            
            await normalisasi();
            Navigator.pop(context, true);
            }            
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
