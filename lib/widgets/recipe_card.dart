import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../utils/app_colors.dart';

/// Card de Receita Reutilizável
class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final bool isHorizontal;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    return isHorizontal ? _buildHorizontalCard(context) : _buildSmallRow(context);
  }

  Widget _buildHorizontalCard(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                recipe.imageUrl ?? '',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                        recipe.title,
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis, 
                        style: const TextStyle(fontWeight: FontWeight.w600)
                    )
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: AppColors.grey), 
                    const SizedBox(width: 4), 
                    Text(recipe.time ?? '', style: const TextStyle(color: AppColors.grey, fontSize: 13))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSmallRow(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            recipe.imageUrl ?? '',
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: 72,
              height: 72,
              child: const Icon(Icons.image_not_supported),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(recipe.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: AppColors.grey), 
                  const SizedBox(width: 6), 
                  Text(recipe.time ?? '', style: const TextStyle(color: AppColors.grey, fontSize: 13))
                ],
              )
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
        )
      ],
    );
  }
}
