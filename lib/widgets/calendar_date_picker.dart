import 'package:flutter/material.dart';

// Ideas / content from https://api.flutter.dev/flutter/material/showDatePicker.html
class PRTrackerDatePicker extends StatefulWidget {
  final String? restorationId;
  final String? caption;
  final void Function(DateTime?)? onDateSelected;

  const PRTrackerDatePicker(
      {super.key,
      required this.restorationId,
      required this.caption,
      required this.onDateSelected});

  @override
  // ignore: library_private_types_in_public_api
  _PRTrackerDatePickerState createState() => _PRTrackerDatePickerState();
}

// TODO: Get rid of restoration properties - anti-pattern to have the date picker
// restoring its state while also passing it back to owner, which is also maintaining
// the selected date (They're both maintaining the same value).
class _PRTrackerDatePickerState extends State<PRTrackerDatePicker>
    with RestorationMixin {
  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() => {_selectedDate.value = newSelectedDate});
    }
    widget.onDateSelected!(newSelectedDate);
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: OutlinedButton(
                onPressed: () => _restorableDatePickerRouteFuture.present(),
                child: const Text('Open date selector'))));
  }

  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
          onComplete: _selectDate,
          onPresent: (NavigatorState navigator, Object? arguments) {
            return navigator.restorablePush(_datePickerRoute,
                arguments: _selectedDate.value.millisecondsSinceEpoch);
          });

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
        context: context,
        builder: (BuildContext context) {
          return DatePickerDialog(
              restorationId: 'date_picker_dialog',
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              initialDate:
                  DateTime.fromMillisecondsSinceEpoch(arguments! as int),
              firstDate: DateTime(2021),
              lastDate: DateTime(2023));
        });
  }
}
