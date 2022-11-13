import 'package:prtracker/models/record.dart';

class RecordFilter {
  String? exercise;
  int? minReps;
  int? maxReps;

  RecordFilter({this.exercise, this.minReps, this.maxReps});
}
