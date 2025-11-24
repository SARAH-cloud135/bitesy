import 'package:flutter/material.dart';
import '../models/recipe_model.dart';

class RecipeProvider extends ChangeNotifier {
//Define a classe RecipeProvider.Ela estende (extends) ChangeNotifier, o que permite:guardar dados,mudar os dados,avisar a interface quando algo mudou (notifyListeners()).

  final List<RecipeModel> _recipes = [
    RecipeModel(
      id: '1',
      title: 'Bolo de Chocolate',
      description: 'Um delicioso bolo de chocolate caseiro',
      category: 'Doces',
      time: '45 min',
      imageUrl: '🍰',
      authorName: 'CookEasy',
      ingredients: ['2 xícaras de farinha', '1 xícara de açúcar', '3 ovos', 'Chocolate em pó'],
      instructions: ['Misture os ingredientes secos', 'Adicione os ovos', 'Asse por 40 minutos'],
    ),
    RecipeModel(
      id: '2',
      title: 'Lasanha Bolonhesa',
      description: 'Lasanha tradicional italiana',
      category: 'Massas',
      time: '60 min',
      imageUrl: '🍝',
      authorName: 'CookEasy',
      ingredients: ['500g massa para lasanha', '500g carne moída', 'Molho de tomate', 'Queijo'],
      instructions: ['Prepare o molho', 'Monte as camadas', 'Asse por 45 minutos'],
    ),
  ];

  List<RecipeModel> get recipes => _recipes; //Isso permite que outras partes do app leiam a lista, mas sem poder modificar diretamente.É uma cópia de acesso, não a lista real.

  List<RecipeModel> get favoriteRecipes {
    return _recipes.where((recipe) => recipe.isFavorite).toList();
  }

  void addRecipe(RecipeModel recipe) { //Adiciona receita
    final recipeWithId = RecipeModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),//DateTime.now() pega o momento atual
      title: recipe.title,
      description: recipe.description,
      category: recipe.category,
      time: recipe.time,
      imageUrl: recipe.imageUrl,
      authorName: recipe.authorName,
      ingredients: recipe.ingredients,
      instructions: recipe.instructions,
      createdAt: recipe.createdAt,
    );
    _recipes.insert(0, recipeWithId);
    notifyListeners(); //notifyListeners() avisa as telas para atualizarem automaticamente.
  }

  void removeRecipe(int index) { //Remove a receita
    _recipes.removeAt(index); //Remove a receita na posição indicada.
    notifyListeners();
  }

  void toggleFavorite(String id) { //favoritar/desfavoritar receita
    final index = _recipes.indexWhere((recipe) => recipe.id == id); 
    if (index != -1) { //procura a receita pelo id
      _recipes[index] = _recipes[index].copyWith( //Usa copyWith para criar uma nova receita igual, mas com isFavorite invertido.Substitui a receita antiga pela nova.
        isFavorite: !_recipes[index].isFavorite,
      );
      notifyListeners();
    }
  }
}
