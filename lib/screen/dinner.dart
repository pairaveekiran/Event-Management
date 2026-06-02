import 'package:event_management/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:event_management/widgets/app_credit_footer.dart';
import 'package:event_management/services/event_service.dart';
import 'package:event_management/screens/meal_scan_screen.dart';

class Dinner
    extends StatefulWidget {
  const Dinner(
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
  State<Dinner> createState() =>
      _DinnerState();
}

class _DinnerState
    extends State<Dinner> {
  String
      dinnerName =
      "";
  bool
      _isManualEntryDialogOpen =
      false;
  bool
      _isManualEntryLoading =
      false;

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

  Future<void>
      _showManualEntryDialogue() async {
    if (_isManualEntryDialogOpen ||
        _isManualEntryLoading) {
      return;
    }

    final TextEditingController
        controller =
        TextEditingController();
    String
        errorText =
        '';
    bool
        submitted =
        false;

    if (!mounted) {
      controller.dispose();
      return;
    }

    setState(() {
      _isManualEntryDialogOpen = true;
      _isManualEntryLoading = false;
    });

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          Future<void> submitManualEntry() async {
            final String memberId = controller.text.trim().split('-').first.trim();
            if (memberId.isEmpty) {
              setDialogState(() {
                errorText = 'Member ID cannot be empty.';
              });
              return;
            }

            if (!mounted) {
              return;
            }

            setState(() {
              _isManualEntryLoading = true;
            });
            setDialogState(() {});

            try {
              final response = await EventService().postMealOrder(
                eventId: widget.categoryId ?? 0,
                mealType: 'DC',
                membershipNo: memberId,
              );

              if (!dialogContext.mounted) {
                return;
              }

              Navigator.of(dialogContext).pop();

              if (!mounted) {
                return;
              }

              submitted = true;
              await _showMealResultDialog(
                isSuccess: response.status,
                message: response.message,
                name: response.userName,
                drinksCount: response.drinksCount,
                membershipNo: memberId,
              );
            } catch (error) {
              if (!dialogContext.mounted) {
                return;
              }

              Navigator.of(dialogContext).pop();

              if (!mounted) {
                return;
              }

              submitted = true;
              await _showMealResultDialog(
                isSuccess: false,
                message: 'Error: ${error.toString()}',
                name: null,
                drinksCount: null,
                membershipNo: memberId,
              );
            } finally {
              if (mounted) {
                setState(() {
                  _isManualEntryLoading = false;
                });
              }
            }
          }

          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Manual Member ID Entry',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2A8A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    enabled: !_isManualEntryLoading,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Enter Member ID',
                      hintText: 'Enter Member ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.badge),
                      suffixIcon: controller.text.isNotEmpty
                          ? IconButton(
                              onPressed: _isManualEntryLoading
                                  ? null
                                  : () {
                                      controller.clear();
                                      setDialogState(() {
                                        errorText = '';
                                      });
                                    },
                              icon: const Icon(Icons.clear),
                            )
                          : null,
                      errorText: errorText.isEmpty ? null : errorText,
                    ),
                    onChanged: (_) {
                      if (errorText.isNotEmpty) {
                        setDialogState(() {
                          errorText = '';
                        });
                        return;
                      }

                      setDialogState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isManualEntryLoading || controller.text.isEmpty ? null : submitManualEntry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E2A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isManualEntryLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'SUBMIT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextButton(
                    onPressed: _isManualEntryLoading
                        ? null
                        : () {
                            setState(() {
                              _isManualEntryDialogOpen = false;
                              _isManualEntryLoading = false;
                            });
                            Navigator.of(dialogContext).pop();
                          },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    controller.dispose();

    if (!submitted &&
        mounted) {
      setState(() {
        _isManualEntryDialogOpen = false;
        _isManualEntryLoading = false;
      });
    }
  }

  Future<void>
      _showMealResultDialog({
    required bool
        isSuccess,
    required String
        message,
    required String?
        name,
    required String?
        drinksCount,
    required String
        membershipNo,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: isSuccess ? const Color(0xFF1B5E20) : const Color(0xFFB71C1C),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        isSuccess ? Icons.check_circle : Icons.cancel,
                        color: Colors.white,
                        size: 60,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isSuccess ? 'SUCCESS' : 'FAILED',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline, color: Color(0xFF1a237e), size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    name?.trim().isNotEmpty == true ? name!.trim() : 'N/A',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF1a237e),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.badge_outlined, color: Color(0xFF1a237e), size: 22),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Member ID',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  membershipNo,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF1a237e),
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSuccess ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSuccess ? const Color(0xFF4CAF50) : const Color(0xFFEF9A9A),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isSuccess ? const Color(0xFF1B5E20) : const Color(0xFFB71C1C),
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1a237e),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (mounted) {
                              setState(() {
                                _isManualEntryDialogOpen = false;
                                _isManualEntryLoading = false;
                              });
                            }
                          },
                          child: const Text(
                            'SCAN NEXT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
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

                Container(height: 4, color: Colors.yellow),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/club_logo.png",
                        height: 70,
                        width: 70,
                      ),
                      Image.asset(
                        "assets/images/international_logo.png",
                        height: 70,
                        width: 70,
                      ),
                      Image.asset(
                        "assets/images/flag.png",
                        height: 70,
                        width: 70,
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
                          "Dinner",
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
                        color: Colors.blue,
                      ),

                      const SizedBox(height: 30),

                      MealScanScreen(
                        mealType: 'DC',
                        eventId: widget.categoryId ?? 0,
                        accentColor: const Color(0xFF0288d1),
                        scannerEnabled: !_isManualEntryDialogOpen,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                            onPressed: _showManualEntryDialogue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E2A8A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Manual Entry',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            )),
                      )
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
