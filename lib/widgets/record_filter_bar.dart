import 'package:flutter/material.dart';
import 'package:prtracker/models/record_filter.dart';

class RecordFilterBar extends StatefulWidget {
  final void Function(RecordFilter) onFilter;

  const RecordFilterBar({super.key, required this.onFilter});

  @override
  State<RecordFilterBar> createState() => _RecordFilterBarState();
}

class _RecordFilterBarState extends State<RecordFilterBar> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _exerciseTextController = TextEditingController();
  final TextEditingController _notesIncludeTextController =
      TextEditingController();
  RangeValues _repRangeValues = const RangeValues(0, 100);
  late DateTime _minDate;
  late DateTime _maxDate;
  late String _notesInclude;
  late bool _includesVideo;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: exerciseField(),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: repRangeSlider())),
                ],
              ),
            ),
            Expanded(
                child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: notesSearchBox(),
                  ),
                )
              ],
            )),
            Expanded(
                child: Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: applyFilterButton(context),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: resetFilterButton(context),
              ))
            ]))
          ],
        ));
  }

  Widget exerciseField() {
    return TextFormField(
      controller: _exerciseTextController,
      decoration: const InputDecoration(
          labelText: 'Exercise', border: OutlineInputBorder()),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.text,
    );
  }

  Widget repRangeSlider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Rep range'),
        RangeSlider(
            values: _repRangeValues,
            max: 100,
            min: 0,
            divisions: 100,
            labels: RangeLabels(_repRangeValues.start.round().toString(),
                _repRangeValues.end.round().toString()),
            onChanged: (RangeValues values) {
              setState(() {
                _repRangeValues = values;
              });
            }),
        ElevatedButton(
          onPressed: (() => {
                setState(() {
                  resetRangeValues();
                })
              }),
          child: const Text('Reset rep range'),
        )
      ],
    );
  }

  Widget notesSearchBox() {
    return TextFormField(
      controller: _notesIncludeTextController,
      decoration: const InputDecoration(
          labelText: 'Notes include', border: OutlineInputBorder()),
      textAlign: TextAlign.left,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: null,
      maxLines: null,
    );
  }

  Widget applyFilterButton(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Semantics(
            button: true,
            enabled: true,
            onLongPressHint: 'Filter records',
            child: ElevatedButton(
              child: const Text('Apply'),
              onPressed: () => applyFilter(),
            )));
  }

  Widget resetFilterButton(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Semantics(
            button: true,
            enabled: true,
            onLongPressHint: 'Reset filter',
            child: ElevatedButton(
              child: const Text('Reset filter'),
              onPressed: () {
                setState(() {
                  resetFilter();
                });
              },
            )));
  }

  void applyFilter() {
    if (_formKey.currentState!.validate()) {
      widget.onFilter(buildFilter());
    }
  }

  void resetFilter() {
    _exerciseTextController.text = '';
    _notesIncludeTextController.text = '';
    resetRangeValues();
    setState(() {
      applyFilter();
    });
  }

  void resetRangeValues() {
    _repRangeValues = const RangeValues(0, 100);
  }

  RecordFilter buildFilter() {
    return RecordFilter(
        exercise: _exerciseTextController.text,
        minReps: _repRangeValues.start.toInt(),
        maxReps: _repRangeValues.end.toInt(),
        notesInclude: _notesIncludeTextController.text);
  }
}
