// This will be the entry point of the category screen
import 'package:flutter/material.dart';

import 'package:food_recipe/models/category.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({
    super.key,
    required this.category,
    this.onSelectCategory,
  });

  final Category category;
  final void Function()? onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // interactive touch effect with inkwell which is absent in gesture detector
      onTap: onSelectCategory,
      splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              category.color.withOpacity(0.55),
              category.color.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            category.title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.surface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
