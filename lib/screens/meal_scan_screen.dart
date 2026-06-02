import 'package:event_management/services/event_service.dart';
import 'package:event_management/models/meal_order_response.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class MealScanScreen
    extends StatefulWidget {
  final String
      mealType;
  final int
      eventId;
  final Color
      accentColor;
  final bool
      showDrinksCount;
  final bool
      scannerEnabled;

  const MealScanScreen({
    required this.mealType,
    required this.eventId,
    required this.accentColor,
    this.showDrinksCount =
        false,
    this.scannerEnabled =
        true,
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
  bool
      _hasCameraPermission =
      false;
  bool
      _isCheckingPermission =
      true;
  String?
      _permissionMessage;

  @override
  void
      initState() {
    super.initState();
    _prepareCamera();
  }

  @override
  void
      dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void>
      _prepareCamera() async {
    final PermissionStatus
        status =
        await Permission.camera.status;

    if (!mounted) {
      return;
    }

    if (status.isGranted) {
      setState(() {
        _hasCameraPermission = true;
        _isCheckingPermission = false;
        _permissionMessage = null;
      });
      return;
    }

    final PermissionStatus
        requestStatus =
        await Permission.camera.request();

    if (!mounted) {
      return;
    }

    if (requestStatus.isGranted) {
      setState(() {
        _hasCameraPermission = true;
        _isCheckingPermission = false;
        _permissionMessage = null;
      });
      return;
    }

    setState(() {
      _hasCameraPermission = false;
      _isCheckingPermission = false;
      _permissionMessage = requestStatus.isPermanentlyDenied ? 'Camera permission is permanently denied. Open app settings to allow QR scanning.' : 'Camera permission is required to scan QR codes.';
    });
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
    if (!widget.scannerEnabled) {
      return;
    }

    // STEP 1: Guard — ignore if already scanned or processing
    if (_hasScanned ||
        _isProcessing) {
      return; // KEY FIX: ignore subsequent detections
    }

    if (capture.barcodes.isEmpty) {
      return;
    }

    final String?
        rawValue =
        capture.barcodes.first.rawValue;
    if (rawValue == null ||
        rawValue.isEmpty) {
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
        name: response.userName,
        drinksCount: response.drinksCount,
        membershipNo: membershipNo,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      await _showResultDialog(
        isSuccess: false,
        message: 'Error: ${e.toString()}',
        name: null,
        drinksCount: null,
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
                      if (widget.showDrinksCount) ...[
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
                              const Icon(Icons.local_drink_outlined, color: Color(0xFF1a237e), size: 22),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Drinks Count',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    drinksCount?.trim().isNotEmpty == true ? drinksCount!.trim() : '0',
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
                      ],
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

  Future<void>
      _resetScanner() {
    setState(() {
      _hasScanned = false;
      _isProcessing = false;
    });

    if (_hasCameraPermission) {
      return _cameraController.start();
    }

    return _prepareCamera();
  }

  @override
  Widget
      build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 340,
          width: double.infinity,
          child: _isCheckingPermission
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : !_hasCameraPermission
                  ? Container(
                      width: double.infinity,
                      height: 340,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8F8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE57373)),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.no_photography_outlined,
                            color: Color(0xFFB71C1C),
                            size: 52,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _permissionMessage ?? 'Camera permission is required to scan QR codes.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFB71C1C),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton(
                            onPressed: () async {
                              final PermissionStatus status = await Permission.camera.request();
                              if (!mounted) {
                                return;
                              }

                              if (status.isGranted) {
                                await _prepareCamera();
                                return;
                              }

                              if (status.isPermanentlyDenied) {
                                await openAppSettings();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1F2A74),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'ALLOW CAMERA',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : _isProcessing
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
                            errorBuilder: (context, error) {
                              return Container(
                                width: double.infinity,
                                height: 340,
                                color: Colors.black,
                                alignment: Alignment.center,
                                child: const Padding(
                                  padding: EdgeInsets.all(24),
                                  child: Text(
                                    'Camera unavailable. Check camera permission and device support.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }
}
