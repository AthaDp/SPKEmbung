import 'package:flutter/material.dart';
import 'package:spkembung2/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tex/flutter_tex.dart';

class NormalisasiPage extends StatefulWidget {
  NormalisasiPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _NormalisasiPageState();
}

class _NormalisasiPageState extends State<NormalisasiPage> {
  final _formKey = new GlobalKey<FormState>();
  var firestore = Firestore.instance;
  var fireKriteria = Firestore.instance.collection("kriteria");
  var fireAlternatif = Firestore.instance.collection("alternatif");

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
    super.initState();
  }

  Future getAlternatif() async {
    QuerySnapshot getAlt = await firestore
        .collection("alternatif")
        .orderBy("kode_alternatif")
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
              new Text("Data Normalisasi",
                  style: new TextStyle(
                      fontSize: 33.0,
                      color: const Color(0xFF21BFBD),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto")),
            ],
          ),
          new Text(
            "Perhitungan Data Normalisasi Dilakukan :",
            //style: new TextStyle(fontSize:33.0,
            //color: const Color(0xFF21BFBD),
            //fontWeight: FontWeight.bold,
            //fontFamily: "Roboto"
            //)
          ),
          new Divider(),
          new Text(
            "1. Apabila kriteria cost :",
            //style: new TextStyle(fontSize:33.0,
            //color: const Color(0xFF21BFBD),
            //fontWeight: FontWeight.bold,
            //fontFamily: "Roboto"
            //)
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 16.0),
          ),
          new Text(
            "2. Apabila kriteria benefit :",
            //style: new TextStyle(fontSize:33.0,
            //color: const Color(0xFF21BFBD),
            //fontWeight: FontWeight.bold,
            //fontFamily: "Roboto"
            //)
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 16.0),
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
                      future: Future.wait([getAlternatif(), getKriteria()]),
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
                                
                                var keuntungan = [
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                  ),
                                  new Text("Keterangan : " +
                                      snapshot
                                          .data[1][index].data["keterangan"] +
                                      ", Nilai Max : " +
                                      getmax(index).toString()),
                                  new Text("Data Normalisasi :"),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                  ),
                                  for (var i in list)
                                    new Text("Alternatif " +
                                        (i + 1).toString() +
                                        ": " +
                                        snapshot.data[1][index]
                                            .data["prioritasKriteria"][i]
                                            .toString() +
                                        " / " +
                                        getmax(index).toString() +
                                        " = " +
                                        (snapshot.data[1][index].data[
                                                    "prioritasKriteria"][i] /
                                                getmax(index))
                                            .toString()),
                                  new Divider(),
                                ];

                                var biaya = [
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                  ),
                                  new Text("Keterangan: " +
                                      snapshot
                                          .data[1][index].data["keterangan"] +
                                      ", Nilai Minimum : " +
                                      getmin(index).toString()),
                                  new Text("Data Normalisasi :"),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                  ),
                                  for (var i in list)
                                    new Text("Alternatif " +
                                        (i + 1).toString() +
                                        ": " +
                                        getmin(index).toString() +
                                        " / " +
                                        snapshot.data[1][index]
                                            .data["prioritasKriteria"][i]
                                            .toString() +
                                        " = " +
                                        (getmin(index) /
                                                snapshot.data[1][index].data[
                                                    "prioritasKriteria"][i])
                                            .toString()),
                                  new Divider(),
                                ];

                                return Card(
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 8.0),
                                  elevation: 4.0,
                                  child: ListTile(
                                      title: Text(
                                        snapshot.data[1][index]
                                                .data["kode_kriteria"] +
                                            ". " +
                                            snapshot.data[1][index]
                                                .data["nama_kriteria"],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      isThreeLine: false,
                                      subtitle: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: snapshot.data[1][index]
                                                    .data["keterangan"] ==
                                                "Biaya"
                                            ? biaya
                                            : keuntungan,
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
