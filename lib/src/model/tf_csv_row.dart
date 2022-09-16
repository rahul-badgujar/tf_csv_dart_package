class TfCsvRow {
  List<dynamic> _values;

  TfCsvRow({List<dynamic> values = const []}) : _values = values;

  factory TfCsvRow.fromList(List<dynamic> values) {
    return TfCsvRow(values: values);
  }

  int get numberOfColumns => _values.length;

  bool get isEmpty => _values.isEmpty;

  void fillTillColumns(int noOfColumns, {dynamic fillNewColumnsWith}) {
    if (numberOfColumns < noOfColumns) {
      _values = List.generate(
          noOfColumns,
          (index) =>
              index < numberOfColumns ? _values[index] : fillNewColumnsWith);
    }
  }

  void shrinkTillColumns(int noOfColumns) {
    if (numberOfColumns > noOfColumns) {
      _values = List.generate(noOfColumns, (index) => _values[index]);
    }
  }

  dynamic get(int index) {
    __checkIndexConstraints(index);
    return _values[index];
  }

  void set(int index, dynamic value) {
    __checkIndexConstraints(index);
    _values[index] = value;
  }

  void appendValue(dynamic value) {
    _values.add(value);
  }

  void appendValues(List<dynamic> values) {
    _values.addAll(values);
  }

  void __checkIndexConstraints(int index) {
    assert(index < numberOfColumns,
        "Index out of range for TfCsvRow.get(), maximum allowed index: ${numberOfColumns - 1}");
    assert(index >= 0, "Index cannot be negative for TfCsvRow.get()");
  }

  List<dynamic> get values {
    return _values;
  }
}
