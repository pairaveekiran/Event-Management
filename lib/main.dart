import 'package:event_management/screen/breakfast.dart';
import 'package:event_management/screen/dinner.dart';
import 'package:event_management/screen/drinks.dart';
import 'package:event_management/screen/lunch.dart';
import 'package:event_management/screen/tea.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ServingMenuUI(),
    );
  }
}

class ServingMenuUI extends StatelessWidget {
  const ServingMenuUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // Header
          Container(
            height: 120,
            width: double.infinity,
            alignment: Alignment.center,
            color: Colors.redAccent,
            child: const Text(
              "Serving Menu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 40),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  childAspectRatio: 1,
                ),
                children: [
                  MenuButton(
                    title: "Breakfast",
                    icon: Icons.free_breakfast,
                    color: const Color(0xFFF8E1BC),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Breakfast()
                             ,
                        ),
                      );
                    },
                  ),

                  MenuButton(
                    title: "Lunch",
                    icon: Icons.lunch_dining,
                    color: const Color(0xFFCFF7B7),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const Lunch(),
                        ),
                      );
                    },
                  ),

                  MenuButton(
                    title: "Dinner",
                    icon: Icons.restaurant,
                    color: const Color(0xFFE2B8FF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const Dinner(),
                        ),
                      );
                    },
                  ),

                  MenuButton(
                    title: "Tea",
                    icon: Icons.emoji_food_beverage,
                    color: const Color(0xFFD5BC96),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const Tea(),
                        ),
                      );
                    },
                  ),

                  MenuButton(
                    title: "Drinks",
                    icon: Icons.local_bar,
                    color: const Color(0xFFBEEBFF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const Drinks(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const MenuButton({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.orange,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.black87,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Common Screen
class FoodScreen extends StatelessWidget {
  final String title;

  const FoodScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(title),
      ),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}