class Record {
  DateTime date;
  String exercise;
  RecordQuantity quantity;
  int reps;
  String? notes;
  String? videoUri;

  Record({
    required this.date,
    required this.exercise,
    required this.quantity,
    required this.reps,
    this.videoUri,
  });
}

class RecordQuantity {
  RecordUnits units;
  double amount;
  double? change;
  bool perSide;

  RecordQuantity(
      {required this.units,
      required this.amount,
      required this.perSide,
      this.change});
}

enum RecordUnits {
  POUNDS,
  KILOGRAMS,
  PLATES,
}
