import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';

/// Tela de Configurações
class SettingsScreen extends StatelessWidget {
   SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
             Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.gradientStart,
                    AppColors.gradientEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 16,
                    top: 16,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ),
                 const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.settings, size: 48, color: Colors.white),
                        SizedBox(height: 8),
                        Text(
                          'Configurações',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Conteúdo
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 8),

                  // Seção: Aparência
                  _buildSectionTitle('Aparência'),
                  const SizedBox(height: 8),

                  // Toggle Tema Escuro
                  _buildSettingCard(
                    icon: isDark ? Icons.dark_mode : Icons.light_mode,
                    title: 'Tema Escuro',
                    subtitle: isDark ? 'Ativado' : 'Desativado',
                    trailing: Switch(
                      value: isDark,
                      onChanged: (_) => themeProvider.toggleTheme(),
                      activeColor: AppColors.terracota,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Seção: Conta
                  _buildSectionTitle('Conta'),
                  const SizedBox(height: 8),

                  // Perfil
                  if (authProvider.isAuthenticated)
                    _buildSettingCard(
                      icon: Icons.person,
                      title: 'Perfil',
                      subtitle: authProvider.user?.nome ?? 'Usuário',
                      onTap: () {
                        // Navegar para tela de perfil
                      },
                    ),

                  // Login/Logout
                  if (authProvider.isAuthenticated)
                    _buildSettingCard(
                      icon: Icons.logout,
                      title: 'Sair',
                      subtitle: 'Fazer logout da conta',
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Sair'),
                            content: const Text(
                              'Tem certeza que deseja sair?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Sair'),
                              ),
                            ],
                          ),
                        );
if (confirm == true) {
  authProvider.logout();  // ✅ SEM await
  if (context.mounted) {
    Navigator.pushReplacementNamed(context, '/login');  // ✅ Vai para /login
  }
}
                      },
                    )
                  else
                    _buildSettingCard(
                      icon: Icons.login,
                      title: 'Fazer Login',
                      subtitle: 'Entre na sua conta',
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),

                  const SizedBox(height: 24),

                  // Seção: Sobre
                  _buildSectionTitle('Sobre'),
                  const SizedBox(height: 8),

                  _buildSettingCard(
                    icon: Icons.info_outline,
                    title: 'Versão',
                    subtitle: '1.0.0',
                  ),

                  _buildSettingCard(
                    icon: Icons.description,
                    title: 'Termos de Uso',
                    onTap: () {
                      // Abrir termos de uso
                    },
                  ),

                  _buildSettingCard(
                    icon: Icons.privacy_tip,
                    title: 'Política de Privacidade',
                    onTap: () {
                      // Abrir política de privacidade
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.terracotaDark,
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.terracota),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing ??
            (onTap != null
                ? const Icon(Icons.chevron_right, color: AppColors.grey)
                : null),
        onTap: onTap,
      ),
    );
  }
}
