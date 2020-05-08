import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spkembung2/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spkembung2/widgets/drawer.dart';

import 'package:spkembung2/halaman/detail_alternatif.dart';

class PeringkatPage extends StatefulWidget {
  PeringkatPage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _PeringkatPageState();
}

class _PeringkatPageState extends State<PeringkatPage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var list;
  var random;
  String namaKriteria;
  String kodeKriteria;

  @override
  void initState() {
    //_getName();
    super.initState();
  }

  Future getPosts() async {
    var firestore = Firestore.instance;

    QuerySnapshot getAlt = await firestore
        .collection("alternatif")
        .orderBy("preferensi")
        .getDocuments();

    return getAlt.documents;
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  NavigateToDetail(DocumentSnapshot post, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailAlternatif(post: post, id: index)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(elevation: 0.0, bottomOpacity: 0.0),
      drawer: AppDrawer(),
      backgroundColor: Color(0xFF21BFBD),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 10.0)),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text('Peringkat',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 45.0)),
                SizedBox(width: 10.0),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          // Expanded(child: null),
          Container(
              height: MediaQuery.of(context).size.height - 100.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0)),
              ),
              child: FutureBuilder(
                  future: getPosts(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 10, right: 10, left: 10),
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            return Card(
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 8.0),
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              child: ListTile(
                                title: Text(
                                  "Peringkat " + (index + 1).toString(),
                                  /*snapshot
                                        .data[index].data["nama_alternatif"],*/
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  snapshot.data[index].data["nama_alternatif"] +
                                      ", Nilai Preferensi: " +
                                      snapshot.data[index].data["preferensi"]
                                          .toString(),
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
                                            snapshot.data[index]
                                                .data["kode_alternatif"],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                      )
                                    ]),
                                /*onTap: () => NavigateToDetail(
                                      snapshot.data[index], index)*/
                              ),
                            );
                          });
                    }
                  }))
        ],
      ),
      /*
      floatingActionButton: FloatingActionButton(
        //onPressed: _showDialog,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),*/
    );
  }
}
