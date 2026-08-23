import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.green,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          InkWell(
            onTap: onRemove,
            child: const SizedBox(
              width: 40,
              child: Icon(Icons.remove,color: Colors.green),
            ),
          ),

          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                quantity.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          InkWell(
            onTap: onAdd,
            child: const SizedBox(
              width: 40,
              child: Icon(Icons.add,color: Colors.green),
            ),
          ),

        ],
      ),
    );
  }
}