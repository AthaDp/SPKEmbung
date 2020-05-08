import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:spkembung2/models/models.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<Alternatif> streamAlternatif(String id){
    return _db
      .collection('alternatif')
      .document(id)
      .snapshots()
      .map((snap) => Alternatif.fromMap(snap.data));
  }
}