import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// 🎨 Paleta de Cores
const kBackgroundBlack = Color(0xFF121212);
const kDarkGray = Color(0xFF1E1E1E);
const kMediumGray = Color(0xFF3A3A3A);
const kDarkOrange = Color(0xFFFF5722);

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _confirmar = TextEditingController();
  bool _mostrarSenha = false;
  bool _mostrarConfirma = false;

  final _auth = FirebaseAuth.instance;

  Future<void> _registrar() async {
    final email = _email.text.trim();
    final senha = _senha.text;
    final confirma = _confirmar.text;

    if (email.isEmpty || senha.isEmpty || confirma.isEmpty) {
      _msg("Preencha todos os campos");
      return;
    }
    if (senha != confirma) {
      _msg("As senhas não coincidem");
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      _msg("Usuário registrado com sucesso!");
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      _msg(_traduzErro(e.code));
    }
  }

  String _traduzErro(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Este email já está em uso.';
      case 'invalid-email':
        return 'Email inválido.';
      case 'weak-password':
        return 'A senha é muito fraca.';
      default:
        return 'Erro ao registrar. Tente novamente.';
    }
  }

  void _msg(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundBlack,
      appBar: AppBar(
        title: const Text("Registrar"),
        backgroundColor: kDarkGray,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _campo("Email", _email, TextInputType.emailAddress),
            const SizedBox(height: 12),
            _campoSenha("Senha", _senha, _mostrarSenha, () {
              setState(() => _mostrarSenha = !_mostrarSenha);
            }),
            const SizedBox(height: 12),
            _campoSenha("Confirmar Senha", _confirmar, _mostrarConfirma, () {
              setState(() => _mostrarConfirma = !_mostrarConfirma);
            }),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkOrange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Registrar", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Campos reutilizáveis
  Widget _campo(String label, TextEditingController ctrl, TextInputType tipo) {
    return TextField(
      controller: ctrl,
      keyboardType: tipo,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kMediumGray),
        filled: true,
        fillColor: kDarkGray,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _campoSenha(
      String label, TextEditingController ctrl, bool visivel, VoidCallback toggle) {
    return TextField(
      controller: ctrl,
      obscureText: !visivel,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kMediumGray),
        filled: true,
        fillColor: kDarkGray,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            visivel ? Icons.visibility : Icons.visibility_off,
            color: kMediumGray,
          ),
          onPressed: toggle,
        ),
      ),
    );
  }
}
