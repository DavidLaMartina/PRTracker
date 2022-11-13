import 'package:prtracker/models/record.dart';

class RecordFilter {
  String? exercise;
  int? minReps;
  int? maxReps;
  DateTime? minDate;
  DateTime? maxDate;
  String? notesInclude;
  bool? includesVideo;

  RecordFilter(
      {this.exercise,
      this.minReps,
      this.maxReps,
      this.minDate,
      this.maxDate,
      this.notesInclude,
      this.includesVideo});
}
