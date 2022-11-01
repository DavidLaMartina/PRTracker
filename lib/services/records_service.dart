import 'package:flutter/material.dart';
import 'package:prtracker/models/record.dart';

class RecordsService extends ChangeNotifier {
  int recordTotal = 0;

  Stream<List<Record>> onRecords() async* {
    var records = [
      Record(
          date: DateTime.now(),
          exercise: 'bench press',
          quantity: RecordQuantity(
            amount: 135,
            units: RecordUnits.POUNDS,
            perSide: false,
          ),
          reps: 10)
    ];
    int count = 0;
    yield records;
  }
}
