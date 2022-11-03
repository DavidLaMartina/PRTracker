import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:prtracker/models/record.dart';

// Credit to https://bettercoding.dev/flutter/sembast-local-data-storage/
// for the general scheme of a sembast repository and init class

class RecordsService extends ChangeNotifier {
  final Database _database = GetIt.I.get();
  final StoreRef _store = intMapStoreFactory.store('records_store');

  Future<int> insertRecord(Record record) async {
    return await _store.add(_database, record.toMap());
  }

  Future updateRecord(Record record) async {
    await _store.record(record.id).update(_database, record.toMap());
  }

  Future deleteRecord(int recordId) async {
    await _store.record(recordId).delete(_database);
  }

  Future<List<Record>> getAllRecords() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map((snapshot) => Record.fromMap(snapshot.key, snapshot.value))
        .toList(growable: false);
  }

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
          reps: 10),
      Record(
          date: DateTime.now(),
          exercise: 'squat',
          quantity: RecordQuantity(
            amount: 225,
            units: RecordUnits.POUNDS,
            perSide: false,
          ),
          reps: 10)
    ];
    yield records;
  }
}
