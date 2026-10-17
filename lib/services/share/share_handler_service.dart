import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../../Utiles/linkUtils.dart';
import '../../Utiles/utiles.dart';
import '../../controllers/addLink/addLinkController.dart';
import '../../screens/addLink/screens/AddLink/addLink.dart';

class ShareHandlerService {
  static StreamSubscription? _intentDataStreamSubscription;

  static void init() {
    // 1. App is currently in memory (Background)
    _intentDataStreamSubscription = ReceiveSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedMediaFile> value) {
      // isColdBoot is false because the app is already awake
      _processIncomingShare(value, isColdBoot: false);
    }, onError: (err) {
      debugPrint("Share Intent Error: $err");
    });

    // 2. App was completely closed (Terminated) and opened by a share
    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        // isColdBoot is true because the app just woke up
        _processIncomingShare(value, isColdBoot: true);
        ReceiveSharingIntent.instance.reset();
      }
    });
  }

  static Future<void> _processIncomingShare(List<SharedMediaFile> sharedFiles, {required bool isColdBoot}) async {
    if (sharedFiles.isEmpty) return;

    String sharedText = sharedFiles.first.path;
    String? rawUrl = LinkUtils.extractUrl(sharedText);

    if (rawUrl == null || !LinkUtils.isValidUrl(rawUrl)) {
      Utils.showErrorToast("No valid link found in shared text.");
      return;
    }

    // 1. Ensure AddLinkViewModel exists in memory and populate the shared link
    final controller = Get.isRegistered<AddLinkViewModel>()
        ? Get.find<AddLinkViewModel>()
        : Get.put(AddLinkViewModel());

    controller.populateLink(rawUrl);

    // 2. If it's a cold boot, delay for 400ms to let the Home Screen render first.
    // This completely eliminates the black screen visual glitch.
    if (isColdBoot) {
      await Future.delayed(const Duration(milliseconds: 400));
    }

    if (Get.currentRoute != '/AddLinkScreen') {
      Get.to(
            () => AddLinkScreen(initialSharedUrl: rawUrl),
        transition: Transition.downToUp,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      controller.populateLink(rawUrl);
    }

    Utils.showInAppToast("Link Captured", "Ready to save in LinkVault.");
  }

  static void dispose() {
    _intentDataStreamSubscription?.cancel();
  }
}