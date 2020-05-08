import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spkembung2/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spkembung2/widgets/alternatifcard.dart';
import 'package:spkembung2/widgets/drawer.dart';



class AlternatifAdminPage extends StatefulWidget {
  AlternatifAdminPage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;  

  @override
  State<StatefulWidget> createState() => new _AlternatifAdminPageState();
}

class _AlternatifAdminPageState extends State<AlternatifAdminPage> {

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
      appBar: new AppBar(
        elevation: 0.0, 
        bottomOpacity: 0.0
        ),
      drawer: AppDrawer(),
      backgroundColor: Color(0xFF21BFBD),
      body: 

      ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 2.0, left: 10.0)),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text('Alternatif',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0)),
                SizedBox(width: 10.0),
              ],
            ),
            ),
          SizedBox(height: 20.0,),
         // Expanded(child: null),
          Container(
            height: MediaQuery.of(context).size.height - 100.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0)),
            ),

            child: 
      Center(
        child: Container(
          padding: const EdgeInsets.only(top: 30.0, bottom: 10.0, right: 10, left: 10),
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('alternatif').orderBy('kode_alternatif')
              .snapshots(),
            builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return new ListView(
                      children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                          return new AlternatifCard(
                            kode: document['kode_alternatif'],
                            nama: document['nama_alternatif'],
                          );
                      }).toList(),
                    );
                }
              },
            )),
          ),




          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        //onPressed: _showDialog,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
