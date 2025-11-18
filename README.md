# 🍳 CookEasy - App de Receitas

App de receitas desenvolvido em Flutter com tema escuro, providers e integração com API.

## ✨ Features

- ✅ **Autenticação completa** (Login, Cadastro, Recuperação de senha)
- ✅ **Tema claro/escuro** com persistência
- ✅ **Gerenciamento de estado** com Provider
- ✅ **Integração com API** (GET, POST, PUT, DELETE)
- ✅ **Validação de formulários** com feedback visual
- ✅ **Máscaras de input** (telefone)
- ✅ **Armazenamento local** (SharedPreferences)
- ✅ **Arquitetura organizada** (Models, Services, Repositories, Providers, Views)
- ✅ **Suporte offline** (em desenvolvimento)
- ✅ **Sistema de favoritos**

## 📱 Telas

- **Home** - Listagem de receitas por categoria
- **Login** - Autenticação de usuário
- **Cadastro** - Registro de novo usuário
- **Enviar Receita** - Criar nova receita
- **Detalhes** - Visualizar receita completa
- **Favoritos** - Receitas favoritas do usuário
- **Configurações** - Tema, perfil, logout
- **Fórum** - Discussões sobre receitas

## 🏗️ Arquitetura

```
lib/
├── models/          # Modelos de dados
├── services/        # Serviços de API
├── repositories/    # Repositories (isolam API)
├── providers/       # Providers (estado)
├── views/           # Telas
├── widgets/         # Widgets reutilizáveis
└── utils/           # Utilitários (cores, temas, etc)
```

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)

### Instalação

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/cookeasy.git
cd cookeasy
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Configure a URL da API em `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://sua-api.com/api';
```

4. Execute o app:
```bash
flutter run
```

## 🧪 Testar sem API própria

O app possui integração com **TheMealDB** para testes:

```dart
// Buscar receitas
await recipeProvider.searchRecipesMealDB('chicken');

// Buscar por categoria
await recipeProvider.fetchRecipesByCategoryMealDB('Dessert');
```

## 📦 Dependências

- `provider: ^6.1.1` - Gerenciamento de estado
- `http: ^1.1.0` - Requisições HTTP
- `shared_preferences: ^2.2.2` - Armazenamento local
- `sqflite: ^2.3.0` - Banco de dados local
- `path_provider: ^2.1.1` - Caminhos de arquivos

## 🎨 Paleta de Cores

- **Terracota** (#D05A2A) - Cor principal
- **Terracota Dark** (#B04A2E) - Variação escura
- **Cream** (#FFF3E6) - Fundo (tema claro)
- **Dark Background** (#1A1A1A) - Fundo (tema escuro)

## 📖 Documentação

Consulte o [GUIA_COMPLETO.md](GUIA_COMPLETO.md) para documentação detalhada de cada arquivo e componente.

## 👥 Equipe

- **Desenvolvedor 1** - Autenticação e API
- **Desenvolvedor 2** - Estado e Persistência
- **Desenvolvedor 3** - Temas e Configurações
- **Desenvolvedor 4** - Arquitetura e Documentação

## 📝 Licença

Este projeto foi desenvolvido como trabalho acadêmico.

## 🔗 Links Úteis

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [TheMealDB API](https://www.themealdb.com/api.php)

---

**Versão:** 1.0.0  
**Última atualização:** ${DateTime.now().toString().split(' ')[0]}
