import 'package:tf_csv/tf_csv.dart';

Future<void> main() async {
  final csv = TfCsv();
  csv
    ..addRow(
        TfCsvRow.fromList(["Firstname", "Lastname", "Marks", "Plays Cricket"]))
    ..addRow(TfCsvRow.fromList(["Rahul", "Badgujar", 96.2, true]))
    ..addRow(TfCsvRow.fromList(["Suyash", "Nehete", 97.6]))
    ..addRow(TfCsvRow.fromList(["Sahil Hemnani", "Badgujar", 98.1, false]));
  await csv.saveAsCsv(destinationFileLocation: 'temp/marks.csv');
  await csv.saveAsExcel(
      destinationFileLocation: 'temp/marks.xlsb', sheetName: 'default');
}
