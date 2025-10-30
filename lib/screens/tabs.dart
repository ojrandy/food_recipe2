import 'package:flutter/material.dart';
import 'package:food_recipe/screens/categories.dart';
import 'package:food_recipe/screens/meals.dart';
import 'package:food_recipe/screens/search.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
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
      activePage = const CategoriesScreen();
      activePageTitle = 'Categories';
      activeIcons = const Icon(Icons.search);
    } else {
      activePage = MealsScreen(meals: []);
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
