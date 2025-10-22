import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:somativa_registro_ponto/models/registro.dart';

class RegistroFirestoreController {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<List<Registro>> getRegistrosStream() {
    return _db
        .collection('registros')
        .where('userId', isEqualTo: currentUser?.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Registro.fromFirestore(doc))
              .toList()
              .cast<Registro>(),
        );
  }

  void addRegistro(Map<String, dynamic> registroData) async {
    //criar um OBJ
    final registro = Registro(
      id: registroData["id"],
      userId: registroData["userId"],
      nome: registroData["nome"],
      timestamp: registroData["timestamp"],
    );
    await _db
        .collection('registros')
        .doc(currentUser!.uid)
        .collection("registros_nv")
        .doc(registro.id.toString())
        .set(registro.toMap());
  }

  void updateRegistro(int registroId, double novoValor) async {
    if (currentUser == null) return;
    await _db
        .collection("registros")
        .doc(currentUser!.uid)
        .collection("registros_nv");
  }
}
