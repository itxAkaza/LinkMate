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
      _processIncomingShare(value);
    }, onError: (err) {
      debugPrint("Share Intent Error: $err");
    });

    // 2. App was completely closed (Terminated) and opened by a share
    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        _processIncomingShare(value);
        ReceiveSharingIntent.instance.reset();
      }
    });
  }

  static void _processIncomingShare(List<SharedMediaFile> sharedFiles) {
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

    // 2. Wait until navigation tree is ready, then open AddLinkScreen directly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute != '/AddLinkScreen') {
        Get.to(() => const AddLinkScreen());
      }
      Utils.showInAppToast("Link Captured", "Loaded into Add Link screen.");
    });
  }

  static void dispose() {
    _intentDataStreamSubscription?.cancel();
  }
}