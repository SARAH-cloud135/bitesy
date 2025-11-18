import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Serviço de comunicação com API
class ApiService {
  // URL base da API (altere para sua API real)
  static const String baseUrl = 'https://sua-api.com/api';
  
  // URL da API pública TheMealDB (para testes)
  static const String mealDbUrl = 'https://www.themealdb.com/api/json/v1/1';
  
  // Timeout padrão
  static const Duration timeout = Duration(seconds: 30);
  
  // Headers padrão
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Headers com autenticação (adicione token quando implementar)
  static Map<String, String> _headersWithAuth(String? token) {
    final headers = Map<String, String>.from(_headers);
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// GET - Buscar dados
  static Future<dynamic> get(String endpoint, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('GET: $url');
      
      final response = await http
          .get(url, headers: _headersWithAuth(token))
          .timeout(timeout);
      
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    } on http.ClientException {
      throw ApiException('Erro de conexão com o servidor');
    } on TimeoutException {
      throw ApiException('Tempo de resposta excedido');
    } catch (e) {
      throw ApiException('Erro inesperado: $e');
    }
  }

  /// POST - Criar dados
  static Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('POST: $url');
      print('Body: ${json.encode(body)}');
      
      final response = await http
          .post(
            url,
            headers: _headersWithAuth(token),
            body: json.encode(body),
          )
          .timeout(timeout);
      
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    } on http.ClientException {
      throw ApiException('Erro de conexão com o servidor');
    } on TimeoutException {
      throw ApiException('Tempo de resposta excedido');
    } catch (e) {
      throw ApiException('Erro inesperado: $e');
    }
  }

  /// PUT - Atualizar dados
  static Future<dynamic> put(
    String endpoint, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('PUT: $url');
      print('Body: ${json.encode(body)}');
      
      final response = await http
          .put(
            url,
            headers: _headersWithAuth(token),
            body: json.encode(body),
          )
          .timeout(timeout);
      
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    } on http.ClientException {
      throw ApiException('Erro de conexão com o servidor');
    } on TimeoutException {
      throw ApiException('Tempo de resposta excedido');
    } catch (e) {
      throw ApiException('Erro inesperado: $e');
    }
  }

  /// DELETE - Deletar dados
  static Future<dynamic> delete(String endpoint, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('DELETE: $url');
      
      final response = await http
          .delete(url, headers: _headersWithAuth(token))
          .timeout(timeout);
      
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    } on http.ClientException {
      throw ApiException('Erro de conexão com o servidor');
    } on TimeoutException {
      throw ApiException('Tempo de resposta excedido');
    } catch (e) {
      throw ApiException('Erro inesperado: $e');
    }
  }

  /// Tratar resposta da API
  static dynamic _handleResponse(http.Response response) {
    print('Status: ${response.statusCode}');
    print('Response: ${response.body}');
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Sucesso (2xx)
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else if (response.statusCode == 400) {
      // Bad Request
      throw ApiException('Requisição inválida');
    } else if (response.statusCode == 401) {
      // Unauthorized
      throw ApiException('Não autorizado. Faça login novamente.');
    } else if (response.statusCode == 403) {
      // Forbidden
      throw ApiException('Acesso negado');
    } else if (response.statusCode == 404) {
      // Not Found
      throw ApiException('Recurso não encontrado');
    } else if (response.statusCode == 422) {
      // Unprocessable Entity (validação)
      final data = json.decode(response.body);
      final message = data['message'] ?? 'Dados inválidos';
      throw ApiException(message);
    } else if (response.statusCode >= 500) {
      // Server Error
      throw ApiException('Erro no servidor. Tente novamente mais tarde.');
    } else {
      throw ApiException('Erro desconhecido: ${response.statusCode}');
    }
  }

  // ========== MÉTODOS ESPECÍFICOS ==========

  /// Buscar receitas da TheMealDB (para testes)
  static Future<List<dynamic>> searchRecipesMealDB(String query) async {
    try {
      final url = Uri.parse('$mealDbUrl/search.php?s=$query');
      final response = await http.get(url).timeout(timeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['meals'] ?? [];
      }
      throw ApiException('Erro ao buscar receitas');
    } catch (e) {
      throw ApiException('Erro ao buscar receitas: $e');
    }
  }

  /// Buscar receitas por categoria da TheMealDB
  static Future<List<dynamic>> getRecipesByCategory(String category) async {
    try {
      final url = Uri.parse('$mealDbUrl/filter.php?c=$category');
      final response = await http.get(url).timeout(timeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['meals'] ?? [];
      }
      throw ApiException('Erro ao buscar receitas');
    } catch (e) {
      throw ApiException('Erro ao buscar receitas: $e');
    }
  }

  /// Buscar detalhes de uma receita da TheMealDB
  static Future<Map<String, dynamic>?> getRecipeDetails(String id) async {
    try {
      final url = Uri.parse('$mealDbUrl/lookup.php?i=$id');
      final response = await http.get(url).timeout(timeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meals = data['meals'] as List?;
        return meals?.isNotEmpty == true ? meals!.first : null;
      }
      throw ApiException('Erro ao buscar detalhes da receita');
    } catch (e) {
      throw ApiException('Erro ao buscar detalhes: $e');
    }
  }
}

/// Exceção personalizada para erros de API
class ApiException implements Exception {
  final String message;
  
  ApiException(this.message);
  
  @override
  String toString() => message;
}

/// Classe para timeout
class TimeoutException implements Exception {
  final String message;
  
  TimeoutException([this.message = 'Timeout']);
  
  @override
  String toString() => message;
}
