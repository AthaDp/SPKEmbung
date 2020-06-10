import 'package:flutter/material.dart';
import 'package:spkembung2/services/authentication.dart';
//pages
import 'package:spkembung2/halaman/kriteria.dart';
import 'package:spkembung2/halaman/Alternatif.dart';
import 'package:spkembung2/halaman/Hitung.dart';
import 'package:spkembung2/halaman/peta.dart';
import 'package:spkembung2/halaman/tentang.dart';
import 'package:spkembung2/root_page.dart';
import 'package:spkembung2/halaman/peringkat.dart';

class AppDrawer extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {
    Widget _createHeader() {
      return DrawerHeader(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
              image: DecorationImage(
                  //fit: BoxFit.fill,
                  image: AssetImage('assets/headerimage.png'))),
          child: Stack(children: <Widget>[
            Positioned(
                bottom: 12.0,
                left: 16.0,
                child: Text("Flutter Step-by-Step",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500))),
          ]));
    }

    Widget _createDrawerItem(
        {AssetImage icon, String text, GestureTapCallback onTap}) {
      return ListTile(
        title: Row(
          children: <Widget>[
            ImageIcon(icon),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(text),
            )
          ],
        ),
        onTap: onTap,
      );
    }

    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _createHeader(),
        _createDrawerItem(
            icon: AssetImage("assets/homeicons/Kriteria.png"),
            text: 'Kriteria',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => KriteriaPage()))),
        _createDrawerItem(
            icon: AssetImage("assets/homeicons/Alternatif.png"),
            text: 'Alternatif',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => AlternatifPage()))),
        _createDrawerItem(
            icon: AssetImage("assets/homeicons/Hitung.png"),
            text: 'Hitung',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => HitungPage()))),
        _createDrawerItem(
            icon: AssetImage("assets/homeicons/Peringkat.png"),
            text: 'Peringkat',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => PeringkatPage()))),
        _createDrawerItem(
            icon: AssetImage("assets/homeicons/Peta.png"),
            text: 'Peta',
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => PetaPage()))),
        _createDrawerItem(
            icon: AssetImage("assets/homeicons/Tentang.png"),
            text: 'Tentang',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => TentangPage()))),
        Divider(),
        _createDrawerItem(
            icon: AssetImage("assets/homeicons/Tentang.png"),
            text: 'Masuk Sebagai Admin',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RootPage(
                          auth: new Auth(),
                        )))
            //
            ),
        ListTile(
          title: Text('1.0'),
          onTap: () {
            
            //EMPTY
          },
        )
      ],
    ));
  }
}
