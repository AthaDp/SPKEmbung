import 'package:flutter/material.dart';

class KriteriaCard extends StatelessWidget {
  KriteriaCard(
      {@required this.bobot,
      this.keterangan,
      this.nama,
      this.kode,
      this.nilai,
      this.id});

  final bobot; //int
  final nama;
  final keterangan;
  final kode;
  final nilai; //int
  final id; //int

  @override
  Widget build(BuildContext context) {
    final card = ListTile(
        //contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 2.0, color: Colors.black12))),
          child: Text(kode,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
        ),
        title: Text(
          nama,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.black)),

        subtitle: Row(
          children: <Widget>[
            //Icon(Icons.linear_scale, color: Colors.yellowAccent),
            //Text(" Intermediate", style: TextStyle(color: Colors.black))
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0));

    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Container(
          padding:
              const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 30, left: 30),
          child: card,

          /*
            Column(
              children: <Widget>[
                new Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                Text(nama, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),),
                Text("Keterangan: " + keterangan, style: TextStyle(fontSize: 16),),
                SizedBox(height: 20),
                  ]
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Bobot: "+bobot.toString()),
                    SizedBox(width: 10),
                    Text("Kode: "+kode.toString()),
                    SizedBox(width: 10),
                    Text("ID: "+id.toString()),
                  ],
                ),
              ],
            )*/
        ));
  }
}
