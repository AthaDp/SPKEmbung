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
    //getFire();
    super.initState();
  }


  Future getAlternatif() async {
    QuerySnapshot getAlt = await firestore
        .collection("alternatif")
        .orderBy("timestamp", descending: false)
        .getDocuments();

    return getAlt.documents;
  }

  Future getPreferensi() async {
    QuerySnapshot getAlt =
        await firestore.collection("preferensi").orderBy("id").getDocuments();

    return getAlt.documents;
  }

  Future getKriteria() async {
    QuerySnapshot getAlt = await firestore
        .collection("kriteria")
        .orderBy("id")
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
                      color: const Color(0xFF38C0D0),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto")),
            ],
          ),
          new Text(
            "Perhitungan data Preferensi dilakukan\n dengan rumus :",
            //style: new TextStyle(fontSize:33.0,
            //color: const Color(0xFF38C0D0),
            //fontWeight: FontWeight.bold,
            //fontFamily: "Roboto"
            //)
          ),
          new Divider(),
          Image.asset('assets/rumusPreferensi.png',  height: 50,),
            //style: new TextStyle(fontSize:33.0,
            //color: const Color(0xFF38C0D0),
            //fontWeight: FontWeight.bold,
            //fontFamily: "Roboto"
            //)
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
                      future: Future.wait(
                          [getAlternatif(), getKriteria(), getPreferensi()]),
                      builder: (_, AsyncSnapshot<List> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          var list = [for (var i = 0; i < 7; i += 1) i];
                          List<int> max = new List<int>();

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
                                        "Preferensi A" +
                                            (index+1)
                                                .toString() +
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
                                            new Column(
                                              children: [
                                                new Text(snapshot
                                                        .data[2][i]
                                                        .data["preferensi"]
                                                            [index]
                                                        .toStringAsFixed(2) +
                                                    " X " +
                                                    snapshot.data[1][i]
                                                        .data["bobot_kriteria"]
                                                        .toString() +
                                                    " = " +
                                                    ((snapshot.data[2][i].data[
                                                                        "preferensi"]
                                                                    [index])
                                                                .toDouble() *
                                                            (snapshot.data[1][i]
                                                                        .data[
                                                                    "bobot_kriteria"])
                                                                .toDouble())
                                                        .toStringAsFixed(2))
                                                        
                                                // new Text(snapshot.data[2][i].data[
                                                //         "preferensi"][index].toStringAsFixed(2) + " x " +
                                                //         snapshot.data[1][i].data[
                                                //         "bobot_kriteria"].toString() + " = " +
                                                //         ((snapshot.data[2][i].data[
                                                //         "preferensi"][index]).toDouble() * (snapshot.data[1][i].data[
                                                //         "bobot_kriteria"]).toDouble()).toStringAsFixed(2)
                                                // ),
                                              ],
                                            ),
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
