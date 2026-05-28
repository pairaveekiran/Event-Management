import 'package:event_management/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';



class Lunch extends StatefulWidget {
  const Lunch({super.key});

  @override
  State<Lunch> createState() => _LunchState();
}

class _LunchState extends State<Lunch> {

  final MobileScannerController controller =
      MobileScannerController();

  String foodName = "";

  @override
  void initState() {
    super.initState();
    controller.start();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void goToMainPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const ServingMenuUI(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onHorizontalDragUpdate: (details) {

        // Swipe right to go back
        if (details.delta.dx > 15) {
          goToMainPage();
        }
      },

      child: Scaffold(
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
                  height: 4,
                  color: Colors.yellow,
                ),

                const SizedBox(height: 20),

                // ================= LOGOS =================

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
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

                const SizedBox(height: 10),

                // ================= MAIN BOX =================

                Container(
                  margin: const EdgeInsets.all(18),

                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F3D9),

                    borderRadius: BorderRadius.circular(25),

                    border: Border.all(
                      color: Colors.yellow,
                      width: 1.2,
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      // TITLE
                      const Center(
                        child: Text(
                          "Lunch",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2A74),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        height: 3,
                        width: double.infinity,
                        color: Colors.purple,
                      ),

                      const SizedBox(height: 30),

                      // ================= QR SCANNER =================

                      Container(
                        height: 340,
                        width: double.infinity,

                        decoration: BoxDecoration(
                          color: Colors.grey[300],

                          border: Border.all(
                            color: Colors.black54,
                          ),
                        ),

                        child: MobileScanner(
                          controller: controller,

                          onDetect: (capture) {

                            final List<Barcode> barcodes =
                                capture.barcodes;

                            for (final barcode
                                in barcodes) {

                              setState(() {

                                foodName =
                                    barcode.rawValue ?? "";
                              });
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ================= NAME =================

                      const Text(
                        "Name:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        foodName,

                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}