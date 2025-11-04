import 'package:flutter/material.dart';
import 'package:food_recipe/data/dummy_data.dart';
import 'package:food_recipe/models/meal.dart';
import 'package:food_recipe/screens/categories.dart';
import 'package:food_recipe/screens/filters.dart';
import 'package:food_recipe/screens/meals.dart';
import 'package:food_recipe/screens/search.dart';
import 'package:food_recipe/widget/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  // adding favorite list
  final List<Meal> _favoriteMeals = [];

  Map<Filter, bool> _selectedFilters = kInitialFilters;

  // Creating a snack bar for the update message on favorite meals
  void _showinfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleMealFavouriteStatus(Meal meal) {
    // check if its
    final isExisting = _favoriteMeals.contains(meal);

    // Set the state so as to auto add and remove meals when needed
    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showinfoMessage('Meal is no longer a favorite!');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showinfoMessage("Meal is added to favorites!");
    }
  }

  Future<void> _setScreen(String identifier) async {
    // Close the drawer first
    Navigator.of(context).pop();

    if (identifier == 'filters') {
      // Open filters and wait for result
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(currentFilters: _selectedFilters),
        ),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      return true;
    }).toList();
    // Creating a Widget to know the active Page
    var activePageTitle = 'Categories';
    Icon? activeIcons;
    Widget activePage;
    if (_selectedPageIndex == 0) {
      activePage = CategoriesScreen(
        onToggleFavourite: _toggleMealFavouriteStatus,
        availableMeals: availableMeals,
      );
      activePageTitle = 'Categories';
      activeIcons = const Icon(Icons.search);
    } else {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavourite: _toggleMealFavouriteStatus,
      );
      activePageTitle = 'Favorites';
      activeIcons = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: [
          if (activeIcons != null)
            IconButton(
              onPressed: () {
                // Open the search screen when the search icon is pressed
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const SearchScreen()),
                );
              },
              icon: activeIcons,
              iconSize: 32.0,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
        ],
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
