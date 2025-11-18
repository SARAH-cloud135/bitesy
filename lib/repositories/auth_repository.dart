import '../models/user_model.dart';
import '../services/api_service.dart';

/// Repository de Autenticação
/// Isola a lógica de autenticação da API
class AuthRepository {
  /// Fazer login
  Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    try {
      // Chamar API de login
      final response = await ApiService.post(
        '/auth/login',
        body: {
          'email': email,
          'password': senha,
        },
      );

      // Retornar token e usuário
      return {
        'token': response['token'],
        'user': UserModel.fromJson(response['user']),
      };
    } on ApiException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException('Erro ao fazer login: $e');
    }
  }

  /// Fazer cadastro
  Future<Map<String, dynamic>> register({
    required String nome,
    required String email,
    required String senha,
    String? telefone,
  }) async {
    try {
      // Chamar API de cadastro
      final response = await ApiService.post(
        '/auth/register',
        body: {
          'nome': nome,
          'email': email,
          'password': senha,
          'telefone': telefone,
        },
      );

      // Retornar token e usuário
      return {
        'token': response['token'],
        'user': UserModel.fromJson(response['user']),
      };
    } on ApiException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException('Erro ao fazer cadastro: $e');
    }
  }

  /// Fazer logout
  Future<void> logout(String token) async {
    try {
      await ApiService.post(
        '/auth/logout',
        body: {},
        token: token,
      );
    } catch (e) {
      // Ignorar erros de logout
      print('Erro ao fazer logout: $e');
    }
  }

  /// Recuperar senha
  Future<void> recoverPassword(String email) async {
    try {
      await ApiService.post(
        '/auth/recover-password',
        body: {'email': email},
      );
    } on ApiException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException('Erro ao recuperar senha: $e');
    }
  }

  /// Verificar se o token é válido
  Future<UserModel> validateToken(String token) async {
    try {
      final response = await ApiService.get(
        '/auth/me',
        token: token,
      );

      return UserModel.fromJson(response['user']);
    } on ApiException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException('Token inválido');
    }
  }

  /// Atualizar perfil do usuário
  Future<UserModel> updateProfile({
    required String token,
    String? nome,
    String? telefone,
    String? avatarUrl,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (nome != null) body['nome'] = nome;
      if (telefone != null) body['telefone'] = telefone;
      if (avatarUrl != null) body['avatarUrl'] = avatarUrl;

      final response = await ApiService.put(
        '/auth/profile',
        body: body,
        token: token,
      );

      return UserModel.fromJson(response['user']);
    } on ApiException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException('Erro ao atualizar perfil: $e');
    }
  }
}

/// Exceção de autenticação
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}
