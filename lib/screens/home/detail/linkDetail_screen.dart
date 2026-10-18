import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../controllers/linkDeatil/linkDeatilController.dart';
import '../../../model/link_model.dart';
import '../../../resources/colors/app_colors.dart';

class LinkDetailScreen extends StatelessWidget {
  final LinkItem link;

  const LinkDetailScreen({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    // Initialize controller specific to this link
    final controller = Get.put(LinkDetailViewModel(link: link), tag: link.key.toString());

    return Scaffold(
      backgroundColor: AppColors.readOnlyBg,
      appBar: AppBar(
        backgroundColor: AppColors.readOnlyBg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textColorBlack),
          onPressed: () => Get.back(),
        ),
        title: Text(
          link.displayDescription,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.manrope(
            color: AppColors.textColorBlack,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Open in Browser",
            icon: const Icon(LucideIcons.externalLink, color: AppColors.textColorBlack, size: 20),
            onPressed: controller.openInExternalBrowser,
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Obx(() => controller.isLoading.value && !controller.hasError.value
              ? LinearProgressIndicator(
            value: controller.progress.value > 0 ? controller.progress.value : null,
            backgroundColor: Colors.transparent,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.iconBlue),
            minHeight: 2.0,
          )
              : const SizedBox(height: 2.0)),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // 1. The WebView
            Obx(() => Offstage(
              offstage: controller.hasError.value,
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(link.url)),
                initialSettings: InAppWebViewSettings(
                  transparentBackground: true,
                  supportZoom: true,
                  javaScriptEnabled: true,
                ),
                onWebViewCreated: (webController) {
                  controller.webViewController = webController;
                },
                onLoadStart: controller.onLoadStart,
                onLoadStop: controller.onLoadStop,
                onProgressChanged: controller.onProgressChanged,
                onReceivedError: controller.onReceivedError,
              ),
            )),

            // 2. The Premium Fallback Error UI
            Obx(() {
              if (controller.hasError.value) {
                return _buildErrorState(controller);
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(LinkDetailViewModel controller) {
    return Container(
      color: AppColors.backgroundWhite,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.dangerRed.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.wifiOff,
              size: 48,
              color: AppColors.dangerRed,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Page Failed to Load",
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textColorBlack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We couldn't reach this website. Please check your internet connection or verify if the link is still active.",
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: AppColors.subTitleColorGary,
            ),
          ),
          const SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.black12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: controller.openInExternalBrowser,
                  icon: const Icon(LucideIcons.externalLink, size: 18, color: AppColors.textColorBlack),
                  label: Text(
                    "Try Browser",
                    style: GoogleFonts.manrope(
                      color: AppColors.textColorBlack,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.iconBlue,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: controller.reloadPage,
                  icon: const Icon(LucideIcons.refreshCcw, size: 18, color: Colors.white),
                  label: Text(
                    "Try Again",
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}