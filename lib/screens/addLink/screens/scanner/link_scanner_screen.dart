import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../Utiles/linkUtils.dart';
import '../../../../resources/colors/app_colors.dart';


class ScanLinkScreen extends StatefulWidget {
  const ScanLinkScreen({super.key});

  @override
  State<ScanLinkScreen> createState() => _ScanLinkScreenState();
}

class _ScanLinkScreenState extends State<ScanLinkScreen> {
  bool isScanning = true;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final Rect scanWindowRectangle = Rect.fromCenter(
      center: screenSize.center(Offset.zero),
      width: 250,
      height: 250,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // LAYER 1: Camera
          MobileScanner(
            scanWindow: scanWindowRectangle,
            overlayBuilder: (context, constraints) => const SizedBox(),
            onDetect: (capture) {
              if (!isScanning) return;

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                final String rawData = barcodes.first.rawValue!;

                // Fallback: If it's not a URL, we don't accept it
                if (!LinkUtils.isValidUrl(rawData)) {
                  setState(() => isScanning = false);
                  Get.snackbar(
                    'Invalid QR',
                    'This does not contain a valid web link.',
                    backgroundColor: AppColors.dangerRed,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(20),
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) setState(() => isScanning = true);
                  });
                  return;
                }

                // Success! Return the URL back to AddLinkScreen
                Get.back(result: rawData);
              }
            },
          ),

          // LAYER 2: Overlay
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Center(
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LAYER 3: Frame
          Center(
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.iconBlue, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // LAYER 4: Instructions
          const Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Text(
              "Align QR code within the frame",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // LAYER 5: Back Button
          Positioned(
            top: 50,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Get.back(),
            ),
          )
        ],
      ),
    );
  }
}