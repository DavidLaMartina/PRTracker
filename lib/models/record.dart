class Record {
  DateTime date;
  String exercise;
  int pounds;
  int reps;
  String? notes;
  String? videoUri;

  Record({
    required this.date,
    required this.exercise,
    required this.pounds,
    required this.reps,
    this.videoUri,
  });
}
