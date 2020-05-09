import 'package:flutter/material.dart';
import 'package:spkembung2/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'dart:math';

class PreferensiPage extends StatefulWidget {
  PreferensiPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _PreferensiPageState();
}

class _PreferensiPageState extends State<PreferensiPage> {
  final _formKey = new GlobalKey<FormState>();
  var firestore = Firestore.instance;

  List<int> prioritas = new List<int>();
  var listIndex; //= new List<int>.generate(10, (i) => i + 1);

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    getFire();
    super.initState();
  }

  getFire() async {
    List<double> content = [];
    List<double> hasil = [];
    List<double> kriteria = [];
    List<double> preferensi = [];
    QuerySnapshot getKri = await firestore.collection("kriteria").orderBy("kode_kriteria").getDocuments();
    QuerySnapshot getPref = await firestore.collection("preferensi").orderBy("id").getDocuments();
    int panjang = getKri.documents[0].data["prioritasKriteria"].length;
    for (int a =0; a < panjang; a++){
    for(int x = 0; x < panjang; x++){
    double prioritas = getPref.documents[x]["preferensi"][a];
    for (int i = 0; i < panjang; i++){
        content.add(prioritas * (getKri.documents[i].data[
                                                    "bobot_kriteria"]).toDouble());
    }
    hasil.add(content[x]);
    print(hasil);
    content.clear();
    }
    await firestore.collection("preferensi").document("preferensi"+a.toString()).setData({  
      'hitung': hasil,
    }, merge: true).then((documentReference) {
    }).catchError((e) {
      print(e);
    });
    await firestore.collection("alternatif").document("Alternatif"+(a+1).toString()).setData({  
      'preferensi': hasil.fold(0,(i,j) => i+j).toStringAsFixed(2),
    }, merge: true).then((documentReference) {
    }).catchError((e) {
      print(e);
    });
    hasil.clear();
    }
  }

  Future getAlternatif() async {
    QuerySnapshot getAlt = await firestore
        .collection("alternatif")
        .orderBy("kode_alternatif")
        .getDocuments();

    return getAlt.documents;
  }

  Future getPreferensi() async {
    QuerySnapshot getAlt = await firestore
        .collection("preferensi")
        .orderBy("id")
        .getDocuments();

    return getAlt.documents;
  }

  Future getKriteria() async {
    QuerySnapshot getAlt = await firestore
        .collection("kriteria")
        .orderBy("kode_kriteria")
        .getDocuments();

    return getAlt.documents;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(''),
      ),
      body: new Column(
        children: [
          new Padding(padding: EdgeInsets.only(top: 15)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new Text("Data Preferensi",
                  style: new TextStyle(
                      fontSize: 33.0,
                      color: const Color(0xFF21BFBD),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto")),
            ],
          ),
          new Text(
            "Perhitungan data Preferensi dilakukan\n dengan rumus :",
            //style: new TextStyle(fontSize:33.0,
            //color: const Color(0xFF21BFBD),
            //fontWeight: FontWeight.bold,
            //fontFamily: "Roboto"
            //)
          ),
          new Divider(),
          new Text(
            "TODO",
            //style: new TextStyle(fontSize:33.0,
            //color: const Color(0xFF21BFBD),
            //fontWeight: FontWeight.bold,
            //fontFamily: "Roboto"
            //)
          ),
          new Divider(),
          new Expanded(
              child: Container(
                  height: MediaQuery.of(context).size.height - 100.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(50.0)),
                  ),
                  child: FutureBuilder(
                      //future: getPosts(),
                      future: Future.wait([getAlternatif(), getKriteria(), getPreferensi()]),
                      builder: (_, AsyncSnapshot<List> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          var list = [
                            for (var i = 0;
                                i <
                                    snapshot.data[1][1]
                                        .data["prioritasKriteria"].length;
                                i += 1)
                              i
                          ];
                          List<int> max = new List<int>();

                          getmax(int a) {
                            max = List.from(
                                snapshot.data[1][a]["prioritasKriteria"]);
                            max.sort();
                            return max.last;
                          }

                          getmin(int a) {
                            max = List.from(
                                snapshot.data[1][a]["prioritasKriteria"]);
                            max.sort();
                            return max.first;
                          }

                          return ListView.builder(
                              padding: const EdgeInsets.only(
                                  top: 20, bottom: 10, right: 10, left: 10),
                              itemCount: snapshot.data[0].length,
                              itemBuilder: (_, index) {

                                return Card(
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 8.0),
                                  elevation: 4.0,
                                  child: ListTile(
                                      title: Text(
                                        "Preferensi " +
                                            snapshot.data[0][index]
                                                .data["kode_alternatif"] +
                                            ". " +
                                            snapshot.data[0][index]
                                                .data["nama_alternatif"],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      isThreeLine: false,
                                      subtitle: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          new Divider(),
                                          new Text("Pa = ("),
                                          for (var i in list)
                                          new Column (children: [
                                            new Text(snapshot.data[2][i].data[
                                                    "preferensi"][index].toStringAsFixed(2) + " x " +
                                                    snapshot.data[1][i].data[
                                                    "bobot_kriteria"].toString() + " = " +
                                                    ((snapshot.data[2][i].data[
                                                    "preferensi"][index]).toDouble() * (snapshot.data[1][i].data[
                                                    "bobot_kriteria"]).toDouble()).toStringAsFixed(2)
                                            ),
                                          ],),
                                          new Text(") = " + snapshot.data[2][index].data["hitung"].fold(0,(i,j) => i+j).toStringAsFixed(2)),
                                          new Divider(),
                                        ],
                                        
                                      ),
                                      onTap: () => null),
                                );
                              });
                        }
                      }))),
        ],
      ),
    );
  }
}
