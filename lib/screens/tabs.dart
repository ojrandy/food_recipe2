import 'package:flutter/material.dart';
import 'package:food_recipe/models/meal.dart';
import 'package:food_recipe/screens/categories.dart';
import 'package:food_recipe/screens/meals.dart';
import 'package:food_recipe/screens/search.dart';
import 'package:food_recipe/widget/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  // adding favorite list
  final List<Meal> _favoriteMeals = [];

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

  void _setScreen(String identifier) {
    setState(() {
      if (identifier == 'filters') {
        _selectedPageIndex = 0;
      } else {
        // We return back to the home screen
        Navigator.of(context).pop();
      }
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Creating a Widget to know the active Page
    var activePageTitle = 'Categories';
    Icon? activeIcons;
    Widget activePage;
    if (_selectedPageIndex == 0) {
      activePage = CategoriesScreen(
        onToggleFavourite: _toggleMealFavouriteStatus,
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
