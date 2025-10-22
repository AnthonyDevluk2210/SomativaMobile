import 'package:somativa_registro_ponto/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Paleta de Cores
const Color kBackgroundBlack = Color(0xFF121212);
const Color kDarkGray = Color(0xFF1E1E1E);
const Color kMediumGray = Color(0xFF3A3A3A);
const Color kRed = Color(0xFFD32F2F);
const Color kDarkOrange = Color(0xFFFF5722);

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailField = TextEditingController();
  final _senhaField = TextEditingController();
  final _authController = FirebaseAuth.instance;
  bool _senhaOculta = true;

  void _login() async {
    final email = _emailField.text.trim();
    final senha = _senhaField.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    try {
      await _authController.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      // StreamBuilder cuida da navegação
    } on FirebaseAuthException catch (e) {
      String mensagemErro;
      switch (e.code) {
        case 'user-not-found':
          mensagemErro = 'Usuário não encontrado.';
          break;
        case 'wrong-password':
          mensagemErro = 'Senha incorreta.';
          break;
        case 'invalid-email':
          mensagemErro = 'Email inválido.';
          break;
        default:
          mensagemErro = 'Erro: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagemErro)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundBlack,
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: kDarkGray,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 50),
            TextField(
              controller: _emailField,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: kMediumGray),
                filled: true,
                fillColor: kDarkGray,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _senhaField,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(color: kMediumGray),
                filled: true,
                fillColor: kDarkGray,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _senhaOculta ? Icons.visibility : Icons.visibility_off,
                    color: kMediumGray,
                  ),
                  onPressed: () {
                    setState(() {
                      _senhaOculta = !_senhaOculta;
                    });
                  },
                ),
              ),
              obscureText: _senhaOculta,
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkOrange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text("Login"),
              ),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterView()),
                );
              },
              child: Text(
                "Não tem uma conta? Registre-se",
                style: TextStyle(color: kDarkOrange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
