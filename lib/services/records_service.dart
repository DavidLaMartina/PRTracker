import 'package:flutter/material.dart';
import 'package:prtracker/models/record.dart';

class RecordsService extends ChangeNotifier {
  int recordTotal = 0;

  Stream<List<Record>> onRecords() async* {
    var records = [
      Record(
          date: DateTime.now(), exercise: 'bench press', pounds: 135, reps: 10),
      Record(date: DateTime.now(), exercise: 'squat', pounds: 225, reps: 10),
      Record(date: DateTime.now(), exercise: 'deadlift', pounds: 315, reps: 10),
    ];
    int count = 0;
    yield records;
  }
}
