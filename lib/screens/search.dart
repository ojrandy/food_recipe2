import 'package:flutter/material.dart';
import 'package:food_recipe/services/search_service.dart';
import 'package:food_recipe/screens/meal_details.dart';
import 'package:food_recipe/screens/meals.dart';
import 'package:food_recipe/data/dummy_data.dart';
import 'package:food_recipe/models/category.dart';
import 'package:food_recipe/models/meal.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final SearchService _searchService = SearchService();
  List<SearchResult> _results = [];
  bool _searching = false;

  @override
  void dispose() {
    _controller.dispose();
    _searchService.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {
      _searching = true;
    });

    _searchService.onQueryChanged(value, (results) {
      if (!mounted) return;
      setState(() {
        _results = results;
        _searching = false;
      });
    });
  }

  void _clear() {
    _controller.clear();
    setState(() {
      _results = [];
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isQueryEmpty = _controller.text.trim().isEmpty;
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              cursorColor: Theme.of(context).colorScheme.primary,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Search categories, meals, ingredients...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clear,
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          if (_searching) const LinearProgressIndicator(),
          Expanded(
            child: isQueryEmpty
                ? GridView.count(
                    padding: const EdgeInsets.all(12),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3 / 2,
                    children: [
                      for (final category in largeAvailableCategories)
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                                final filteredMeals = dummyMeals
                                .where(
                                  (m) => m.categories.contains(category.id),
                                )
                                .toList();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => MealsScreen(
                                  title: category.title,
                                  meals: filteredMeals,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: category.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: category.color.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: category.color,
                                  child: Text(
                                    category.title[0],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  )
                : (_results.isEmpty
                      ? Center(
                          child: Text(
                            _searching ? 'Searching...' : 'No results',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (ctx, i) {
                            final r = _results[i];
                            return ListTile(
                              leading: Icon(
                                r.type == 'category'
                                    ? Icons.category
                                    : Icons.restaurant_menu,
                              ),
                              title: Text(r.title),
                              subtitle: r.subtitle != null
                                  ? Text(r.subtitle!)
                                  : null,
                              onTap: () {
                                if (r.type == 'meal') {
                                  final meal = r.item as Meal;
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) =>
                                          MealDetailsScreen(meal: meal),
                                    ),
                                  );
                                } else if (r.type == 'category') {
                                  final category = r.item as Category;
                                      final filteredMeals = dummyMeals
                                      .where(
                                        (m) =>
                                            m.categories.contains(category.id),
                                      )
                                      .toList();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => MealsScreen(
                                        title: category.title,
                                        meals: filteredMeals,
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        )),
          ),
        ],
      ),
    );
  }
}
