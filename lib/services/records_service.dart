import 'package:flutter/material.dart';
import 'package:prtracker/models/record.dart';

class RecordsService extends ChangeNotifier {
  int recordTotal = 0;

  Stream<List<Record>> onRecords() async* {
    var records = [
      Record(date: DateTime.now(), videoUri: 'dummy1'),
      Record(date: DateTime.now(), videoUri: 'dummy2'),
      Record(date: DateTime.now(), videoUri: 'dummy3')
    ];
    int count = 0;
    yield records;
  }
}
