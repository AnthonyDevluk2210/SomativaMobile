import 'package:cloud_firestore/cloud_firestore.dart';

class Registro {
    final int id;
    final String userId;
    final String nome;
    final DateTime timestamp;

    Registro({
        required this.id,
        required this.userId,
        required this.nome,
        required this.timestamp,
    });

    Map<String, dynamic> toMap() {
        return {
            "id": id,
            "userId": userId,
            "nome": nome,
            "timestamp": timestamp.toIso8601String(),
        };
    }

    factory Registro.fromMap(Map<String, dynamic> map) {
        return Registro(
            id: map["id"],
            userId: map["userId"],
            nome: map["nome"],
            timestamp: DateTime.parse(map["timestamp"]),
        );
    }

  static fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {}
}