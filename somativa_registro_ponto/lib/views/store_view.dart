import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoreView extends StatelessWidget {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // ✅ A verificação precisa estar dentro de um Scaffold para não quebrar o layout
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Últimas Marcações')),
        body: const Center(child: Text('Usuário não autenticado.')),
      );
    }

    // 🔹 Stream com os últimos registros
    final registros = FirebaseFirestore.instance
        .collection('registros')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Últimas Marcações'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: registros,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhuma marcação encontrada.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final d = docs[index].data() as Map<String, dynamic>;
              final nome = d['nome'] ?? 'Sem nome';
              final timestamp = (d['timestamp'] as Timestamp).toDate();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.access_time, color: Colors.blue),
                  title: Text(
                    nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${timestamp.day.toString().padLeft(2, '0')}/'
                    '${timestamp.month.toString().padLeft(2, '0')}/'
                    '${timestamp.year}  '
                    '${timestamp.hour.toString().padLeft(2, '0')}:'
                    '${timestamp.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
