import 'package:event_management/screen/breakfast.dart';
import 'package:event_management/screen/dinner.dart';
import 'package:event_management/screen/drinks.dart';
import 'package:event_management/screen/lunch.dart';
import 'package:event_management/screen/tea.dart';
import 'package:flutter/material.dart';



class ServingMenuUI extends StatelessWidget {
  const ServingMenuUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // ================= HEADER =================

              Container(
                width: double.infinity,
                color: const Color(0xFF1F2A74),

                padding: const EdgeInsets.only(
                  top: 25,
                  bottom: 18,
                  left: 12,
                  right: 12,
                ),

                child: const Column(
                  children: [

                    Text(
                      "Association of Alliance Clubs International",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      "District 1055, Nepal",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 5),

                    FittedBox(
                      fit: BoxFit.scaleDown,

                      child: Text(
                        "Alliance Leadership Development Institute(ALDI)-2026",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "2026-06-06, Kahukot Resort, Kahudanda",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 3,
                color: Colors.yellow,
              ),

              const SizedBox(height: 20),

              // ================= LOGOS =================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,

                  children: [

                    Image.asset(
                      "assets/images/club_logo.png",
                      height: 70,
                      width: 70,
                      fit: BoxFit.contain,

                      errorBuilder:
                          (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50,
                        );
                      },
                    ),

                    Image.asset(
                      "assets/images/flag.png",
                      height: 70,
                      width: 70,
                      fit: BoxFit.contain,

                      errorBuilder:
                          (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50,
                        );
                      },
                    ),

                    Image.asset(
                      "assets/images/international_logo.png",
                      height: 70,
                      width: 70,
                      fit: BoxFit.contain,

                      errorBuilder:
                          (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ================= MAIN BOX =================

              Container(
                margin: const EdgeInsets.all(18),
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5DD),
                  borderRadius: BorderRadius.circular(25),

                  border: Border.all(
                    color: Colors.yellow,
                    width: 1.2,
                  ),
                ),

                child: Column(
                  children: [

                    // TITLE
                    const Text(
                      "Serving Menu",
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF273C8F),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      height: 4,
                      width: 270,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 35),

                    // ================= GRID =================

                    Wrap(
                      spacing: 20,
                      runSpacing: 25,
                      alignment: WrapAlignment.center,

                      children: [

                        MenuButton(
                          title: "Breakfast",
                          icon: Icons.breakfast_dining,
                          iconColor: const Color.fromARGB(255, 3, 112, 6),
                          color: const Color(0xFFE9F5D9),
                          borderColor: const Color.fromARGB(255, 3, 112, 6),

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const Breakfast(),
                              ),
                            );
                          },
                        ),

                        MenuButton(
                          title: "Lunch",
                          icon: Icons.lunch_dining,
                          iconColor: Colors.purple,
                          color: const Color(0xFFF3E5F5),
                          borderColor: Colors.purple,

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
                          iconColor: Colors.blue,
                          color: const Color(0xFFDDEEEF),
                          borderColor: Colors.blue,

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
                          iconColor: Colors.brown,
                          color: const Color(0xFFF3E8C9),
                          borderColor: Colors.brown,

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
                          iconColor: Colors.orange,
                          color: const Color(0xFFF9EDBE),
                          borderColor: Colors.orange,

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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {

  final String title;
  final IconData icon;
  final Color color;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback onTap;

  const MenuButton({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.borderColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 125,
        height: 125,

        decoration: BoxDecoration(
          color: color,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: borderColor,
            width: 1.2,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(2, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              size: 45,
              color: iconColor,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}