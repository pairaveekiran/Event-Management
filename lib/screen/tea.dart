import 'package:event_management/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:event_management/widgets/app_credit_footer.dart';
import 'package:event_management/screens/meal_scan_screen.dart';

class Tea
    extends StatefulWidget {
  const Tea(
      {super.key,
      this.categoryId,
      this.categoryTitle,
      this.categoryDate,
      this.categoryVenue});

  final int?
      categoryId;
  final String?
      categoryTitle;
  final String?
      categoryDate;
  final String?
      categoryVenue;

  @override
  State<Tea> createState() =>
      _TeaState();
}

class _TeaState
    extends State<Tea> {
  String
      teaName =
      "";

  void
      goToMainPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ServingMenuUI(
          categoryId: widget.categoryId,
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
        bottomNavigationBar: const AppCreditFooter(),
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
                Text(
                  headerDateVenue,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),

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
                        "assets/images/international_logo.png",
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
                          "Tea",
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
                        color: Colors.brown,
                      ),

                      const SizedBox(height: 30),

                      MealScanScreen(
                        mealType: 'TC',
                        mealLabel: 'Tea',
                        eventId: widget.categoryId ?? 0,
                        accentColor: const Color(0xFF5d4037),
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
