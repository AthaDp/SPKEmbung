import 'package:flutter/material.dart';
import 'home.dart';

//halaman
import 'package:spkembung2/halaman/kriteria.dart';
import 'package:spkembung2/halaman/peringkat.dart';
import 'package:spkembung2/halaman/preferensi.dart';
import 'package:spkembung2/halaman/normalisasi.dart';
import 'package:spkembung2/halaman/Alternatif.dart';
import 'package:spkembung2/halamanAdmin/AlternatifAdmin.dart';
import 'package:spkembung2/halamanAdmin/KriteriaAdmin.dart';
import 'package:spkembung2/halaman/hitung.dart';
import 'package:spkembung2/halaman/peta.dart';
import 'package:spkembung2/halaman/tentang.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        routes: {
          'kriteria' : (context)=> KriteriaPage(),
          'kriteriaAdmin' : (context)=> KriteriaAdminPage(),
          'alternatif' : (context)=> AlternatifPage(),
          'alternatifAdmin' : (context)=> AlternatifAdminPage(),
          'hitung' : (context)=> HitungPage(),
          'peringkat' : (context)=> PeringkatPage(),
          'peta' : (context)=> PetaPage(),
          'tentang' : (context)=> TentangPage(),
          'normalisasi' : (context)=> NormalisasiPage(),
          'preferensi' : (context)=> PreferensiPage(),
        },
        title: 'SPK Embung',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primaryColor: Color(0xFF21BFBD),
        ),
        home: new HomePage());
    //home: new RootPage(auth: new Auth()));
  }
}
