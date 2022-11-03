class Record {
  late int? id;
  DateTime date;
  String exercise;
  RecordQuantity quantity;
  int reps;
  String? notes;
  String? videoUri;

  Record({
    this.id,
    required this.date,
    required this.exercise,
    required this.quantity,
    required this.reps,
    this.notes,
    this.videoUri,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'exercise': exercise,
      'quantity': quantity.toMap(),
      'reps': reps,
      'notes': notes,
      'videoUri': videoUri
    };
  }

  factory Record.fromMap(int id, Map<String, dynamic> map) {
    return Record(
        id: id,
        date: map['date'],
        exercise: map['exercise'],
        quantity: RecordQuantity.fromMap(map['quantity']),
        reps: map['reps'],
        notes: map['notes'],
        videoUri: map['videoUri']);
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
      'units': units.toString(),
      'amount': amount,
      'change': change,
      'perSide': perSide
    };
  }

  factory RecordQuantity.fromMap(Map<String, dynamic> map) {
    return RecordQuantity(
        units: RecordUnitsStringMap[map['units']]!,
        amount: map['amount'],
        change: map['change'],
        perSide: map['perSide']);
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
