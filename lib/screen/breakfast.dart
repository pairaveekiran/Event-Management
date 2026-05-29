import 'package:event_management/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Breakfast
    extends StatefulWidget {
  const Breakfast(
      {super.key,
      this.categoryTitle,
      this.categoryDate,
      this.categoryVenue});

  final String?
      categoryTitle;
  final String?
      categoryDate;
  final String?
      categoryVenue;

  @override
  State<Breakfast> createState() =>
      _BreakfastState();
}

class _BreakfastState
    extends State<Breakfast> {
  final MobileScannerController
      controller =
      MobileScannerController();

  String
      foodName =
      "";

  @override
  void
      initState() {
    super.initState();
    controller.start();
  }

  @override
  void
      dispose() {
    controller.dispose();
    super.dispose();
  }

  void
      goToMainPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ServingMenuUI(
          categoryTitle: widget.categoryTitle,
          categoryDate: widget.categoryDate,
          categoryVenue: widget.categoryVenue,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget
      build(BuildContext context) {
    final String
        headerTitle =
        widget.categoryTitle ?? "Alliance Leadership Development Institute(ALDI)-2026";
    final String headerDate = (widget.categoryDate?.trim().isNotEmpty ?? false)
        ? widget.categoryDate!.trim()
        : "Date not available";
    final String headerVenue = (widget.categoryVenue?.trim().isNotEmpty ?? false)
        ? widget.categoryVenue!.trim()
        : "Venue not available";
    final String
        headerDateVenue =
        '$headerDate, $headerVenue';
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
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: goToMainPage,
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Back',
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
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
                              ],
                            ),
                          ),
                          const SizedBox(width: 28),
                        ],
                      ),
                      const SizedBox(height: 5),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          headerTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        headerDateVenue,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE
                      const Center(
                        child: Text(
                          "Breakfast",
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
                        color: const Color.fromARGB(255, 3, 112, 6),
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
                            final List<Barcode> barcodes = capture.barcodes;

                            for (final barcode in barcodes) {
                              setState(() {
                                foodName = barcode.rawValue ?? "";
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
