import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:spkembung2/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailAlternatif extends StatefulWidget {
  DetailAlternatif(
      {Key key,
      this.auth,
      this.userId,
      this.logoutCallback,
      this.id,
      this.nama,
      this.post})
      : super(key: key);

  final DocumentSnapshot post;

  final String nama;
  final int id;
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _DetailAlternatifState();
}

class _DetailAlternatifState extends State<DetailAlternatif> {
  @override
  void initState() {
    //_getName();
    super.initState();
  }

  var firestore = Firestore.instance;

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var list;
  var random;

  int id;
  String nama;
  String namaKriteria;
  String kodeKriteria;

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Future getPosts() async {
    var firestore = Firestore.instance;

    QuerySnapshot getKri =
        await firestore.collection("kriteria").orderBy("id").getDocuments();

    return getKri.documents;
  }

  Future getAlternatif() async {
    QuerySnapshot getAlt = await firestore
        .collection("alternatif")
        .orderBy("kode_alternatif")
        .getDocuments();

    return getAlt.documents;
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      list = List.generate(random.nextInt(10), (i) => "Item $i");
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(elevation: 0.0, bottomOpacity: 0.0),
      //drawer: AppDrawer(),
      backgroundColor: Color(0xFF21BFBD),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 2.0, left: 10.0)),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text(
                    "A" +
                        widget.post.data["kode_alternatif"].toString() +
                        ". " +
                        widget.post.data["nama_alternatif"],
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 38.0)),
                SizedBox(width: 10.0),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
              height: MediaQuery.of(context).size.height - 100.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0)),
              ),
              child: FutureBuilder(
                future: Future.wait([getPosts(), getAlternatif()]),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 10, right: 10, left: 10),
                      itemCount: snapshot.data[0].length,
                      itemBuilder: (_, index) {
                        return Card(
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8.0),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          child: ListTile(
                            title: Text(
                              snapshot.data[0][index].data["nama_kriteria"],
                              //widget.post.data["nama_kriteria"],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: new Row(
                              children: <Widget>[
                                Text(snapshot.data[1][widget.id]
                                        .data["kriteria"][index]
                                        .toString() +
                                    ", Nilai Prioritas: " +
                                    snapshot.data[1][widget.id]
                                        .data["prioritas"][index]
                                        .toString()),
                              ],
                            ),
                            isThreeLine: false,
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF21BFBD),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                      child: Text(
                                    snapshot
                                        .data[0][index].data["kode_kriteria"],
                                    //kriteria['kode_kriteria'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ))
        ],
      ),
    );
  }
}
