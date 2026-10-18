import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../Utiles/app_haptic.dart';
import '../../Utiles/utiles.dart';
import '../../data/repositories/link_repository.dart';
import '../../model/link_model.dart';
import '../../services/link/linkImportExport_service.dart';


class ImportExportController extends GetxController {
  final LinkRepository repository = LinkRepository();
  final LinkImportExportService _service = LinkImportExportService();

  final Rx<ExportFileType> selectedExportType = ExportFileType.csv.obs;
  final RxBool isProcessing = false.obs;
  final RxString lastExportTime = 'Never'.obs;

  ValueListenable<Box<LinkItem>> get listenableLinks => repository.listenableLinks;

  @override
  void onInit() {
    super.onInit();
    _loadLastExportTime();
  }

  void _loadLastExportTime() {
    final saved = repository.getLastExportTime();
    if (saved != null && saved.isNotEmpty) {
      lastExportTime.value = saved;
    }
  }

  void setExportType(ExportFileType type) {
    AppHaptics.lightTap();
    selectedExportType.value = type;
  }

  Future<void> exportAllLinks() async {
    if (isProcessing.value) return;

    final links = repository.listenableLinks.value.values
        .where((l) => !l.isPrivate)
        .toList();

    if (links.isEmpty) {
      AppHaptics.errorVibrate();
      Utils.showErrorToast("No links available to export!");
      return;
    }

    try {
      isProcessing.value = true;
      AppHaptics.lightTap();

      final savedPath = await _service.exportLinks(
        links: links,
        fileType: selectedExportType.value,
      );

      if (savedPath != null) {
        final formattedNow = DateFormat('dd MMM yyyy, h:mm a').format(DateTime.now());
        await repository.saveLastExportTime(formattedNow);
        lastExportTime.value = formattedNow;

        AppHaptics.mediumTap();
        final formatLabel = selectedExportType.value == ExportFileType.csv ? "CSV" : "Excel (.xlsx)";
        Utils.showSuccessToast("Exported ${links.length} links as $formatLabel!");
      }
    } catch (e) {
      AppHaptics.errorVibrate();
      Utils.showErrorToast("Export failed: ${e.toString().replaceAll('Exception: ', '')}");
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> importLinksFromFile() async {
    if (isProcessing.value) return;

    try {
      isProcessing.value = true;
      AppHaptics.lightTap();

      final result = await _service.pickAndImportFile();
      if (result == null) {
        // User cancelled file picker
        return;
      }

      if (result.hasError) {
        AppHaptics.errorVibrate();
        Utils.showErrorToast(result.errorMessage!);
        return;
      }

      AppHaptics.mediumTap();
      Get.back(); // Return from Format Guide Screen to Import/Export Screen

      String summary = "Imported ${result.importedCount} links.";
      if (result.duplicateSkippedCount > 0) {
        summary += " (${result.duplicateSkippedCount} duplicates skipped)";
      }
      if (result.invalidSkippedCount > 0) {
        summary += " (${result.invalidSkippedCount} invalid skipped)";
      }

      if (result.importedCount > 0) {
        Utils.showSuccessToast(summary);
      } else {
        Utils.showInAppToast("Import Complete", summary);
      }
    } finally {
      isProcessing.value = false;
    }
  }
}