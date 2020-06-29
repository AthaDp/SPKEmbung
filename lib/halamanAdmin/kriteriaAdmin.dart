import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:spkembung2/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spkembung2/widgets/drawer.dart';

import 'package:spkembung2/halaman/tambahKriteria.dart';

class KriteriaAdminPage extends StatefulWidget {
  KriteriaAdminPage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<KriteriaAdminPage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  int flag = 0;
  var list;
  var random;
  String keteranganKriteria;
  String pilihan;

  @override
  void initState() {
    //getKriteria();
    print("flag");
    print(flag);
    super.initState();
  }

  // Future getKriteria() async {
  //   QuerySnapshot getAlt = await Firestore.instance
  //       .collection("kriteria")
  //       .orderBy("id")
  //       .getDocuments();

  //   return getAlt.documents;
  // }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Widget showErrorMessage(int a) {
    print("errpr");
    print(a);
    if(a == 1){
      return new Text(
        "Nilai Total Bobot Melebihi 1!",
        style: TextStyle(
            fontSize: 14.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else if(a == 2) {
     return new Text(
        "Nilai Total Bobot Dibawah 0!",
        style: TextStyle(
            fontSize: 14.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
       return new Container(
        height: 0.0,
      );
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

  TextEditingController bobotController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        bottomOpacity: 0.0,
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(),
      backgroundColor: Color(0xFF38C0D0),
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
              height: MediaQuery.of(context).size.height - 200.0,
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
                          subtitle:
                              Text("Keterangan: " + alternatif["keterangan"] //+
                                  //", Bobot: " +
                                  //alternatif["bobot_kriteria"].toString()
                                  ),
                          isThreeLine: false,
                          trailing: PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return List<PopupMenuEntry<String>>()
                                ..add(PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ));
                            },
                            onSelected: (String value) async {
                              flag = 0;
                              bobotController.text =
                                  alternatif['bobot_kriteria'].toString();
                              if (alternatif['keterangan'] == "Biaya") {
                                keteranganKriteria = 'Biaya';
                                pilihan = "Biaya";
                              } else if (alternatif['keterangan'] ==
                                  "Keuntungan") {
                                keteranganKriteria = 'Keuntungan';
                                pilihan = "Keuntungan";
                              }

                              if (value == 'edit') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                      title: Text('Edit Kriteria'),
                                      content: Container(
                                        height: 150.0,
                                        width: 400.0,
                                        child: Column(
                                          children: <Widget>[
                                            TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: bobotController,
                                              decoration: InputDecoration(
                                                labelText: 'Bobot',
                                              ),
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                            DropdownButtonFormField(
                                              hint: Text("Keterangan Kriteria"),
                                              value: keteranganKriteria,
                                              onChanged: (String value) {
                                                if (value == 'Keuntungan') {
                                                  setState(() {
                                                    pilihan = "Keuntungan";
                                                  });
                                                }
                                                if (value == 'Biaya') {
                                                  setState(() {
                                                    pilihan = "Biaya";
                                                  });
                                                }
                                              },
                                              items: [
                                                DropdownMenuItem<String>(
                                                    child: Text('Keuntungan'),
                                                    value: 'Keuntungan'),
                                                DropdownMenuItem<String>(
                                                    child: Text('Biaya'),
                                                    value: 'Biaya'),
                                              ],
                                            ),
                                            Container(
                                              height: 25.0,
                                            ),
                                              showErrorMessage(flag),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Batal'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('Ubah'),
                                          onPressed: () async {
                                            //print(pilihan);
                                            //List<double> bobotSum = new List<double>();
                                            QuerySnapshot getKri =
                                                await Firestore.instance
                                                    .collection("kriteria")
                                                    .orderBy("kode_kriteria")
                                                    .getDocuments();
                                            List<double> bobotSum = [];
                                            for (int a = 0;
                                                a < getKri.documents.length;
                                                a++) {
                                              double bobot = getKri.documents[a]
                                                  .data['bobot_kriteria'];
                                              bobotSum.add(bobot);
                                            }
                                            //print(bobotSum.toString());
                                            double sum = bobotSum.fold(
                                                0,
                                                (previous, current) =>
                                                    previous + current);
                                            print(alternatif["bobot_kriteria"]
                                                .toString());
                                            sum = sum -
                                                alternatif["bobot_kriteria"];
                                            sum = sum +
                                                double.parse(
                                                    bobotController.text);
                                                    print(flag);
                                                    
                                            //print(sum.toString());

                                            if (sum < 1 && sum >= 0) {
                                              CollectionReference tasks =
                                                  Firestore.instance
                                                      .collection('kriteria');
                                              await tasks
                                                  .document(document.documentID)
                                                  .updateData({
                                                'bobot_kriteria': double.parse(
                                                    bobotController.text),
                                                'keterangan': pilihan,
                                              });
                                              setState(() {});
                                              Navigator.pop(context);
                                            
                                            //normalisasi();
                                            } else if(sum <0){
                                              setState(() {flag =2;});
                                            } else {
                                              setState(() {flag =1;});
                                            }

                                            //print(keteranganKriteria);
                                            //document.reference.delete();
                                            // firestore
                                            //     .collection(
                                            //         "alternatif")
                                            //     .document("Alternatif" +
                                            //         (index + 1)
                                            //             .toString())
                                            //     .delete();
                                            //Navigator.pop(context);
                                            
                                            //normalisasi();
                                          },
                                        ),
                                      ],
                                    );
                                      }
                                    );
                                    
                                  },
                                );
                              }
                            },
                          ),
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
      // floatingActionButton: FloatingActionButton(
      //   //onPressed: _showDialog,
      //   tooltip: 'Tambah Kriteria Baru',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
