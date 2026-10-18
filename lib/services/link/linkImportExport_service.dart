import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../Utiles/linkUtils.dart';
import '../../data/repositories/link_repository.dart';
import '../../model/link_model.dart';




enum ExportFileType { csv, xlsx }

class ImportResult {
  final int importedCount;
  final int duplicateSkippedCount;
  final int invalidSkippedCount;
  final String? errorMessage;

  ImportResult({
    this.importedCount = 0,
    this.duplicateSkippedCount = 0,
    this.invalidSkippedCount = 0,
    this.errorMessage,
  });

  bool get hasError => errorMessage != null;
}

class LinkImportExportService {
  final LinkRepository _repository = LinkRepository();

  static const List<String> headers = [
    'LinkName',
    'Link',
    'Category',
    'IsFavorite',
    'Tags',
  ];

  // ===========================================================================
  // 1. EXPORT LINKS TO CSV OR EXCEL (.XLSX)
  // ===========================================================================
  Future<String?> exportLinks({
    required List<LinkItem> links,
    required ExportFileType fileType,
  }) async {
    if (links.isEmpty) {
      throw Exception("No links available to export.");
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = fileType == ExportFileType.csv ? 'csv' : 'xlsx';
    final fileName = 'LinkVault_Backup_$timestamp.$extension';

    late final Uint8List fileBytes;

    if (fileType == ExportFileType.csv) {
      fileBytes = _generateCsvBytes(links);
    } else {
      fileBytes = _generateExcelBytes(links);
    }

    // 1. Let user pick save location directly via native OS Save Dialog (Android/iOS)
    String? savedFilePath = await FilePicker.saveFile(
      dialogTitle: 'Save LinkVault Backup',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: [extension],
      bytes: fileBytes,
    );

    // 2. Fallback: Save to app documents directory & open Share sheet if user cancels direct save picker
    if (savedFilePath == null) {
      final dir = await getApplicationDocumentsDirectory();
      final fallbackFile = File('${dir.path}/$fileName');
      await fallbackFile.writeAsBytes(fileBytes, flush: true);

      await Share.shareXFiles(
        [XFile(fallbackFile.path)],
        subject: 'LinkVault Backup ($extension)',
      );
      return fallbackFile.path;
    }

    return savedFilePath;
  }

  Uint8List _generateCsvBytes(List<LinkItem> links) {
    final List<List<dynamic>> rows = [headers];

    for (final link in links) {
      rows.add([
        link.displayDescription,
        link.url,
        link.category ?? 'Web',
        link.isFavourite ? 'TRUE' : 'FALSE',
        link.tags.join(', '),
      ]);
    }

    final String csvString = csv.encode(rows);
    return Uint8List.fromList(utf8.encode(csvString));
  }

  Uint8List _generateExcelBytes(List<LinkItem> links) {
    final excel = Excel.createExcel();
    final String defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
    final Sheet sheet = excel[defaultSheet];

    // Header Row
    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());

    // Data Rows
    for (final link in links) {
      sheet.appendRow([
        TextCellValue(link.displayDescription),
        TextCellValue(link.url),
        TextCellValue(link.category ?? 'Web'),
        TextCellValue(link.isFavourite ? 'TRUE' : 'FALSE'),
        TextCellValue(link.tags.join(', ')),
      ]);
    }

    final encoded = excel.encode();
    if (encoded == null) {
      throw Exception("Failed to encode Excel file.");
    }
    return Uint8List.fromList(encoded);
  }

  // ===========================================================================
  // 2. PICK, VALIDATE & IMPORT CSV OR EXCEL (.XLSX)
  // ===========================================================================
  Future<ImportResult?> pickAndImportFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null; // User cancelled picker
    }

    final pickedFile = result.files.single;
    final ext = (pickedFile.extension ?? '').toLowerCase();

    if (ext != 'csv' && ext != 'xlsx') {
      return ImportResult(
        errorMessage: "Unsupported file format. Please select a .CSV or .XLSX file.",
      );
    }

    try {
      final Uint8List bytes = pickedFile.bytes ??
          await File(pickedFile.path!).readAsBytes();

      List<List<String>> rawRows = [];

      if (ext == 'csv') {
        rawRows = _parseCsvBytes(bytes);
      } else {
        rawRows = _parseExcelBytes(bytes);
      }

      return await _validateAndSaveRows(rawRows);
    } catch (e) {
      return ImportResult(
        errorMessage: "Could not read file. Make sure it is a valid CSV or Excel file.",
      );
    }
  }

  List<List<String>> _parseCsvBytes(Uint8List bytes) {
    final content = utf8.decode(bytes, allowMalformed: true);
    // NEW csv v8 API: Use csv.decode(content) instead of CsvToListConverter
    final dynamicRows = csv.decode(content);
    return dynamicRows
        .map((row) => row.map((cell) => cell?.toString().trim() ?? '').toList())
        .toList();
  }

  List<List<String>> _parseExcelBytes(Uint8List bytes) {
    final excel = Excel.decodeBytes(bytes);
    final List<List<String>> rows = [];

    for (final table in excel.tables.keys) {
      final sheet = excel.tables[table];
      if (sheet == null) continue;

      for (final row in sheet.rows) {
        final cleanRow = row
            .map((cell) => cell?.value?.toString().trim() ?? '')
            .toList();
        if (cleanRow.any((element) => element.isNotEmpty)) {
          rows.add(cleanRow);
        }
      }
      break; // Read first non-empty sheet
    }
    return rows;
  }

  Future<ImportResult> _validateAndSaveRows(List<List<String>> rows) async {
    // Filter out completely blank rows
    final nonEmptyRows = rows
        .where((r) => r.any((cell) => cell.trim().isNotEmpty))
        .toList();

    if (nonEmptyRows.length < 2) {
      return ImportResult(
        errorMessage: "File is empty or missing data rows beneath the header.",
      );
    }

    // 1. Validate Header Row (Case-exact or case-insensitive support)
    final headerRow = nonEmptyRows.first.map((h) => h.trim()).toList();

    final int nameIdx = headerRow.indexWhere((h) => h == 'LinkName' || h.toLowerCase() == 'linkname');
    final int linkIdx = headerRow.indexWhere((h) => h == 'Link' || h.toLowerCase() == 'link');
    final int catIdx = headerRow.indexWhere((h) => h == 'Category' || h.toLowerCase() == 'category');
    final int favIdx = headerRow.indexWhere((h) => h == 'IsFavorite' || h.toLowerCase() == 'isfavorite');
    final int tagsIdx = headerRow.indexWhere((h) => h == 'Tags' || h.toLowerCase() == 'tags');

    if (nameIdx == -1 || linkIdx == -1) {
      return ImportResult(
        errorMessage: "Missing required columns: 'LinkName' and 'Link' must be present in the first row.",
      );
    }

    int imported = 0;
    int duplicates = 0;
    int invalid = 0;

    // 2. Process Each Row (Skip duplicates gracefully without stopping!)
    for (int i = 1; i < nonEmptyRows.length; i++) {
      final row = nonEmptyRows[i];

      String rawName = nameIdx < row.length ? row[nameIdx].trim() : '';
      String rawUrl = linkIdx < row.length ? row[linkIdx].trim() : '';

      // Validate required fields
      if (rawName.isEmpty || rawUrl.isEmpty) {
        invalid++;
        continue;
      }

      final normalizedUrl = LinkUtils.normalizeUrl(rawUrl);
      if (!LinkUtils.isValidUrl(normalizedUrl)) {
        invalid++;
        continue;
      }

      // Check duplicate in Hive (Skip only this duplicate, keep importing others!)
      if (_repository.isDuplicate(normalizedUrl)) {
        duplicates++;
        continue;
      }

      // Optional Category
      String category = (catIdx != -1 && catIdx < row.length && row[catIdx].trim().isNotEmpty)
          ? row[catIdx].trim()
          : LinkUtils.detectCategory(normalizedUrl);

      await _repository.ensureCategoryExists(category);

      // Optional IsFavorite
      bool isFav = false;
      if (favIdx != -1 && favIdx < row.length) {
        final favStr = row[favIdx].trim().toUpperCase();
        isFav = (favStr == 'TRUE' || favStr == '1' || favStr == 'YES');
      }

      // Optional Tags
      List<String> tags = [];
      if (tagsIdx != -1 && tagsIdx < row.length && row[tagsIdx].trim().isNotEmpty) {
        tags = row[tagsIdx]
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }

      final newItem = LinkItem(
        url: normalizedUrl,
        description: rawName,
        metaTitle: rawName,
        category: category,
        isFavourite: isFav,
        tags: tags,
        isPrivate: false,
        status: 'pending',
      );

      await _repository.saveLink(newItem);
      imported++;
    }

    return ImportResult(
      importedCount: imported,
      duplicateSkippedCount: duplicates,
      invalidSkippedCount: invalid,
    );
  }
}