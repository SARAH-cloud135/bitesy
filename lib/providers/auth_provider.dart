import 'package:flutter/material.dart';

// Modelo de usuário
class User {
  final String id;
  final String nome;
  final String email;
  final String? telefone;

  User({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
  });
}

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;

  // Getters
  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  // Método de LOGIN - ACEITA EMAIL E SENHA
  Future<bool> login(String email, String senha) async {
    try {
      // Simula chamada de API
      await Future.delayed(const Duration(seconds: 1));

      // Simulação: qualquer email/senha válida é aceita
      if (email.isNotEmpty && senha.length >= 6) {
        _user = User(
          id: '1',
          nome: email.split('@')[0], // Pega o nome do email
          email: email,
          telefone: null,
        );
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      print('Erro no login: $e');
      return false;
    }
  }

  // Método de REGISTRO
  Future<bool> register({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    try {
      // Simula chamada de API
      await Future.delayed(const Duration(seconds: 1));

      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nome: nome,
        email: email,
        telefone: telefone,
      );
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      print('Erro no registro: $e');
      return false;
    }
  }

  // Método de LOGOUT
  void logout() {
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // Atualizar perfil do usuário
  void updateUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}