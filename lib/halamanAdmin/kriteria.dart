import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spkembung2/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spkembung2/widgets/Kriteriacard.dart';
import 'package:spkembung2/widgets/drawer.dart';

class KriteriaAdmin extends StatefulWidget {
  KriteriaAdmin({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _KriteriaAdminState();
}

class _KriteriaAdminState extends State<KriteriaAdmin> {

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

  //TODE
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
                Text('Kriteria',
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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),

            child: 
      Center(
        child: Container(
          padding: const EdgeInsets.only(top: 30.0, bottom: 10.0, right: 10, left: 10),
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('kriteria').orderBy('id')
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
                          return new KriteriaCard(
                            kode: document['kode_kriteria'],
                            nama: document['nama_kriteria'],
                            bobot: document['bobot_kriteria'],
                            keterangan: document['keterangan'],
                            nilai: document['nilai'],
                            id: document['id']
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

  Widget _buildFoodItem(String imgPath, String foodName, String price) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
          onTap: () {
            
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: [
                    Hero(
                      tag: imgPath,
                      child: Image(
                        image: AssetImage(imgPath),
                        fit: BoxFit.cover,
                        height: 75.0,
                        width: 75.0
                      )
                    ),
                    SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(
                          foodName,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          price,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15.0,
                            color: Colors.grey
                          )
                        )
                      ]
                    )
                  ]
                )
              ),
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.black,
                onPressed: () {}
              )
            ],
          )
        ));
  }
}
