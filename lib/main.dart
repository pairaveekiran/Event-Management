import 'package:flutter/material.dart';

import 'package:event_management/screens/event_dropdown_screen.dart';
import 'package:event_management/screen/homescreen.dart';

void
    main() {
  runApp(
      const MyApp());
}

class MyApp
    extends StatelessWidget {
  const MyApp(
      {super.key});

  @override
  Widget
      build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const EventDropdownScreen(),
        '/home': (context) => const ServingMenuUI(),
      },
    );
  }
}


class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  String? selectedEvent;

  final List<String> events = [
    "Alliance Leadership Development Institute(ALDI)-2026",
    "Breakfast",
    "Lunch",
    "Dinner",
    "Tea",
    "Drinks",
  ];

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

                    SizedBox(height: 8),

                    Text(
                      "District 1055, Nepal",
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "2026-06-06, Kahukot Resort, Kahudanda",
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 4,
                color: Colors.yellow,
              ),

              const SizedBox(height: 30),

              // ================= LOGOS =================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    Image.asset(
                      "assets/images/club_logo.png",
                      height: 70,
                      width: 70,
                      fit: BoxFit.contain,
                    ),

                    Image.asset(
                      "assets/images/flag.png",
                      height: 70,
                      width: 70,
                      fit: BoxFit.contain,
                    ),

                    Image.asset(
                      "assets/images/international_logo.png",
                      height: 70,
                      width: 70,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ================= MAIN CONTAINER =================

              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                padding: const EdgeInsets.all(20),

                height: 450,

                decoration: BoxDecoration(
                  color: const Color(0xFFF3F1D9),

                  borderRadius: BorderRadius.circular(28),

                  border: Border.all(
                    color: Colors.yellow,
                    width: 1.2,
                  ),
                ),

                child: Column(
                  children: [

                    // ================= TITLE =================

                    const Text(
                      "Choose Event",

                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2A74),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ================= DROPDOWN =================

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),

                        borderRadius:
                            BorderRadius.circular(22),

                        border: Border.all(
                          color: Colors.black87,
                        ),
                      ),

                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedEvent,

                          hint: const Text(
                            "Select Event",

                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),

                          isExpanded: true,

                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                          ),

                          items: events.map((String event) {

                            return DropdownMenuItem<String>(
                              value: event,

                              child: Text(
                                event,

                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),

                          onChanged: (String? newValue) {

                            setState(() {
                              selectedEvent = newValue;
                            });
                          },
                        ),
                      ),
                    ),

                    const Spacer(),

                    // ================= BUTTON =================

                    SizedBox(
                      width: 180,
                      height: 75,

                      child: ElevatedButton(
                        onPressed: () {

                          if (selectedEvent == null) {

                            ScaffoldMessenger.of(context)
                                .showSnackBar(

                              const SnackBar(
                                content: Text(
                                  "Please select an event",
                                ),
                              ),
                            );

                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ServingMenuUI(),
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFD7263D),

                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(22),
                          ),
                        ),

                        child: const Text(
                          "Proceed",

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

