class WeightOption {

  final String label;
  final double multiplier;

  WeightOption({
    required this.label,
    required this.multiplier,
  });

  factory WeightOption.fromMap(Map<String,dynamic> json){

    return WeightOption(
      label: json["label"],
      multiplier: (json["multiplier"] as num).toDouble(),
    );

  }

}