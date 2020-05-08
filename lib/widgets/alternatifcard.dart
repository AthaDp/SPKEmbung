import 'package:flutter/material.dart';

class AlternatifCard extends StatelessWidget {
  AlternatifCard({@required this.nama, this.kode, this.kriteria});

  final nama;
  final kode;
  final kriteria;
  //final id; //int

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
        ));
  }
}
