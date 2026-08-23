import 'package:flutter/material.dart';

import '../models/cooking_option_model.dart';
import '../services/cooking_option_service.dart';

class CookingSelectionDialog extends StatefulWidget {
  final String productId;

  const CookingSelectionDialog({
    super.key,
    required this.productId,
  });

  @override
  State<CookingSelectionDialog> createState() =>
      _CookingSelectionDialogState();
}

class _CookingSelectionDialogState
    extends State<CookingSelectionDialog> {

  final CookingOptionService _service =
      CookingOptionService();

  List<CookingOptionModel> options = [];

  CookingOptionModel? selectedOption;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadOptions();
  }

  Future<void> loadOptions() async {

    options =
        await _service.getCookingOptions(widget.productId);

    if (options.isNotEmpty) {
      selectedOption = options.first;
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(

        padding: const EdgeInsets.all(20),

        child: loading

            ? const SizedBox(
                height: 250,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )

            : Column(

                mainAxisSize: MainAxisSize.min,

                children: [

                  const Icon(
                    Icons.restaurant_menu,
                    size: 45,
                    color: Colors.red,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "How are you planning to cook this?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ...options.map((item) {

                    return RadioListTile<CookingOptionModel>(

                      value: item,

                      groupValue: selectedOption,

                      activeColor: Colors.red,

                      title: Text(item.name),

                      subtitle: Text(item.cutType),

                      onChanged: (value) {

                        setState(() {
                          selectedOption = value;
                        });

                      },
                    );

                  }),

                  const SizedBox(height: 15),

                  SizedBox(

                    width: double.infinity,

                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                      ),

                      onPressed: () {

                        Navigator.pop(
                          context,
                          selectedOption,
                        );

                      },

                      child: const Text(
                        "Continue",
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}