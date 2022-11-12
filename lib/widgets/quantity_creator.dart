import 'package:flutter/material.dart';
import 'package:prtracker/models/record.dart';

class QuantityCreator extends StatefulWidget {
  final Function(RecordQuantity) onParentSaved;
  final RecordQuantity? initialQuantity;

  const QuantityCreator({
    super.key,
    required this.onParentSaved,
    this.initialQuantity,
  });

  @override
  State<QuantityCreator> createState() => _QuantityCreatorState();
}

class _QuantityCreatorState extends State<QuantityCreator> {
  TextEditingController? _weightQuantityTextController;
  RecordUnits _selectedUnits = RecordUnits.POUNDS;

  @override
  void initState() {
    super.initState();
    _weightQuantityTextController =
        TextEditingController(text: widget.initialQuantity?.amount.toString());
    _selectedUnits = widget.initialQuantity?.units ?? RecordUnits.POUNDS;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<RecordQuantity>(
      builder: (formFieldState) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: weightQuantityField())),
              Flexible(
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: unitsDropdown()))
            ]);
      },
    );
  }

  void onSaved() {
    final RecordQuantity recordQuantity = buildRecordQuantity();
    widget.onParentSaved(recordQuantity);
  }

  Widget weightQuantityField() {
    return TextFormField(
        controller: _weightQuantityTextController,
        decoration: const InputDecoration(
            labelText: 'Quantity', border: OutlineInputBorder()),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.headline5,
        validator: (value) => validateWeightQuantity(value));
  }

  String? validateWeightQuantity(String? value) {
    if (value == null || value.isEmpty || int.tryParse(value) == null) {
      return 'Enter an integer value for the number of pounds, kilograms, or plates.';
    } else {
      return null;
    }
  }

  // https://api.flutter.dev/flutter/material/showDatePicker.html
  Widget unitsDropdown() {
    return DropdownButton<RecordUnits>(
      items: RecordUnitsMap.entries.map<DropdownMenuItem<RecordUnits>>((entry) {
        return DropdownMenuItem<RecordUnits>(
            value: entry.key, child: Text(entry.value));
      }).toList(),
      value: _selectedUnits,
      onChanged: (value) {
        setState(() {
          _selectedUnits = value!;
        });
      },
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 2,
      ),
    );
  }

  RecordQuantity buildRecordQuantity() {
    return RecordQuantity(
        units: _selectedUnits,
        amount: int.parse(_weightQuantityTextController!.text),
        change: 0,
        perSide: false);
  }
}
