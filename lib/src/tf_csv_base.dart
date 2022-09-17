import 'dart:math';
import 'dart:io';
import 'package:csv/csv.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:excel/excel.dart';
import 'package:tf_csv/src/model/tf_csv_row.dart';

class TfCsv {
  static const List<String> ALLOWED_CSV_FILE_EXTENSIONS = ['csv'];
  static const List<String> ALLOWED_EXCEL_FILE_EXTENSIONS = ['xlsx'];

  static const DEFAULT_EXCEL_SHEET_NAME = 'Sheet1';

  List<TfCsvRow> rows = [];

  void addRow(TfCsvRow row) {
    rows.add(row);
  }

  void addRows(List<TfCsvRow> rows) {
    rows.addAll(rows);
  }

  int get numberOfRows => rows.length;

  bool get isEmpty => rows.isEmpty;

  void _fit() {
    if (isEmpty) return;
    int maxColumns = rows[0].numberOfColumns;
    for (int i = 1; i < numberOfRows; ++i) {
      maxColumns = max(maxColumns, rows[i].numberOfColumns);
    }
    for (final row in rows) {
      row.fillTillColumns(maxColumns);
    }
  }

  void _build() {
    _fit();
  }

  List<List<dynamic>> get tabulated {
    _build();
    return rows.map((row) => row.values).toList();
  }

  String get stringified {
    return ListToCsvConverter().convert(tabulated);
  }

  Future<File> saveAsCsv({required String destinationFileLocation}) async {
    _ensureFileExtension(destinationFileLocation, ALLOWED_CSV_FILE_EXTENSIONS);
    final file = await File(destinationFileLocation).create(recursive: true);
    await file.writeAsString(stringified);
    return file;
  }

  Future<List<int>> get csvBytes async {
    final file = await saveAsCsv(destinationFileLocation: "_temp__/temp.csv");
    final fileBytes = await file.readAsBytes();
    await file.delete();
    return fileBytes;
  }

  Future<List<int>> encodeToExcelFileBytes(
      {String? sheetName = DEFAULT_EXCEL_SHEET_NAME}) async {
    final excel = Excel.createExcel();
    if (sheetName != DEFAULT_EXCEL_SHEET_NAME) {
      excel.rename(DEFAULT_EXCEL_SHEET_NAME, sheetName);
    }
    final sheet = excel[sheetName];
    for (final tblRow in tabulated) {
      sheet.appendRow(tblRow);
    }
    final fileBtyes = excel.encode();
    return fileBtyes;
  }

  Future<File> saveAsExcel(
      {required String destinationFileLocation, String? sheetName}) async {
    _ensureFileExtension(
        destinationFileLocation, ALLOWED_EXCEL_FILE_EXTENSIONS);
    final bytes = await encodeToExcelFileBytes(sheetName: sheetName);
    final file = await File(destinationFileLocation).create(recursive: true);
    await file.writeAsBytes(bytes);
    return file;
  }

  static void _ensureFileExtension(
      String filePath, List<String> allowedExtensions) {
    final matchesAnyExtesion = allowedExtensions
        .map((ext) => filePath.endsWith(".$ext"))
        .any((e) => e);
    assert(matchesAnyExtesion,
        'File extension missing or invalid for file path: $filePath, allowed file extensions: $allowedExtensions');
  }
}
