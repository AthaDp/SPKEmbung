import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spkembung2/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spkembung2/widgets/drawer.dart';
import 'dart:math';

import 'package:spkembung2/halaman/detail_alternatif.dart';
import 'package:spkembung2/halaman/tambahalternatif.dart';

class AlternatifPage extends StatefulWidget {
  AlternatifPage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _AlternatifPageState();
}

class _AlternatifPageState extends State<AlternatifPage> {
  var firestore = Firestore.instance;
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var list;
  var random;
  String namaKriteria;
  String kodeKriteria;

  @override
  void initState() {
    //normalisasi();
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   preferensi();
    // });
    super.initState();
  }

  // normalisasi() async {
  //   List<int> prioritas = new List<int>();
  //   List<double> content = [];
  //   QuerySnapshot getAlt = await firestore
  //       .collection("alternatif")
  //       .orderBy("kode_alternatif")
  //       .getDocuments();
  //   QuerySnapshot getKri = await firestore
  //       .collection("kriteria")
  //       .orderBy("kode_kriteria")
  //       .getDocuments();
  //   int panjang = getAlt.documents.length;
  //   int preferensi = 0;
  //   for (int a = 0; a < getKri.documents.length; a++) {
  //     for (int b = 0; b < panjang; b++) {
  //       prioritas.add(getAlt.documents[b]["prioritas"][a]);
  //     }
  //     print("prioritas jelek:" + prioritas.toString());
  //     for (int c = 0; c < panjang; c++) {
  //       if (getKri.documents[a]["keterangan"] == "Keuntungan") {
  //         content.add(prioritas[c] / prioritas.reduce(max));
  //       } else {
  //         content.add(prioritas.reduce(min) / prioritas[c]);
  //       }
  //     }
  //     print(content);
  //     await firestore
  //         .collection("preferensi")
  //         .document()
  //         .setData({
  //       'preferensi': content,
  //       'id': preferensi,
  //     }, merge: true).then((documentReference) {
  //     }).catchError((e) {
  //       print(e);
  //     });
  //     content.clear();
  //     prioritas.clear();
  //     preferensi++;
  //   }
  //   content.clear();
  // }

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
    for (int a = 0; a < 5; a++) {
      for (int b = 0; b < panjang; b++) {
        prioritas.add(getAlt.documents[b]["prioritas"][a]);
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
          .document("preferensi" + preferensi.toString())
          .setData({
        'preferensi': content,
        'id': preferensi,
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

  preferensi() async {
    List<double> content = [];
    List<double> contentPref = [];
    List<double> bobot = [];
    List<double> hasil = [];
    QuerySnapshot getKri = await firestore
        .collection("kriteria")
        .orderBy("kode_kriteria")
        .getDocuments();
    QuerySnapshot getAlt = await firestore
        .collection("alternatif")
        .orderBy("kode_alternatif")
        .getDocuments();
    QuerySnapshot getPref =
        await firestore.collection("preferensi").orderBy("id").getDocuments();
    int panjang = getAlt.documents.length; //panjang Kriteria
    int iterate = 5;
    for (int v = 0; v < 5; v++) {
      bobot.add((getKri.documents[v].data["bobot_kriteria"]).toDouble());
    }
    print("bobot : " + bobot.toString());
    for (int a = 0; a < panjang; a++) {
      for (int b = 0; b < iterate; b++) {
        content.add(getPref.documents[b]["preferensi"][a]);
      }
      for (int c = 0; c < 5; c++) {
        hasil.add(content[c] * bobot[c]);
      }
      content.clear();
      contentPref.clear();

      await firestore
          .collection("preferensi")
          .document("preferensi" + a.toString())
          .setData({
            'hitung': hasil,
          }, merge: true)
          .then((documentReference) {})
          .catchError((e) {
            print(e);
          });
      await firestore
          .collection("alternatif")
          .document("Alternatif" + (a + 1).toString())
          .setData({
            'preferensi': hasil.fold(0, (i, j) => i + j),
          }, merge: true)
          .then((documentReference) {})
          .catchError((e) {
            print(e);
          });
      hasil.clear();
    }
  }

  

  Future getPosts() async {
    QuerySnapshot getAlt = await firestore
        .collection("alternatif")
        .orderBy("kode_alternatif")
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

  // NavigateToDetail(DocumentSnapshot post, int index) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => DetailAlternatif(post: post, id: index)));
  // }

  NavigateToDetail(Map<String, dynamic> post, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailAlternatif(post: post, id: index)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   // onPressed: (){
      //   //   normalisasi();
      //   // },
      //   onPressed: () async {
      //     bool result = await Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => TambahAlternatif(isEdit: false)));
      //     setState(() {});
      //   },
      //   tooltip: 'Tambah Kriteria Baru',
      //   child: Icon(Icons.add),
      // ),
      appBar: new AppBar(elevation: 0.0, bottomOpacity: 0.0, iconTheme: new IconThemeData(color: Colors.white),),
      drawer: AppDrawer(),
      backgroundColor: Color(0xFF38C0D0),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 10.0)),
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
              height: MediaQuery.of(context).size.height - 200.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0)),
              ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('alternatif').orderBy("timestamp", descending: false).snapshots(),
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
                          Map<String, dynamic> data = document.data;
                          return Card(
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8.0),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                            child: ListTile(
                              title: Text(
                                data["nama_alternatif"],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              isThreeLine: false,
                              leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF38C0D0),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "A" +
                                              (index+1)
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    )
                                  ]),
                              // trailing: PopupMenuButton(
                              //   itemBuilder: (BuildContext context) {
                              //     return List<PopupMenuEntry<String>>()
                              //       ..add(PopupMenuItem<String>(
                              //         value: 'edit',
                              //         child: Text('Edit'),
                              //       ))
                              //       ..add(PopupMenuItem<String>(
                              //         value: 'delete',
                              //         child: Text('Hapus'),
                              //       ));
                              //   },
                              //   onSelected: (String value) async {
                              //     if (value == 'edit') {
                              //       bool result = await Navigator.push(
                              //         context,
                              //         MaterialPageRoute(builder: (context) {
                              //           return TambahAlternatif(
                              //             isEdit: true,
                              //             documentId: document.documentID,
                              //             index: index,
                              //             nama: data["nama_alternatif"],
                              //             k0: data["prioritas"][0]
                              //                 .toString(),
                              //             k1: data["kriteria"][1],
                              //             k2: data["kriteria"][2],
                              //             k3: data["kriteria"][3],
                              //             k4: data["kriteria"][4],
                              //             k5: data["kriteria"][5],
                              //             k6: data["prioritas"][6].toString(),
                              //             timestamp: data["timestamp"]
                              //           );
                              //         }),
                              //       );
                              //       setState(() {});
                              //       normalisasi();
                              //     } else if (value == 'delete') {
                              //       showDialog(
                              //         context: context,
                              //         builder: (BuildContext context) {
                              //           return AlertDialog(
                              //             title: Text('Hapus Alternatif'),
                              //             content: Text(
                              //                 'Anda yakin ingin menghapus Alternatif ini?'),
                              //             actions: <Widget>[
                              //               FlatButton(
                              //                 child: Text('Tidak'),
                              //                 onPressed: () {
                              //                   Navigator.pop(context);
                              //                 },
                              //               ),
                              //               FlatButton(
                              //                 child: Text('Hapus'),
                              //                 onPressed: () {
                              //                   document.reference.delete();
                              //                   // firestore
                              //                   //     .collection(
                              //                   //         "alternatif")
                              //                   //     .document("Alternatif" +
                              //                   //         (index + 1)
                              //                   //             .toString())
                              //                   //     .delete();
                              //                   Navigator.pop(context);
                              //                   setState(() {});
                              //                   normalisasi();
                              //                 },
                              //               ),
                              //             ],
                              //           );
                              //         },
                              //       );
                              //     }
                              //   },
                              // ),
                              onTap: () => NavigateToDetail(
                                  document.data, index)
                            ),
                          );
                        });
                  },
                ),
              )
              //FutureBuilder(
              //     future: getPosts(),
              //     builder: (_, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       } else {
              //         return ListView.builder(
              //             padding: const EdgeInsets.only(
              //                 top: 20, bottom: 10, right: 10, left: 10),
              //             itemCount: snapshot.data.length,
              //             itemBuilder: (_, index) {
              //               return Card(
              //                 margin: new EdgeInsets.symmetric(
              //                     horizontal: 10.0, vertical: 8.0),
              //                 elevation: 4.0,
              //                 shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(50.0)),
              //                 child: ListTile(
              //                     title: Text(
              //                       snapshot
              //                           .data[index].data["nama_alternatif"],
              //                       style: TextStyle(
              //                           fontSize: 18,
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                     isThreeLine: false,
              //                     leading: Column(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.center,
              //                         children: <Widget>[
              //                           Container(
              //                             width: 40.0,
              //                             height: 40.0,
              //                             decoration: BoxDecoration(
              //                               color: Color(0xFF38C0D0),
              //                               shape: BoxShape.circle,
              //                             ),
              //                             child: Center(
              //                               child: Text(
              //                                 "A" +
              //                                     snapshot.data[index]
              //                                         .data["kode_alternatif"]
              //                                         .toString(),
              //                                 style: TextStyle(
              //                                     color: Colors.white,
              //                                     fontWeight: FontWeight.bold,
              //                                     fontSize: 20),
              //                               ),
              //                             ),
              //                           )
              //                         ]),
              //                     trailing: PopupMenuButton(
              //                       itemBuilder: (BuildContext context) {
              //                         return List<PopupMenuEntry<String>>()
              //                           ..add(PopupMenuItem<String>(
              //                             value: 'edit',
              //                             child: Text('Edit'),
              //                           ))
              //                           ..add(PopupMenuItem<String>(
              //                             value: 'delete',
              //                             child: Text('Hapus'),
              //                           ));
              //                       },
              //                       onSelected: (String value) async {
              //                         if (value == 'edit') {
              //                           bool result = await Navigator.push(
              //                             context,
              //                             MaterialPageRoute(builder: (context) {
              //                               return TambahAlternatif(
              //                                 isEdit: true,
              //                                 index: index,
              //                                 nama: snapshot.data[index]
              //                                     .data["nama_alternatif"],
              //                                 k0: snapshot.data[index]
              //                                     .data["prioritas"][0]
              //                                     .toString(),
              //                                 k1: snapshot.data[index]
              //                                     .data["kriteria"][1],
              //                                 k2: snapshot.data[index]
              //                                     .data["kriteria"][2],
              //                                 k3: snapshot.data[index]
              //                                     .data["kriteria"][3],
              //                                 k4: snapshot.data[index]
              //                                     .data["kriteria"][4],
              //                               );
              //                             }),
              //                           );
              //                           setState(() {});
              //                           normalisasi();
              //                         } else if (value == 'delete') {
              //                           showDialog(
              //                             context: context,
              //                             builder: (BuildContext context) {
              //                               return AlertDialog(
              //                                 title: Text('Hapus Alternatif'),
              //                                 content: Text(
              //                                     'Anda yakin ingin menghapus Alternatif ini?'),
              //                                 actions: <Widget>[
              //                                   FlatButton(
              //                                     child: Text('Tidak'),
              //                                     onPressed: () {
              //                                       Navigator.pop(context);
              //                                     },
              //                                   ),
              //                                   FlatButton(
              //                                     child: Text('Hapus'),
              //                                     onPressed: () {

              //                                       // firestore
              //                                       //     .collection(
              //                                       //         "alternatif")
              //                                       //     .document("Alternatif" +
              //                                       //         (index + 1)
              //                                       //             .toString())
              //                                       //     .delete();
              //                                       Navigator.pop(context);
              //                                       setState(() {});
              //                                       normalisasi();
              //                                     },
              //                                   ),
              //                                 ],
              //                               );
              //                             },
              //                           );
              //                         }
              //                       },
              //                     ),
              //                     onTap: () => NavigateToDetail(
              //                         snapshot.data[index], index)),
              //               );
              //             });
              //       }
              //     }))
              
        ],
      ),
      
    );
  }
}
