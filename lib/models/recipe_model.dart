/// Model de Receita
class RecipeModel {
  final String? id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? time;
  final String? category;
  final List<String>? ingredients;
  final List<String>? instructions;
  final String? authorId;
  final String? authorName;
  final bool isFavorite;
  final DateTime? createdAt;

  RecipeModel({
    this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.time,
    this.category,
    this.ingredients,
    this.instructions,
    this.authorId,
    this.authorName,
    this.isFavorite = false,
    this.createdAt,
  });

  // Converter de JSON para RecipeModel
  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id']?.toString() ?? json['idMeal']?.toString(),
      title: json['title'] ?? json['strMeal'] ?? json['name'] ?? '',
      description: json['description'] ?? json['strInstructions'],
      imageUrl: json['imageUrl'] ?? json['strMealThumb'] ?? json['image'],
      time: json['time'] ?? json['prepTime'] ?? json['cookTime'],
      category: json['category'] ?? json['strCategory'],
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : _extractIngredientsFromMealDB(json),
      instructions: json['instructions'] != null
          ? List<String>.from(json['instructions'])
          : _extractInstructionsFromText(json['strInstructions']),
      authorId: json['authorId'] ?? json['author_id'],
      authorName: json['authorName'] ?? json['author_name'],
      isFavorite: json['isFavorite'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
    );
  }

  // Extrair ingredientes do formato TheMealDB
  static List<String>? _extractIngredientsFromMealDB(Map<String, dynamic> json) {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        final measureText = measure != null && measure.toString().trim().isNotEmpty
            ? '$measure '
            : '';
        ingredients.add('$measureText$ingredient');
      }
    }
    return ingredients.isNotEmpty ? ingredients : null;
  }

  // Extrair instruções de texto corrido
  static List<String>? _extractInstructionsFromText(String? text) {
    if (text == null || text.isEmpty) return null;
    
    // Dividir por quebras de linha ou pontos
    final steps = text
        .split(RegExp(r'\n|\.\s'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    
    return steps.isNotEmpty ? steps : null;
  }

  // Converter de RecipeModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'time': time,
      'category': category,
      'ingredients': ingredients,
      'instructions': instructions,
      'authorId': authorId,
      'authorName': authorName,
      'isFavorite': isFavorite,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Criar cópia com modificações
  RecipeModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? time,
    String? category,
    List<String>? ingredients,
    List<String>? instructions,
    String? authorId,
    String? authorName,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      time: time ?? this.time,
      category: category ?? this.category,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'RecipeModel(id: $id, title: $title, category: $category)';
  }
}
