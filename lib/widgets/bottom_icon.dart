import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Ícone da barra de navegação inferior
class BottomIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const BottomIcon({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active 
        ? AppColors.terracotaDark 
        : Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkTextSecondary
            : Colors.grey.shade600;
            
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}
