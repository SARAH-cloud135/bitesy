import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../repositories/recipe_repository.dart';
import '../services/api_service.dart';

/// Provider de Receitas
/// Gerencia o estado das receitas do aplicativo
class RecipeProvider with ChangeNotifier {
  final RecipeRepository _recipeRepository = RecipeRepository();
  
  List<RecipeModel> _recipes = [];
  List<RecipeModel> _favoriteRecipes = [];
  bool _isLoading = false;
  String? _error;
  
  List<RecipeModel> get recipes => _recipes;
  List<RecipeModel> get favoriteRecipes => _favoriteRecipes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// Buscar todas as receitas
  Future<void> fetchRecipes({String? token}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _recipes = await _recipeRepository.getAllRecipes(token: token);
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao buscar receitas: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Buscar receitas por categoria
  Future<void> fetchRecipesByCategory(String category, {String? token}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _recipes = await _recipeRepository.getRecipesByCategory(
        category,
        token: token,
      );
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao buscar receitas: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Buscar receitas (pesquisa)
  Future<void> searchRecipes(String query, {String? token}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _recipes = await _recipeRepository.searchRecipes(query, token: token);
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao buscar receitas: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Criar nova receita
  Future<bool> createRecipe({
    required String title,
    required String description,
    required String imageUrl,
    required String time,
    required String category,
    required List<String> ingredients,
    required List<String> instructions,
    required String token,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final newRecipe = await _recipeRepository.createRecipe(
        title: title,
        description: description,
        imageUrl: imageUrl,
        time: time,
        category: category,
        ingredients: ingredients,
        instructions: instructions,
        token: token,
      );
      
      _recipes.insert(0, newRecipe);
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Erro ao criar receita: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Atualizar receita
  Future<bool> updateRecipe({
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
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final updatedRecipe = await _recipeRepository.updateRecipe(
        id: id,
        title: title,
        description: description,
        imageUrl: imageUrl,
        time: time,
        category: category,
        ingredients: ingredients,
        instructions: instructions,
        token: token,
      );
      
      final index = _recipes.indexWhere((r) => r.id == id);
      if (index != -1) {
        _recipes[index] = updatedRecipe;
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Erro ao atualizar receita: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Deletar receita
  Future<bool> deleteRecipe(String id, {required String token}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _recipeRepository.deleteRecipe(id, token: token);
      _recipes.removeWhere((r) => r.id == id);
      _favoriteRecipes.removeWhere((r) => r.id == id);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Erro ao deletar receita: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Buscar receitas favoritas
  Future<void> fetchFavoriteRecipes({required String token}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _favoriteRecipes = await _recipeRepository.getFavoriteRecipes(token: token);
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao buscar favoritos: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Adicionar aos favoritos
  Future<bool> addToFavorites(String recipeId, {required String token}) async {
    try {
      await _recipeRepository.addToFavorites(recipeId, token: token);
      
      // Atualizar localmente
      final recipe = _recipes.firstWhere((r) => r.id == recipeId);
      final updatedRecipe = recipe.copyWith(isFavorite: true);
      
      final index = _recipes.indexWhere((r) => r.id == recipeId);
      if (index != -1) {
        _recipes[index] = updatedRecipe;
      }
      
      if (!_favoriteRecipes.any((r) => r.id == recipeId)) {
        _favoriteRecipes.add(updatedRecipe);
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erro ao adicionar aos favoritos: $e';
      notifyListeners();
      return false;
    }
  }
  
  /// Remover dos favoritos
  Future<bool> removeFromFavorites(String recipeId, {required String token}) async {
    try {
      await _recipeRepository.removeFromFavorites(recipeId, token: token);
      
      // Atualizar localmente
      final recipe = _recipes.firstWhere((r) => r.id == recipeId);
      final updatedRecipe = recipe.copyWith(isFavorite: false);
      
      final index = _recipes.indexWhere((r) => r.id == recipeId);
      if (index != -1) {
        _recipes[index] = updatedRecipe;
      }
      
      _favoriteRecipes.removeWhere((r) => r.id == recipeId);
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erro ao remover dos favoritos: $e';
      notifyListeners();
      return false;
    }
  }
  
  /// Alternar favorito
  Future<bool> toggleFavorite(String recipeId, {required String token}) async {
    final recipe = _recipes.firstWhere((r) => r.id == recipeId);
    
    if (recipe.isFavorite) {
      return await removeFromFavorites(recipeId, token: token);
    } else {
      return await addToFavorites(recipeId, token: token);
    }
  }
  
  // ========== MÉTODOS USANDO THEMEALDB (PARA TESTES) ==========
  
  /// Buscar receitas da TheMealDB
  Future<void> searchRecipesMealDB(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _recipes = await _recipeRepository.searchRecipesMealDB(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao buscar receitas: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Buscar receitas por categoria da TheMealDB
  Future<void> fetchRecipesByCategoryMealDB(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _recipes = await _recipeRepository.getRecipesByCategoryMealDB(category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao buscar receitas: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Limpar erro
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  /// Limpar receitas
  void clearRecipes() {
    _recipes = [];
    notifyListeners();
  }
}
