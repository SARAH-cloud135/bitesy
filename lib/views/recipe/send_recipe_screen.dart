import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/auth_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../models/recipe_model.dart';
import '../../utils/app_colors.dart';

class SendRecipeScreen extends StatefulWidget {
  const SendRecipeScreen({super.key});

  @override
  State<SendRecipeScreen> createState() => _SendRecipeScreenState();
}

class _SendRecipeScreenState extends State<SendRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _tempoPreparo = TextEditingController();
  final _porcoes = TextEditingController();
  
  String _categoriaSelecionada = 'Doces';
  String _dificuldade = 'Fácil';
  String _emojiSelecionado = '🍽️';
  List<String> _ingredientes = [''];
  List<String> _modoPreparo = [''];
  File? _imagemSelecionada;
  bool _isLoading = false;

  final List<String> _categorias = [
    'Doces', 'Salgados', 'Massas', 'Bebidas', 
    'Carnes', 'Vegetariano', 'Fitness', 'Lanches'
  ];

  final List<String> _dificuldades = ['Fácil', 'Médio', 'Difícil'];

  final Map<String, List<String>> _emojisPorCategoria = {
    'Doces': ['🍰', '🎂', '🧁', '🍪', '🍩', '🍫', '🍮', '🍦'],
    'Salgados': ['🍖', '🌭', '🥙', '🌮', '🌯', '🥗', '🍕', '🥪'],
    'Massas': ['🍝', '🍜', '🍲', '🥘', '🍛', '🥟', '🍱'],
    'Bebidas': ['🥤', '🧃', '🍹', '🍸', '☕', '🧋', '🥛', '🍵'],
    'Carnes': ['🥩', '🍗', '🍖', '🥓', '🍔', '🌭'],
    'Vegetariano': ['🥗', '🥙', '🌱', '🥑', '🥦', '🌽', '🍅'],
    'Fitness': ['🥗', '🍗', '🥙', '🥑', '🥦', '🍳'],
    'Lanches': ['🥪', '🌭', '🍕', '🍔', '🥙', '🌮'],
  };

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _tempoPreparo.dispose();
    _porcoes.dispose();
    super.dispose();
  }

  Future<void> _selecionarImagem() async {
    try {
      final ImagePicker picker = ImagePicker();
      
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Escolha uma opção',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.emoji_emotions_rounded, color: AppColors.terracotaDark),
                title: const Text('Escolher Emoji'),
                onTap: () {
                  Navigator.pop(context);
                  _selecionarEmoji();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: AppColors.terracotaDark),
                title: const Text('Tirar Foto'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    setState(() => _imagemSelecionada = File(image.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: AppColors.terracotaDark),
                title: const Text('Galeria'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    setState(() => _imagemSelecionada = File(image.path));
                  }
                },
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar imagem: $e')),
      );
    }
  }

  void _selecionarEmoji() {
    final emojis = _emojisPorCategoria[_categoriaSelecionada] ?? ['🍽️'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolha um Emoji'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: emojis.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() => _emojiSelecionado = emojis[index]);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      emojis[index],
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _adicionarIngrediente() {
    setState(() => _ingredientes.add(''));
  }

  void _removerIngrediente(int index) {
    if (_ingredientes.length > 1) {
      setState(() => _ingredientes.removeAt(index));
    }
  }

  void _adicionarPasso() {
    setState(() => _modoPreparo.add(''));
  }

  void _removerPasso(int index) {
    if (_modoPreparo.length > 1) {
      setState(() => _modoPreparo.removeAt(index));
    }
  }

  Future<void> _publicarReceita() async {
    if (_formKey.currentState!.validate()) {
      final ingredientesValidos = _ingredientes.where((i) => i.trim().isNotEmpty).toList();
      final passosValidos = _modoPreparo.where((s) => s.trim().isNotEmpty).toList();

      if (ingredientesValidos.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adicione pelo menos um ingrediente')),
        );
        return;
      }

      if (passosValidos.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adicione pelo menos um passo do modo de preparo')),
        );
        return;
      }

      setState(() => _isLoading = true);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);

      await Future.delayed(const Duration(seconds: 2));

      final imagemUrl = _imagemSelecionada != null 
          ? _imagemSelecionada!.path 
          : _emojiSelecionado;

      final novaReceita = RecipeModel(
        title: _tituloController.text.trim(),
        description: _descricaoController.text.trim(),
        category: _categoriaSelecionada,
        time: '${_tempoPreparo.text} min',
        imageUrl: imagemUrl,
        authorName: authProvider.user?.nome ?? 'Anônimo',
        ingredients: ingredientesValidos,
        instructions: passosValidos,
        createdAt: DateTime.now(),
      );

      recipeProvider.addRecipe(novaReceita);

      setState(() => _isLoading = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text('Receita publicada com sucesso!'),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Receita'),
        backgroundColor: AppColors.terracotaDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSection(
                title: '📷 Imagem da Receita',
                child: GestureDetector(
                  onTap: _selecionarImagem,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                      image: _imagemSelecionada != null
                          ? DecorationImage(
                              image: FileImage(_imagemSelecionada!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _imagemSelecionada == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _emojiSelecionado,
                                style: const TextStyle(fontSize: 80),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Toque para escolher',
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              Positioned(
                                top: 10,
                                right: 10,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit_rounded, color: AppColors.terracotaDark),
                                    onPressed: _selecionarImagem,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _buildSection(
                title: '📝 Informações Básicas',
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _tituloController,
                      label: 'Título da Receita',
                      hint: 'Ex: Bolo de Chocolate',
                      validator: (v) => v!.trim().isEmpty ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _descricaoController,
                      label: 'Descrição',
                      hint: 'Conte um pouco sobre sua receita...',
                      maxLines: 3,
                      validator: (v) => v!.trim().isEmpty ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _tempoPreparo,
                            label: 'Tempo (min)',
                            hint: '30',
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.trim().isEmpty ? 'Obrigatório' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _porcoes,
                            label: 'Porções',
                            hint: '4',
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.trim().isEmpty ? 'Obrigatório' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Categoria',
                      value: _categoriaSelecionada,
                      items: _categorias,
                      onChanged: (v) {
                        setState(() {
                          _categoriaSelecionada = v!;
                          final emojis = _emojisPorCategoria[v] ?? ['🍽️'];
                          _emojiSelecionado = emojis[0];
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Dificuldade',
                      value: _dificuldade,
                      items: _dificuldades,
                      onChanged: (v) => setState(() => _dificuldade = v!),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _buildSection(
                title: '🥘 Ingredientes',
                child: Column(
                  children: [
                    ..._ingredientes.asMap().entries.map((entry) {
                      int index = entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: entry.value,
                                decoration: InputDecoration(
                                  hintText: 'Ex: 2 xícaras de farinha',
                                  prefixIcon: const Icon(Icons.circle, size: 8, color: AppColors.terracota),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                onChanged: (v) => _ingredientes[index] = v,
                              ),
                            ),
                            if (_ingredientes.length > 1)
                              IconButton(
                                icon: const Icon(Icons.remove_circle_rounded, color: Colors.red),
                                onPressed: () => _removerIngrediente(index),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _adicionarIngrediente,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Adicionar Ingrediente'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.terracotaDark,
                        side: const BorderSide(color: AppColors.terracotaDark),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _buildSection(
                title: '👨‍🍳 Modo de Preparo',
                child: Column(
                  children: [
                    ..._modoPreparo.asMap().entries.map((entry) {
                      int index = entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 12, right: 12),
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.terracotaDark,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                initialValue: entry.value,
                                decoration: InputDecoration(
                                  hintText: 'Descreva este passo...',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                maxLines: 3,
                                onChanged: (v) => _modoPreparo[index] = v,
                              ),
                            ),
                            if (_modoPreparo.length > 1)
                              IconButton(
                                icon: const Icon(Icons.remove_circle_rounded, color: Colors.red),
                                onPressed: () => _removerPasso(index),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _adicionarPasso,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Adicionar Passo'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.terracotaDark,
                        side: const BorderSide(color: AppColors.terracotaDark),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _publicarReceita,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.terracotaDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Publicar Receita', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }
}