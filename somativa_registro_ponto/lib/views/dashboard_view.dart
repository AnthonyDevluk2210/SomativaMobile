import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const kBackgroundBlack = Color(0xFF121212);
const kDarkGray = Color(0xFF1E1E1E);
const kMediumGray = Color(0xFF3A3A3A);
const kDarkOrange = Color(0xFFFF5722);

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final registros = FirebaseFirestore.instance
        .collection('registros')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      backgroundColor: kBackgroundBlack,
      appBar: AppBar(
        title: const Text("Painel de Registros"),
        backgroundColor: kDarkGray,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: registros,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: kDarkOrange));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum registro encontrado.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final nome = data['nome'] ?? 'Usuário Desconhecido';
              final userId = data['userId'] ?? '-';
              final timestamp = (data['timestamp'] as Timestamp?)?.toDate();

              return Card(
                color: kDarkGray,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.person, color: kDarkOrange),
                  title: Text(
                    nome,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    timestamp != null
                        ? '${timestamp.day.toString().padLeft(2, '0')}/'
                          '${timestamp.month.toString().padLeft(2, '0')}/'
                          '${timestamp.year}  '
                          '${timestamp.hour.toString().padLeft(2, '0')}:'
                          '${timestamp.minute.toString().padLeft(2, '0')}'
                        : 'Sem data registrada',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    userId.substring(0, 5), // mostra parte do ID do usuário
                    style: const TextStyle(color: kMediumGray, fontSize: 12),
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
