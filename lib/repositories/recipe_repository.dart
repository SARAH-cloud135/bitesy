import '../models/recipe_model.dart';
import '../services/api_service.dart';

/// Repository de Receitas
/// Isola a lógica de receitas da API
class RecipeRepository {
  /// Buscar todas as receitas
  Future<List<RecipeModel>> getAllRecipes({String? token}) async { //futura lista de receitas assincrona
    try {//Bloco try/catch serve para capturar possíveis erros.
      final response = await ApiService.get('/recipes', token: token);
//Você está esperando (await) a chamada GET para a API:
//'/recipes' → endpoint (rota da API)
//token: token → envia o token, se existir


      final List<dynamic> recipesJson = response['recipes'] ?? response;
      //Cria uma variável final chamada recipesJson
      //Se existir response['recipes'], use ele. Senão, use response. O operador ?? = "se for null, pegue o da direita".

      return recipesJson.map((json) => RecipeModel.fromJson(json)).toList();
//Ela pega uma lista de JSONs e transforma tudo em objetos RecipeModel.
//RecipeModel.fromJson(json) → converte o JSON para um objeto RecipeModel
//.toList() Converte para lista

    } on ApiException { //Se acontecer um erro do tipo ApiException, jogue ele pra cima de novo.”(não trata esse erro, só repassa).
      rethrow;
    } catch (e) {
      throw ApiException('Erro ao buscar receitas: $e');//Se acontecer QUALQUER outro erro, crie um novo erro ApiException com uma mensagem explicando.”
    }
  }

  /// Buscar receitas por categoria
  Future<List<RecipeModel>> getRecipesByCategory(
    String category, {
    String? token, //Se tiver token, envia ao servidor, se não tiver, envia null.
  }) async { //Marca a função como assíncrona porque ela usa await.
    try { //Tudo que pode gerar erro fica aqui.
      final response = await ApiService.get( //Faz uma requisição do tipo GET.
        '/recipes?category=$category',//URL para filtrar
        token: token,//Se um token foi enviado, usa. Se não, passa null.
      );
      
      final List<dynamic> recipesJson = response['recipes'] ?? response;
      return recipesJson.map((json) => RecipeModel.fromJson(json)).toList();
    } on ApiException { //Se for um erro especificamente do tipo ApiException
      rethrow; //não trata. Apenas relança o erro original.
    } catch (e) {//Vai pegar qualquer erro que não seja ApiException.
      throw ApiException('Erro ao buscar receitas: $e');//Cria um novo erro com uma mensagem amigável.
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
      //Só adiciona o campo no body se ele tiver sido enviado para a função.
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (imageUrl != null) body['imageUrl'] = imageUrl;
      if (time != null) body['time'] = time;
      if (category != null) body['category'] = category;
      if (ingredients != null) body['ingredients'] = ingredients;
      if (instructions != null) body['instructions'] = instructions;

      final response = await ApiService.put( //Envia um PUT para o servidor.
        '/recipes/$id', //Monta a URL
        body: body, //Envia o mapa com os campos que precisam ser atualizados.
        token: token,//Se você estiver logado, envia seu token de acesso.
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
