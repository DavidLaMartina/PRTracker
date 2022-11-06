import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:prtracker/models/record.dart';

Record snapshotToRecord(RecordSnapshot snapshot) {
  return Record.fromMap(
      snapshot.key as int, snapshot.value as Map<String, dynamic>);
}

class Records extends ListBase<Record> {
  final List<RecordSnapshot<int, Map<String, Object?>>> list;
  late List<Record?> _cacheRecords;

  Records(this.list) {
    _cacheRecords = List.generate(list.length, (index) => null);
  }

  @override
  Record operator [](int index) {
    return _cacheRecords[index] ??= snapshotToRecord(list[index]);
  }

  @override
  int get length => list.length;

  @override
  void operator []=(int index, Record? value) => 'read-only';

  @override
  set length(int newLength) => throw 'read-only';
}

// Credit to https://bettercoding.dev/flutter/sembast-local-data-storage/
// for the general scheme of a sembast repository and init class

class RecordsService extends ChangeNotifier {
  final String appDocumentsDirectoryPath;
  final Database _database = GetIt.I.get();
  final _store = intMapStoreFactory.store('records_store');

  RecordsService({required this.appDocumentsDirectoryPath});

  String? getRecordThumbnailUri(Record record) {
    return join(appDocumentsDirectoryPath, record.thumbnailUri);
  }

  String? getRecordViedoUri(Record record) {
    return join(appDocumentsDirectoryPath, record.videoUri);
  }

  Future<int> insertRecord(Record record) async {
    return await _store.add(_database, record.toMap());
  }

  Future updateRecord(Record record) async {
    await _store.record(record.id!).update(_database, record.toMap());
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

  var recordsTransformer = StreamTransformer<
      List<RecordSnapshot<int, Map<String, Object?>>>,
      List<Record>>.fromHandlers(handleData: (snapshotList, sink) {
    sink.add(Records(snapshotList));
  });

  Stream<List<Record>> onRecords() {
    return _store
        .query(finder: Finder(sortOrders: [SortOrder('date')]))
        .onSnapshots(_database)
        .transform(recordsTransformer);
  }
}
