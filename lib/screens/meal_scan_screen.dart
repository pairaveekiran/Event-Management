import 'package:event_management/services/event_service.dart';
import 'package:event_management/models/meal_order_response.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MealScanScreen
    extends StatefulWidget {
  final String
      mealType;
  final String
      mealLabel;
  final int
      eventId;
  final Color
      accentColor;

  const MealScanScreen({
    required this.mealType,
    required this.mealLabel,
    required this.eventId,
    required this.accentColor,
    super.key,
  });

  @override
  State<MealScanScreen> createState() =>
      _MealScanScreenState();
}

class _MealScanScreenState
    extends State<MealScanScreen> {
  final MobileScannerController
      _cameraController =
      MobileScannerController();

  bool
      _isProcessing =
      false;
  bool
      _hasScanned =
      false; // KEY FIX: prevents duplicate scans

  String?
      _scannedMembership;

  @override
  void
      initState() {
    super.initState();
    _cameraController.start();
  }

  @override
  void
      dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  String
      _extractMembershipNo(String rawQrData) {
    final cleaned =
        rawQrData.trim();
    if (cleaned.contains('-')) {
      return cleaned.split('-')[0].trim();
    }
    return cleaned;
  }

  void _onQRDetected(
      BarcodeCapture capture) async {
    // STEP 1: Guard — ignore if already scanned or processing
    if (_hasScanned || _isProcessing) {
      return; // KEY FIX: ignore subsequent detections
    }

    final String?
        rawValue =
        capture.barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) {
      return;
    }

    // STEP 3: Lock further scans immediately
    if (!mounted) {
      return;
    }
    setState(() {
      _hasScanned = true;
      _isProcessing = true;
    });

    // STEP 4: Stop camera immediately — KEY FIX
    await _cameraController.stop();

    final String
        membershipNo =
        _extractMembershipNo(rawValue);
    if (!mounted) {
      return;
    }
    setState(() =>
        _scannedMembership = membershipNo);

    await _processMealOrder(membershipNo);
  }

  Future<void>
      _processMealOrder(String membershipNo) async {
    try {
      final MealOrderResponse response = await EventService().postMealOrder(
        eventId: widget.eventId,
        mealType: widget.mealType,
        membershipNo: membershipNo,
      );

      if (!mounted) {
        return;
      }

      await _showResultDialog(
        isSuccess: response.status,
        message: response.message,
        membershipNo: membershipNo,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      await _showResultDialog(
        isSuccess: false,
        message: 'Error: ${e.toString()}',
        membershipNo: membershipNo,
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void>
      _showResultDialog({
    required bool
        isSuccess,
    required String
        message,
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
                            _resetScanner();
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

  void
      _resetScanner() {
    setState(() {
      _hasScanned = false;
      _isProcessing = false;
      _scannedMembership = null;
    });
    _cameraController.start(); // restart camera for next scan
  }

  @override
  Widget
      build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 340,
          width: double.infinity,
          child: _isProcessing
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: widget.accentColor),
                      const SizedBox(height: 16),
                      const Text('Processing...', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: MobileScanner(
                    controller: _cameraController,
                    onDetect: _onQRDetected, // KEY FIX: stop on first detection
                  ),
                ),
        ),
        const SizedBox(height: 30),
        const Text(
          'Name:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _scannedMembership ?? '',
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
