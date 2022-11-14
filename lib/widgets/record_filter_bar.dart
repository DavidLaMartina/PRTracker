import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTime? _minDate;
  DateTime? _maxDate;
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
                          padding: const EdgeInsets.all(10),
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
                      child: dateRangePicker()))
            ])),
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
                  resetRepRangeValues();
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

  Widget dateRangePicker() {
    return Column(children: [
      Expanded(
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text('Latest date'),
            ),
            datePickerButton((DateTime? newMinDate) {
              setState(() {
                if (newMinDate != null) {
                  _minDate = newMinDate;
                }
              });
            }, _minDate, 'Select earliest date'),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: resetDateButton(context, 'Reset earliest date', (() {
                setState(() {
                  _minDate = null;
                });
              })),
            ))
          ],
        ),
      ),
      Expanded(
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text('Earliest date'),
            ),
            datePickerButton((DateTime? newMaxDate) {
              setState(() {
                if (newMaxDate != null) {
                  _maxDate = newMaxDate;
                }
              });
            }, _maxDate, 'Select latest date'),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: resetDateButton(context, 'Reset latest date', (() {
                    setState(() {
                      _maxDate = null;
                    });
                  }))),
            )
          ],
        ),
      )
    ]);
  }

  Widget datePickerButton(Function(DateTime?) onDateSelected,
      DateTime? currentSelection, String altText) {
    return ElevatedButton(
        child: currentSelection != null
            ? Text(DateFormat.yMd().format(currentSelection))
            : Text(altText),
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: currentSelection ?? DateTime.now(),
              firstDate: DateTime(1990),
              lastDate: DateTime.now());
          if (newDate == null) return;
          onDateSelected(newDate);
        });
  }

  Widget resetDateButton(
      BuildContext context, String labelText, void Function() onPressed) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Semantics(
            button: true,
            enabled: true,
            onLongPressHint: 'Reset date',
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(labelText),
            )));
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
    setState(() {
      _exerciseTextController.text = '';
      _notesIncludeTextController.text = '';
      resetRepRangeValues();
      resetDateValues();
      applyFilter();
    });
  }

  void resetRepRangeValues() {
    _repRangeValues = const RangeValues(0, 100);
  }

  void resetDateValues() {
    _minDate = null;
    _maxDate = null;
  }

  RecordFilter buildFilter() {
    return RecordFilter(
        exercise: _exerciseTextController.text,
        minReps: _repRangeValues.start.toInt(),
        maxReps: _repRangeValues.end.toInt(),
        minDate: _minDate,
        maxDate: _maxDate,
        notesInclude: _notesIncludeTextController.text);
  }
}
