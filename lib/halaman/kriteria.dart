import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:spkembung2/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spkembung2/widgets/drawer.dart';

class KriteriaPage extends StatefulWidget {
  KriteriaPage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<KriteriaPage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var list;
  var random;

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
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
      drawer: AppDrawer(),
      backgroundColor: Color(0xFF21BFBD),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 2.0, left: 10.0)),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text('Kriteria',
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
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('kriteria')
                    .orderBy('id')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 10, right: 10, left: 10),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document =
                          snapshot.data.documents[index];
                      Map<String, dynamic> alternatif = document.data;
                      //String kodeAlternatif = alternatif['kode_alternatif'];
                      return Card(
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        child: ListTile(
                          title: Text(
                            alternatif['nama_kriteria'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Keterangan: " +
                              alternatif["keterangan"] //+
                              //", Bobot: " +
                              //alternatif["bobot_kriteria"].toString()
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
                                  alternatif['kode_kriteria'],
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
                },
              ))
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        //onPressed: _showDialog,
        tooltip: 'Tambah Kriteria Baru',
        child: Icon(Icons.add),
      ),
    );
  }
}
