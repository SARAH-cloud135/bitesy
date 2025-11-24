# 📚 Guia Completo - Estrutura do Projeto CookEasy

## 📁 Estrutura de Pastas

```
cookeasy/
├── lib/
│   ├── main.dart                          # Ponto de entrada do app
│   │
│   ├── models/                            # Models (dados)
│   │   ├── user_model.dart                # Model de usuário
│   │   └── recipe_model.dart              # Model de receita
│   │
│   ├── services/                          # Serviços (API)
│   │   └── api_service.dart               # Serviço de comunicação com API
│   │
│   ├── repositories/                      # Repositories (isolam API)
│   │   ├── auth_repository.dart           # Repository de autenticação
│   │   └── recipe_repository.dart         # Repository de receitas
│   │
│   ├── providers/                         # Providers (estado)
│   │   ├── theme_provider.dart            # Provider de tema
│   │   ├── auth_provider.dart             # Provider de autenticação
│   │   └── recipe_provider.dart           # Provider de receitas
│   │
│   ├── views/                             # Telas
│   │   ├── auth/                          # Telas de autenticação
│   │   │   ├── login_screen.dart          # Tela de login
│   │   │   └── register_screen.dart       # Tela de cadastro
│   │   │
│   │   ├── home/                          # Telas principais
│   │   │   └── home_screen.dart           # Tela inicial
│   │   │
│   │   ├── recipe/                        # Telas de receitas
│   │   │   ├── send_recipe_screen.dart    # Enviar receita
│   │   │   ├── recipe_detail_screen.dart  # Detalhes da receita
│   │   │   └── edit_recipe_screen.dart    # Editar receita
│   │   │
│   │   ├── forum/                         # Telas de fórum
│   │   │   └── forum_screen.dart          # Fórum
│   │   │
│   │   └── settings/                      # Telas de configurações
│   │       └── settings_screen.dart       # Configurações
│   │
│   ├── widgets/                           # Widgets reutilizáveis
│   │   ├── custom_text_field.dart         # Campo de texto customizado
│   │   ├── recipe_card.dart               # Card de receita
│   │   └── loading_widget.dart            # Widget de loading
│   │
│   └── utils/                             # Utilitários
│       ├── app_colors.dart                # Cores do app
│       ├── app_themes.dart                # Temas (claro/escuro)
│       └── validators.dart                # Validadores
│
├── assets/                                # Assets (imagens, etc)
│   └── images/
│       └── banner.png
│
├── pubspec.yaml                           # Dependências
├── README.md                              # Documentação
└── .gitignore                             # Arquivos ignorados pelo Git
```

---

## 🎨 Cores e Temas

### Arquivo: `lib/utils/app_colors.dart`

**Localização:** `/lib/utils/app_colors.dart`

**Descrição:** Centraliza todas as cores do aplicativo.

**Cores Principais:**
- `terracota` - Cor principal do app
- `terracotaDark` - Versão escura da cor principal
- `cream` - Cor de fundo (tema claro)

**Cores do Tema Escuro:**
- `darkBackground` - Fundo escuro
- `darkSurface` - Superfície escura
- `darkCard` - Card escuro
- `darkText` - Texto escuro

**Como usar:**
```dart
import 'package:cookeasy/utils/app_colors.dart';

Container(
  color: AppColors.terracota,
  child: Text(
    'Olá',
    style: TextStyle(color: AppColors.white),
  ),
)
```

---

### Arquivo: `lib/utils/app_themes.dart`

**Localização:** `/lib/utils/app_themes.dart`

**Descrição:** Define os temas claro e escuro do aplicativo.

**Temas:**
- `AppThemes.lightTheme` - Tema claro
- `AppThemes.darkTheme` - Tema escuro

**Como usar:**
```dart
import 'package:cookeasy/utils/app_themes.dart';

MaterialApp(
  theme: AppThemes.lightTheme,
  darkTheme: AppThemes.darkTheme,
  themeMode: ThemeMode.system, // ou light, dark
)
```

---

## 📦 Models

### Arquivo: `lib/models/user_model.dart`

**Localização:** `/lib/models/user_model.dart`

**Descrição:** Model de usuário com métodos `fromJson` e `toJson`.

**Campos:**
- `id` - ID do usuário
- `nome` - Nome completo
- `email` - E-mail
- `telefone` - Telefone (opcional)
- `avatarUrl` - URL do avatar (opcional)
- `createdAt` - Data de criação (opcional)

**Exemplo de uso:**
```dart
// Criar usuário a partir de JSON
final user = UserModel.fromJson({
  'id': '1',
  'nome': 'João Silva',
  'email': 'joao@example.com',
});

// Converter para JSON
final json = user.toJson();

// Criar cópia com modificações
final updatedUser = user.copyWith(nome: 'João Santos');
```

---

### Arquivo: `lib/models/recipe_model.dart`

**Localização:** `/lib/models/recipe_model.dart`

**Descrição:** Model de receita com suporte para TheMealDB API.

**Campos:**
- `id` - ID da receita
- `title` - Título
- `description` - Descrição
- `imageUrl` - URL da imagem
- `time` - Tempo de preparo
- `category` - Categoria
- `ingredients` - Lista de ingredientes
- `instructions` - Lista de instruções
- `authorId` - ID do autor
- `authorName` - Nome do autor
- `isFavorite` - Se é favorito
- `createdAt` - Data de criação

**Exemplo de uso:**
```dart
// Criar receita a partir de JSON
final recipe = RecipeModel.fromJson(jsonData);

// Converter para JSON
final json = recipe.toJson();

// Marcar como favorito
final favoriteRecipe = recipe.copyWith(isFavorite: true);
```

---

## 🌐 Services e Repositories

### Arquivo: `lib/services/api_service.dart`

**Localização:** `/lib/services/api_service.dart`

**Descrição:** Serviço de comunicação com API (GET, POST, PUT, DELETE).

**Configuração:**
```dart
// Altere a URL base da sua API
static const String baseUrl = 'https://sua-api.com/api';
```

**Métodos:**
- `get(endpoint, {token})` - Buscar dados
- `post(endpoint, {body, token})` - Criar dados
- `put(endpoint, {body, token})` - Atualizar dados
- `delete(endpoint, {token})` - Deletar dados

**Métodos TheMealDB (para testes):**
- `searchRecipesMealDB(query)` - Buscar receitas
- `getRecipesByCategory(category)` - Buscar por categoria
- `getRecipeDetails(id)` - Buscar detalhes

**Exemplo de uso:**
```dart
// GET
final response = await ApiService.get('/recipes', token: 'seu_token');

// POST
final response = await ApiService.post(
  '/recipes',
  body: {'title': 'Bolo de Chocolate'},
  token: 'seu_token',
);

// PUT
await ApiService.put(
  '/recipes/1',
  body: {'title': 'Bolo de Morango'},
  token: 'seu_token',
);

// DELETE
await ApiService.delete('/recipes/1', token: 'seu_token');
```

---

### Arquivo: `lib/repositories/auth_repository.dart`

**Localização:** `/lib/repositories/auth_repository.dart`

**Descrição:** Repository de autenticação (isola lógica de API).

**Métodos:**
- `login({email, senha})` - Fazer login
- `register({nome, email, senha, telefone})` - Fazer cadastro
- `logout(token)` - Fazer logout
- `recoverPassword(email)` - Recuperar senha
- `validateToken(token)` - Validar token
- `updateProfile({token, nome, telefone, avatarUrl})` - Atualizar perfil

**Exemplo de uso:**
```dart
final authRepo = AuthRepository();

// Login
final result = await authRepo.login(
  email: 'joao@example.com',
  senha: '123456',
);
final token = result['token'];
final user = result['user'];

// Cadastro
final result = await authRepo.register(
  nome: 'João Silva',
  email: 'joao@example.com',
  senha: '123456',
  telefone: '11999999999',
);
```

---

### Arquivo: `lib/repositories/recipe_repository.dart`

**Localização:** `/lib/repositories/recipe_repository.dart`

**Descrição:** Repository de receitas (isola lógica de API).

**Métodos:**
- `getAllRecipes({token})` - Buscar todas as receitas
- `getRecipesByCategory(category, {token})` - Buscar por categoria
- `searchRecipes(query, {token})` - Buscar por texto
- `getRecipeById(id, {token})` - Buscar por ID
- `createRecipe({...})` - Criar receita
- `updateRecipe({id, ...})` - Atualizar receita
- `deleteRecipe(id, {token})` - Deletar receita
- `getFavoriteRecipes({token})` - Buscar favoritos
- `addToFavorites(recipeId, {token})` - Adicionar aos favoritos
- `removeFromFavorites(recipeId, {token})` - Remover dos favoritos

**Métodos TheMealDB (para testes):**
- `searchRecipesMealDB(query)` - Buscar receitas
- `getRecipesByCategoryMealDB(category)` - Buscar por categoria
- `getRecipeDetailsMealDB(id)` - Buscar detalhes

**Exemplo de uso:**
```dart
final recipeRepo = RecipeRepository();

// Buscar receitas
final recipes = await recipeRepo.getAllRecipes(token: 'seu_token');

// Criar receita
final newRecipe = await recipeRepo.createRecipe(
  title: 'Bolo de Chocolate',
  description: 'Delicioso bolo',
  imageUrl: 'https://...',
  time: '45 min',
  category: 'Sobremesa',
  ingredients: ['Chocolate', 'Farinha', 'Ovos'],
  instructions: ['Misture tudo', 'Asse por 30 min'],
  token: 'seu_token',
);

// Adicionar aos favoritos
await recipeRepo.addToFavorites('1', token: 'seu_token');
```

---

## 🔄 Providers (Estado)

### Arquivo: `lib/providers/theme_provider.dart`

**Localização:** `/lib/providers/theme_provider.dart`

**Descrição:** Provider de tema (gerencia tema claro/escuro).

**Propriedades:**
- `themeMode` - Modo do tema (light, dark, system)
- `isDarkMode` - Se está no modo escuro

**Métodos:**
- `toggleTheme()` - Alternar entre claro e escuro
- `setTheme(ThemeMode)` - Definir tema específico

**Exemplo de uso:**
```dart
// No widget
final themeProvider = Provider.of<ThemeProvider>(context);

// Alternar tema
ElevatedButton(
  onPressed: () => themeProvider.toggleTheme(),
  child: Text('Alternar Tema'),
)

// Verificar se está escuro
if (themeProvider.isDarkMode) {
  // Fazer algo
}

// Usar Consumer
Consumer<ThemeProvider>(
  builder: (context, themeProvider, child) {
    return Switch(
      value: themeProvider.isDarkMode,
      onChanged: (_) => themeProvider.toggleTheme(),
    );
  },
)
```

---

### Arquivo: `lib/providers/auth_provider.dart`

**Localização:** `/lib/providers/auth_provider.dart`

**Descrição:** Provider de autenticação (gerencia estado do usuário).

**Propriedades:**
- `token` - Token de autenticação
- `user` - Usuário logado
- `isLoading` - Se está carregando
- `error` - Mensagem de erro
- `isAuthenticated` - Se está autenticado

**Métodos:**
- `login({email, senha})` - Fazer login
- `register({nome, email, senha, telefone})` - Fazer cadastro
- `logout()` - Fazer logout
- `recoverPassword(email)` - Recuperar senha
- `updateProfile({nome, telefone, avatarUrl})` - Atualizar perfil
- `clearError()` - Limpar erro

**Exemplo de uso:**
```dart
// No widget
final authProvider = Provider.of<AuthProvider>(context);

// Login
await authProvider.login(
  email: 'joao@example.com',
  senha: '123456',
);

if (authProvider.error != null) {
  // Mostrar erro
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(authProvider.error!)),
  );
}

// Verificar se está autenticado
if (authProvider.isAuthenticated) {
  // Navegar para home
}

// Logout
await authProvider.logout();

// Usar Consumer
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.isLoading) {
      return CircularProgressIndicator();
    }
    
    return Text('Olá, ${authProvider.user?.nome}');
  },
)
```

---

### Arquivo: `lib/providers/recipe_provider.dart`

**Localização:** `/lib/providers/recipe_provider.dart`

**Descrição:** Provider de receitas (gerencia estado das receitas).

**Propriedades:**
- `recipes` - Lista de receitas
- `favoriteRecipes` - Lista de favoritos
- `isLoading` - Se está carregando
- `error` - Mensagem de erro

**Métodos:**
- `fetchRecipes({token})` - Buscar receitas
- `fetchRecipesByCategory(category, {token})` - Buscar por categoria
- `searchRecipes(query, {token})` - Buscar por texto
- `createRecipe({...})` - Criar receita
- `updateRecipe({id, ...})` - Atualizar receita
- `deleteRecipe(id, {token})` - Deletar receita
- `fetchFavoriteRecipes({token})` - Buscar favoritos
- `addToFavorites(recipeId, {token})` - Adicionar aos favoritos
- `removeFromFavorites(recipeId, {token})` - Remover dos favoritos
- `toggleFavorite(recipeId, {token})` - Alternar favorito
- `clearError()` - Limpar erro
- `clearRecipes()` - Limpar receitas

**Métodos TheMealDB (para testes):**
- `searchRecipesMealDB(query)` - Buscar receitas
- `fetchRecipesByCategoryMealDB(category)` - Buscar por categoria

**Exemplo de uso:**
```dart
// No widget
final recipeProvider = Provider.of<RecipeProvider>(context);

// Buscar receitas
await recipeProvider.fetchRecipes(token: 'seu_token');

// Criar receita
final success = await recipeProvider.createRecipe(
  title: 'Bolo de Chocolate',
  description: 'Delicioso',
  imageUrl: 'https://...',
  time: '45 min',
  category: 'Sobremesa',
  ingredients: ['Chocolate'],
  instructions: ['Misture'],
  token: 'seu_token',
);

// Adicionar aos favoritos
await recipeProvider.addToFavorites('1', token: 'seu_token');

// Usar Consumer
Consumer<RecipeProvider>(
  builder: (context, recipeProvider, child) {
    if (recipeProvider.isLoading) {
      return CircularProgressIndicator();
    }
    
    return ListView.builder(
      itemCount: recipeProvider.recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipeProvider.recipes[index];
        return ListTile(title: Text(recipe.title));
      },
    );
  },
)
```

---

## 🖥️ Views (Telas)

### Arquivo: `lib/main.dart`

**Localização:** `/lib/main.dart`

**Descrição:** Ponto de entrada do app com MultiProvider.

**Estrutura:**
```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: const CookEasyApp(),
    ),
  );
}
```

**Rotas:**
- `/` - HomeScreen
- `/login` - LoginScreen
- `/register` - RegisterScreen
- `/send-recipe` - SendRecipeScreen
- `/forum` - ForumScreen
- `/settings` - SettingsScreen

---

### Arquivo: `lib/views/auth/login_screen.dart`

**Localização:** `/lib/views/auth/login_screen.dart`

**Descrição:** Tela de login com validação.

**Como usar:**
```dart
Navigator.pushNamed(context, '/login');
```

---

### Arquivo: `lib/views/auth/register_screen.dart`

**Localização:** `/lib/views/auth/register_screen.dart`

**Descrição:** Tela de cadastro com validação e máscara de telefone.

**Como usar:**
```dart
Navigator.pushNamed(context, '/register');
```

---

### Arquivo: `lib/views/settings/settings_screen.dart`

**Localização:** `/lib/views/settings/settings_screen.dart`

**Descrição:** Tela de configurações com toggle de tema.

**Funcionalidades:**
- Alternar tema claro/escuro
- Logout
- Informações do app

**Como usar:**
```dart
Navigator.pushNamed(context, '/settings');
```

---

## 📝 Dependências (pubspec.yaml)

**Localização:** `/pubspec.yaml`

**Dependências principais:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  provider: ^6.1.1              # Estado
  http: ^1.1.0                  # HTTP/API
  shared_preferences: ^2.2.2    # Armazenamento local
  sqflite: ^2.3.0               # Banco de dados local
  path_provider: ^2.1.1         # Caminhos de arquivos
```

**Como instalar:**
```bash
flutter pub get
```

---

## 🚀 Como Usar

### 1. Configurar API

Edite o arquivo `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'https://sua-api.com/api';
```

### 2. Executar o app

```bash
flutter run
```

### 3. Testar com TheMealDB

Use os métodos `*MealDB` para testar sem API própria:

```dart
// No RecipeProvider
await recipeProvider.searchRecipesMealDB('chicken');
await recipeProvider.fetchRecipesByCategoryMealDB('Dessert');
```

### 4. Alternar tema

```dart
final themeProvider = Provider.of<ThemeProvider>(context);
themeProvider.toggleTheme();
```

### 5. Fazer login

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
final success = await authProvider.login(
  email: 'teste@example.com',
  senha: '123456',
);
```

---

## ✅ Checklist de Implementação

- [x] Estrutura de pastas organizada
- [x] Models com fromJson/toJson
- [x] Service de API (GET, POST, PUT, DELETE)
- [x] Repositories (Auth, Recipe)
- [x] Providers (Theme, Auth, Recipe)
- [x] Tema claro e escuro
- [x] Tela de login
- [x] Tela de cadastro
- [x] Tela de configurações
- [x] Persistência de tema
- [x] Persistência de autenticação
- [ ] Tela home reorganizada (adaptar código existente)
- [ ] Tela de detalhes de receita
- [ ] Tela de edição de receita
- [ ] Tela de fórum
- [ ] Armazenamento local de receitas (sqflite)
- [ ] Comportamento offline

---

## 📖 Próximos Passos

1. **Adaptar telas existentes** para usar os providers
2. **Implementar armazenamento local** com sqflite
3. **Criar tela de detalhes** de receita
4. **Implementar comportamento offline**
5. **Adicionar testes**
6. **Gerar APK**

---

## 🆘 Problemas Comuns

### Erro: "Provider not found"

**Solução:** Certifique-se de que o widget está dentro do `MultiProvider`:

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [...],
      child: const CookEasyApp(),
    ),
  );
}
```

### Erro: "Bad state: No element"

**Solução:** Verifique se a lista não está vazia antes de usar `firstWhere`:

```dart
final recipe = recipes.firstWhere(
  (r) => r.id == id,
  orElse: () => null, // Retornar null se não encontrar
);
```

### Tema não muda

**Solução:** Use `Consumer` ou `context.watch`:

```dart
Consumer<ThemeProvider>(
  builder: (context, themeProvider, child) {
    return MaterialApp(
      themeMode: themeProvider.themeMode,
      ...
    );
  },
)
```

---

**Versão:** 1.0  
**Data:** ${DateTime.now().toString().split(' ')[0]}
