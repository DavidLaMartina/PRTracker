import 'package:flutter/material.dart';
import 'package:prtracker/models/record_filter.dart';

class RecordFilterBar extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _exerciseTextController = TextEditingController();
  final TextEditingController _minRepsTextController = TextEditingController();
  final TextEditingController _maxRepsTextController = TextEditingController();

  final void Function(RecordFilter) onFilter;

  RecordFilterBar({super.key, required this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: exerciseField(),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: minRepsField(),
            )),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(10), child: maxRepsField())),
            Expanded(
              child: filterButton(context),
            )
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

  Widget minRepsField() {
    return TextFormField(
      controller: _minRepsTextController,
      decoration: const InputDecoration(
          labelText: 'Min. reps', border: OutlineInputBorder()),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value != null &&
            int.parse(value) > int.parse(_maxRepsTextController.text)) {
          return 'Min reps must be lower than or equal to max reps.';
        } else {
          return null;
        }
      },
    );
  }

  Widget maxRepsField() {
    return TextFormField(
      controller: _minRepsTextController,
      decoration: const InputDecoration(
          labelText: 'Min. reps', border: OutlineInputBorder()),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value != null &&
            int.parse(value) < int.parse(_minRepsTextController.text)) {
          return 'Max reps must be greater than or equal to min reps.';
        } else {
          return null;
        }
      },
    );
  }

  Widget filterButton(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Semantics(
            button: true,
            enabled: true,
            onLongPressHint: 'Filter records',
            child: ElevatedButtonTheme(
                data: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue)),
                child: ElevatedButton(
                  onPressed: () => applyFilter(),
                  child: const Text('Apply'),
                ))));
  }

  void applyFilter() {
    if (_formKey.currentState!.validate()) {
      onFilter(buildFilter());
    }
  }

  RecordFilter buildFilter() {
    return RecordFilter(
        exercise: _exerciseTextController.text,
        minReps: int.parse(_minRepsTextController.text),
        maxReps: int.parse(_maxRepsTextController.text));
  }
}
