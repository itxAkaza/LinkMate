import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/link_model.dart';
import '../../Utiles/utiles.dart';
import '../../Utiles/app_haptic.dart';

class LinkDetailViewModel extends GetxController {
  final LinkItem link;

  LinkDetailViewModel({required this.link});

  InAppWebViewController? webViewController;

  RxDouble progress = 0.0.obs;
  RxBool isLoading = true.obs;
  RxBool hasError = false.obs;
  RxString currentUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    currentUrl.value = link.url;
  }

  void onProgressChanged(InAppWebViewController controller, int progressValue) {
    progress.value = progressValue / 100;
    if (progressValue == 100) {
      isLoading.value = false;
    }
  }

  void onLoadStart(InAppWebViewController controller, WebUri? url) {
    isLoading.value = true;
    hasError.value = false;
    if (url != null) {
      currentUrl.value = url.toString();
    }
  }

  void onLoadStop(InAppWebViewController controller, WebUri? url) {
    isLoading.value = false;
    if (url != null) {
      currentUrl.value = url.toString();
    }
  }

  // FIXED: Added "?? false" to handle the nullable boolean
  void onReceivedError(InAppWebViewController controller, WebResourceRequest request, WebResourceError error) {
    if (request.isForMainFrame ?? false) {
      isLoading.value = false;
      hasError.value = true;
      AppHaptics.errorVibrate();
    }
  }

  // FIXED: Moved webViewController?.reload() INSIDE the closing bracket
  void reloadPage() {
    AppHaptics.lightTap();
    hasError.value = false;
    isLoading.value = true;
    webViewController?.reload();
  }

  Future<void> openInExternalBrowser() async {
    AppHaptics.lightTap();
    final Uri uri = Uri.parse(currentUrl.value);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Utils.showErrorToast("Could not open external browser");
    }
  }
}