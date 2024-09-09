import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// A reusable form widget that displays a label with a child widget aligned to the right.
class FormWidget extends StatelessWidget {
  final String label; // Label text for the form field
  final Widget child; // The widget displayed to the right of the label

  const FormWidget({
    Key? key,
    required this.label,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Adds padding around the widget
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          // Displays the label on the left
          Text(label, style: const TextStyle(fontSize: 14.0)),

          // Expands the child widget to the right side of the row
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: child, // The child widget (e.g., input field, dropdown, etc.)
            ),
          )
        ],
      ),
    );
  }
}

// A custom dropdown select widget using CupertinoPicker for iOS-style selection.
class FormSelect<T> extends StatefulWidget {
  final String placeholder; // Placeholder text shown when no value is selected
  final ValueChanged<T> valueChanged; // Callback when a value is selected
  final List<T> values; // List of selectable values
  final T value; // The current selected value

  const FormSelect({
    Key? key,
    required this.placeholder,
    required this.valueChanged,
    required this.value,
    required this.values,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FormSelectState<T>();
  }
}

// State class for handling the selection logic of FormSelect
class _FormSelectState<T> extends State<FormSelect<T>> {
  int _selectedIndex = 0; // Tracks the index of the currently selected value

  @override
  void initState() {
    // Initialize the selected index to match the current value
    for (var i = 0; i < widget.values.length; ++i) {
      if (widget.values[i] == widget.value) {
        _selectedIndex = i;
        break;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = widget.placeholder;
    final values = widget.values;

    return InkWell(
      // Displays the current selection or placeholder text
      child: Text(
          _selectedIndex < 0 ? placeholder : values[_selectedIndex].toString()),

      // Opens a bottom sheet with the CupertinoPicker for value selection
      onTap: () {
        _selectedIndex = 0;
        showBottomSheet(
            context: context,
            builder: (context) {
              return SizedBox(
                height: values.length * 30.0 + 200.0, // Dynamic height based on values
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // CupertinoPicker for selecting values
                    SizedBox(
                      height: values.length * 30.0 + 70.0,
                      child: CupertinoPicker(
                        itemExtent: 30.0, // Height of each item in the picker
                        children: values.map((value) {
                          return Text(value.toString()); // Display each value as text
                        }).toList(),
                        onSelectedItemChanged: (index) {
                          _selectedIndex = index; // Update selected index
                        },
                      ),
                    ),
                    // Button to confirm the selection
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_selectedIndex >= 0) {
                            widget.valueChanged(
                              widget.values[_selectedIndex], // Trigger the callback with the selected value
                            );
                          }

                          setState(() {});

                          Navigator.of(context).pop(); // Close the bottom sheet
                        },
                        child: const Text('ok'),
                      ),
                    )
                  ],
                ),
              );
            });
      },
    );
  }
}

// A number input widget that allows the user to increment or decrement a value by a step.
class NumberPad extends StatelessWidget {
  final num number; // The current number value
  final num step; // The step by which to increase or decrease the number
  final num max; // Maximum allowable value
  final num min; // Minimum allowable value
  final ValueChanged<num> onChangeValue; // Callback when the number changes

  const NumberPad({
    Key? key,
    required this.number,
    required this.step,
    required this.onChangeValue,
    required this.max,
    required this.min,
  }) : super(key: key);

  // Method to increment the number, ensuring it doesn't exceed the maximum value
  void onAdd() {
    onChangeValue(number + step > max ? max : number + step);
  }

  // Method to decrement the number, ensuring it doesn't go below the minimum value
  void onSub() {
    onChangeValue(number - step < min ? min : number - step);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Ensure the row takes up minimal width
      children: <Widget>[
        // Button to decrement the number
        IconButton(icon: const Icon(Icons.exposure_neg_1), onPressed: onSub),

        // Display the current number, with formatting based on type (int or double)
        Text(
          number is int ? number.toString() : number.toStringAsFixed(1),
          style: const TextStyle(fontSize: 14.0),
        ),

        // Button to increment the number
        IconButton(icon: const Icon(Icons.exposure_plus_1), onPressed: onAdd)
      ],
    );
  }
}

// © 2024 Berk Emre Mert and EğiTeam