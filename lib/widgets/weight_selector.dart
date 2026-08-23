import 'package:flutter/material.dart';

class WeightSelector extends StatelessWidget {
  final List<int> weights;
  final int selectedWeight;
  final ValueChanged<int> onChanged;

  const WeightSelector({
    super.key,
    required this.weights,
    required this.selectedWeight,
    required this.onChanged,
  });

  String _label(int value) {
    if (value >= 1000) {
      return "${value ~/ 1000} Kg";
    }

    return "${value}g";
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: weights.map((weight) {
        final selected = weight == selectedWeight;

        return ChoiceChip(
          label: Text(_label(weight)),
          selected: selected,
          onSelected: (_) => onChanged(weight),
          selectedColor: Colors.green,
          backgroundColor: Colors.grey.shade200,
          showCheckmark: false,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected
                ? Colors.white
                : Colors.black87,
          ),
        );
      }).toList(),
    );
  }
}