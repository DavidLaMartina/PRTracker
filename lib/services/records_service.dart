import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:prtracker/config/constants.dart';
import 'package:prtracker/models/record_filter.dart';
import 'package:prtracker/utils/string_utils.dart';
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
  final Database _database = GetIt.I.get();
  final _store = intMapStoreFactory.store('records_store');

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
        .query(finder: Finder(sortOrders: [SortOrder('date', false, false)]))
        .onSnapshots(_database)
        .transform(recordsTransformer);
  }

  Stream<List<Record>> onRecordsFilter(RecordFilter? filter) {
    if (filter == null) {
      return onRecords();
    }
    return _store
        .query(
            finder: Finder(
                filter: Filter.and(buildRecordFilters(filter)),
                sortOrders: [SortOrder('date', false, false)]))
        .onSnapshots(_database)
        .transform(recordsTransformer);
  }

  List<Filter> buildRecordFilters(RecordFilter filter) {
    final List<Filter> filters = [];
    if (!isNullOrEmpty(filter.exercise)) {
      filters.add(Filter.matchesRegExp(
          EXERCISE_KEY, RegExp(filter.exercise!, caseSensitive: false)));
    }
    if (filter.minReps != null) {
      filters.add(Filter.greaterThanOrEquals(REPS_KEY, filter.minReps));
    }
    if (filter.maxReps != null) {
      filters.add(Filter.lessThanOrEquals(REPS_KEY, filter.maxReps));
    }
    if (filter.minDate != null) {
      filters.add(Filter.greaterThanOrEquals(
          DATE_KEY, filter.minDate!.millisecondsSinceEpoch));
    }
    if (filter.maxDate != null) {
      filters.add(Filter.lessThanOrEquals(
          DATE_KEY, filter.minDate!.millisecondsSinceEpoch));
    }
    if (!isNullOrEmpty(filter.notesInclude)) {
      filters.add(Filter.custom((record) =>
          (record[NOTES_KEY] as String).contains(filter.notesInclude!)));
    }
    return filters;
  }
}
