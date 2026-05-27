import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          background: const Color(0xFFFFFDF9), // Warm, appetizing background
        ),
        useMaterial3: true,
      ),
      home: const RecipeHomeScreen(),
    );
  }
}

class RecipeHomeScreen extends StatefulWidget {
  const RecipeHomeScreen({super.key});

  @override
  State<RecipeHomeScreen> createState() => _RecipeHomeScreenState();
}

class _RecipeHomeScreenState extends State<RecipeHomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _recipes = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Function to search recipes from the API
  Future<void> searchRecipes(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _recipes = [];
      _errorMessage = '';
    });

    final url = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=$query');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _recipes = data['meals'] ?? [];
          _isLoading = false;
          if (_recipes.isEmpty) {
            _errorMessage =
                'No recipes found. Try something else (e.g., "chicken" or "cake").';
          }
        });
      } else {
        setState(() {
          _errorMessage = 'Server error. Please try again later.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection error. Please check your internet.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          '🍳 Recipe Hub',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange[700],
        elevation: 2,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Styled Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(fontSize: 16),
                  onSubmitted: (value) => searchRecipes(value.trim()),
                  decoration: InputDecoration(
                    hintText: 'What do you want to cook? (e.g., pasta)',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.orange),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ElevatedButton(
                        onPressed: () => searchRecipes(_controller.text.trim()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[700],
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Search'),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Dynamic Results Area
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.orange)
                      : _errorMessage.isNotEmpty
                          ? Text(_errorMessage,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 15),
                              textAlign: TextAlign.center)
                          : _recipes.isEmpty
                              ? _buildEmptyState()
                              : _buildRecipeList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.restaurant_rounded,
            size: 70, color: Colors.orange.withOpacity(0.2)),
        const SizedBox(height: 12),
        Text(
          'Hungry?',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orange[900]),
        ),
        const SizedBox(height: 4),
        Text(
          'Type an ingredient or meal name to find recipes.',
          style: TextStyle(color: Colors.grey[500]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRecipeList() {
    return ListView.builder(
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final meal = _recipes[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          color: Colors.white,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // Navigation to the Recipe Detail Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(meal: meal),
                ),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(16)),
                  child: Image.network(
                    meal['strMealThumb'],
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal['strMeal'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Category: ${meal['strCategory'] ?? "General"}',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'View Recipe ➔',
                          style: TextStyle(
                              color: Colors.orange[700],
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- NEW FULL SCREEN DETAILED RECIPE SCREEN ---
class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> meal;

  const RecipeDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    // Collect ingredients and measurements dynamically
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = meal['strIngredient$i'];
      final measure = meal['strMeasure$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add('${measure ?? ''} ${ingredient.toString().trim()}');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          meal['strMeal'] ?? 'Recipe Details',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.orange[700],
        // The back arrow is automatically provided by Flutter since we navigated via Navigator.push
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Image
                Image.network(
                  meal['strMealThumb'],
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe Title
                      Text(
                        meal['strMeal'] ?? '',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[900]),
                      ),
                      const SizedBox(height: 8),

                      // Category & Area Chips
                      Row(
                        children: [
                          Chip(
                            label: Text(meal['strCategory'] ?? 'General'),
                            backgroundColor: Colors.orange[50],
                            side: BorderSide.none,
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(meal['strArea'] ?? 'International'),
                            backgroundColor: Colors.grey[100],
                            side: BorderSide.none,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(),

                      // Ingredients Section Title
                      const Row(
                        children: [
                          Icon(Icons.shopping_basket_rounded,
                              color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Ingredients:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Ingredients List
                      ...ingredients.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline,
                                    size: 18, color: Colors.orange),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Text(item,
                                        style: const TextStyle(fontSize: 15))),
                              ],
                            ),
                          )),

                      const SizedBox(height: 20),
                      const Divider(),

                      // Instructions Section Title
                      const Row(
                        children: [
                          Icon(Icons.restaurant_menu_rounded,
                              color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Instructions:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Instructions Text
                      Text(
                        meal['strInstructions'] ?? 'No instructions available.',
                        style: TextStyle(
                            fontSize: 15, height: 1.6, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
