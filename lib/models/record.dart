import 'package:prtracker/config/constants.dart';

class Record {
  late int? id;
  DateTime date;
  String exercise;
  RecordQuantity quantity;
  int reps;
  String? notes;
  String? videoUri;
  String? thumbnailUri;

  Record(
      {this.id,
      required this.date,
      required this.exercise,
      required this.quantity,
      required this.reps,
      this.notes,
      this.videoUri,
      this.thumbnailUri});

  Map<String, dynamic> toMap() {
    return {
      DATE_KEY: date.toString(),
      EXERCISE_KEY: exercise,
      QUANTITY_KEY: quantity.toMap(),
      REPS_KEY: reps,
      NOTES_KEY: notes,
      VIDEO_URI_KEY: videoUri,
      THUMBNAIL_URI_KEY: thumbnailUri
    };
  }

  factory Record.fromMap(int id, Map<String, dynamic> map) {
    return Record(
        id: id,
        date: DateTime.parse(map[DATE_KEY]),
        exercise: map[EXERCISE_KEY],
        quantity: RecordQuantity.fromMap(map[QUANTITY_KEY]),
        reps: map[REPS_KEY],
        notes: map[NOTES_KEY],
        videoUri: map[VIDEO_URI_KEY],
        thumbnailUri: map[THUMBNAIL_URI_KEY]);
  }
}

class RecordQuantity {
  RecordUnits units;
  int amount;
  double? change;
  bool perSide;

  RecordQuantity(
      {required this.units,
      required this.amount,
      required this.perSide,
      this.change});

  Map<String, dynamic> toMap() {
    return {
      UNITS_KEY: units.toString(),
      AMOUNT_KEY: amount,
      CHANGE_KEY: change,
      PERSIDE_KEY: perSide
    };
  }

  factory RecordQuantity.fromMap(Map<String, dynamic> map) {
    return RecordQuantity(
        units: RecordUnitsStringMap[map[UNITS_KEY]]!,
        amount: map[AMOUNT_KEY],
        change: map[CHANGE_KEY],
        perSide: map[PERSIDE_KEY]);
  }
}

enum RecordUnits {
  POUNDS,
  KILOGRAMS,
  PLATES,
}

Map<String, RecordUnits> RecordUnitsStringMap = {
  RecordUnits.POUNDS.toString(): RecordUnits.POUNDS,
  RecordUnits.KILOGRAMS.toString(): RecordUnits.KILOGRAMS,
  RecordUnits.PLATES.toString(): RecordUnits.PLATES
};

Map<RecordUnits, String> RecordUnitsMap = {
  RecordUnits.POUNDS: 'lbs.',
  RecordUnits.KILOGRAMS: 'kg',
  RecordUnits.PLATES: 'plates'
};
