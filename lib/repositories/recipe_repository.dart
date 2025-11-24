import '../models/recipe_model.dart';
import '../services/api_service.dart';

/// Repository de Receitas
/// Isola a lógica de receitas da API
class RecipeRepository {
  /// Buscar todas as receitas
  Future<List<RecipeModel>> getAllRecipes({String? token}) async {
    try {
      final response = await ApiService.get('/recipes', token: token);
      
      final List<dynamic> recipesJson = response['recipes'] ?? response;
      return recipesJson.map((json) => RecipeModel.fromJson(json)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao buscar receitas: $e');
    }
  }

  /// Buscar receitas por categoria
  Future<List<RecipeModel>> getRecipesByCategory(
    String category, {
    String? token,
  }) async {
    try {
      final response = await ApiService.get(
        '/recipes?category=$category',
        token: token,
      );
      
      final List<dynamic> recipesJson = response['recipes'] ?? response;
      return recipesJson.map((json) => RecipeModel.fromJson(json)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao buscar receitas: $e');
    }
  }

  /// Buscar receitas (com busca por texto)
  Future<List<RecipeModel>> searchRecipes(
    String query, {
    String? token,
  }) async {
    try {
      final response = await ApiService.get(
        '/recipes/search?q=$query',
        token: token,
      );
      
      final List<dynamic> recipesJson = response['recipes'] ?? response;
      return recipesJson.map((json) => RecipeModel.fromJson(json)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao buscar receitas: $e');
    }
  }

  /// Buscar detalhes de uma receita
  Future<RecipeModel> getRecipeById(String id, {String? token}) async {
    try {
      final response = await ApiService.get('/recipes/$id', token: token);
      
      return RecipeModel.fromJson(response['recipe'] ?? response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao buscar receita: $e');
    }
  }

  /// Criar nova receita
  Future<RecipeModel> createRecipe({
    required String title,
    required String description,
    required String imageUrl,
    required String time,
    required String category,
    required List<String> ingredients,
    required List<String> instructions,
    required String token,
  }) async {
    try {
      final response = await ApiService.post(
        '/recipes',
        body: {
          'title': title,
          'description': description,
          'imageUrl': imageUrl,
          'time': time,
          'category': category,
          'ingredients': ingredients,
          'instructions': instructions,
        },
        token: token,
      );
      
      return RecipeModel.fromJson(response['recipe'] ?? response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao criar receita: $e');
    }
  }

  /// Atualizar receita
  Future<RecipeModel> updateRecipe({
    required String id,
    String? title,
    String? description,
    String? imageUrl,
    String? time,
    String? category,
    List<String>? ingredients,
    List<String>? instructions,
    required String token,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (imageUrl != null) body['imageUrl'] = imageUrl;
      if (time != null) body['time'] = time;
      if (category != null) body['category'] = category;
      if (ingredients != null) body['ingredients'] = ingredients;
      if (instructions != null) body['instructions'] = instructions;

      final response = await ApiService.put(
        '/recipes/$id',
        body: body,
        token: token,
      );
      
      return RecipeModel.fromJson(response['recipe'] ?? response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao atualizar receita: $e');
    }
  }

  /// Deletar receita
  Future<void> deleteRecipe(String id, {required String token}) async {
    try {
      await ApiService.delete('/recipes/$id', token: token);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao deletar receita: $e');
    }
  }

  /// Buscar receitas favoritas do usuário
  Future<List<RecipeModel>> getFavoriteRecipes({required String token}) async {
    try {
      final response = await ApiService.get('/recipes/favorites', token: token);
      
      final List<dynamic> recipesJson = response['recipes'] ?? response;
      return recipesJson.map((json) => RecipeModel.fromJson(json)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao buscar favoritos: $e');
    }
  }

  /// Adicionar receita aos favoritos
  Future<void> addToFavorites(String recipeId, {required String token}) async {
    try {
      await ApiService.post(
        '/recipes/$recipeId/favorite',
        body: {},
        token: token,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao adicionar aos favoritos: $e');
    }
  }

  /// Remover receita dos favoritos
  Future<void> removeFromFavorites(String recipeId, {required String token}) async {
    try {
      await ApiService.delete(
        '/recipes/$recipeId/favorite',
        token: token,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao remover dos favoritos: $e');
    }
  }

  // ========== MÉTODOS USANDO THEMEALDB (PARA TESTES) ==========

  /// Buscar receitas da TheMealDB
  Future<List<RecipeModel>> searchRecipesMealDB(String query) async {
    try {
      final recipes = await ApiService.searchRecipesMealDB(query);
      return recipes.map((json) => RecipeModel.fromJson(json)).toList();
    } catch (e) {
      throw ApiException('Erro ao buscar receitas: $e');
    }
  }

  /// Buscar receitas por categoria da TheMealDB
  Future<List<RecipeModel>> getRecipesByCategoryMealDB(String category) async {
    try {
      final recipes = await ApiService.getRecipesByCategory(category);
      return recipes.map((json) => RecipeModel.fromJson(json)).toList();
    } catch (e) {
      throw ApiException('Erro ao buscar receitas: $e');
    }
  }

  /// Buscar detalhes de receita da TheMealDB
  Future<RecipeModel?> getRecipeDetailsMealDB(String id) async {
    try {
      final recipe = await ApiService.getRecipeDetails(id);
      return recipe != null ? RecipeModel.fromJson(recipe) : null;
    } catch (e) {
      throw ApiException('Erro ao buscar detalhes: $e');
    }
  }
}
