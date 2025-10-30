// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:food_recipe/models/category.dart';
import 'package:food_recipe/data/dummy_data.dart';

class SearchResult {
  final String type; 
  final String id;
  final String title;
  final String? subtitle;
  final dynamic item; 

  SearchResult({
    required this.type,
    required this.id,
    required this.title,
    this.subtitle,
    this.item,
  });
}


class SearchService {
  Timer? _debounce;
  final Duration debounceDuration;

  SearchService({Duration? debounce})
    : debounceDuration = debounce ?? const Duration(seconds: 3);

  // Debounced search: call this for each keystroke and provide a callback
  // that will receive results after the debounce interval.
  void onQueryChanged(
    String query,
    void Function(List<SearchResult>) onResults,
  ) {
    _debounce?.cancel();

    final q = query.trim();
    if (q.isEmpty) {
      // Clear immediately if the query is empty
      onResults([]);
      return;
    }

    _debounce = Timer(debounceDuration, () {
      final results = searchNow(q);
      onResults(results);
    });
  }

  /// Immediate search (no debounce). Returns results synchronously.
  List<SearchResult> searchNow(String query) {
    final q = query.toLowerCase();
    final List<SearchResult> results = [];

    // build category lookup map for nice subtitles
    final Map<String, Category> categoryById = {
      for (var c in availableCategories) c.id: c,
    };

    // Search categories by their title
    for (final cat in availableCategories) {
      if (cat.title.toLowerCase().contains(q)) {
        results.add(
          SearchResult(
            type: 'category',
            id: cat.id,
            title: cat.title,
            subtitle: 'Category',
            item: cat,
          ),
        );
      }
    }

    // Search meals by title, ingredients, steps and category titles
    for (final meal in dummyMeals) {
      final titleMatch = meal.title.toLowerCase().contains(q);

      final ingredientsText = meal.ingredients.join(' ').toLowerCase();
      final ingredientsMatch = ingredientsText.contains(q);

      final stepsText = meal.steps.join(' ').toLowerCase();
      final stepsMatch = stepsText.contains(q);

      // also match against category titles for the meal
      final categoryTitles = meal.categories
          .map((id) => categoryById[id]?.title ?? '')
          .join(' ')
          .toLowerCase();
      final categoryMatch = categoryTitles.contains(q);

      if (titleMatch || ingredientsMatch || stepsMatch || categoryMatch) {
        String subtitle = '';
        if (titleMatch) {
          subtitle = 'Matched in title';
        } else if (ingredientsMatch)
          subtitle = 'Matched in ingredients';
        else if (stepsMatch)
          subtitle = 'Matched in steps';
        else if (categoryMatch)
          subtitle = 'Matched category';

        // also show short context: which categories this meal belongs to
        final catNames = meal.categories
            .map((id) => categoryById[id]?.title ?? id)
            .join(', ');

        results.add(
          SearchResult(
            type: 'meal',
            id: meal.id,
            title: meal.title,
            subtitle: '$subtitle — $catNames',
            item: meal,
          ),
        );
      }
    }

    return results;
  }

  /// Cancel any pending debounced call. Call from dispose.
  void dispose() {
    _debounce?.cancel();
  }
}
