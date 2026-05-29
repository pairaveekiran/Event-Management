class MealsConfig {
  final bool
      showBreakfast;
  final bool
      showLunch;
  final bool
      showDinner;
  final bool
      showTea;
  final bool
      showDrinks;
  final int
      maxDrink;

  const MealsConfig({
    required this.showBreakfast,
    required this.showLunch,
    required this.showDinner,
    required this.showTea,
    required this.showDrinks,
    required this.maxDrink,
  });

  factory MealsConfig.fromJson(
      Map<String, dynamic> json) {
    final Map<String, dynamic>
        meals =
        (json['meals'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

    bool
        isOn(String key) {
      return meals[key]?.toString().trim().toLowerCase() == 'on';
    }

    final int
        maxDrink =
        int.tryParse(meals['max_drink']?.toString() ?? '') ?? 0;

    return MealsConfig(
      showBreakfast: isOn('BFC'),
      showLunch: isOn('LC'),
      showDinner: isOn('DC'),
      showTea: isOn('TC'),
      showDrinks: isOn('drinks'),
      maxDrink: maxDrink,
    );
  }

  Map<String, dynamic>
      toJson() {
    return <String,
        dynamic>{
      'meals': <String, dynamic>{
        'BFC': showBreakfast ? 'on' : 'off',
        'LC': showLunch ? 'on' : 'off',
        'DC': showDinner ? 'on' : 'off',
        'TC': showTea ? 'on' : 'off',
        'drinks': showDrinks ? 'on' : 'off',
        'max_drink': maxDrink,
      },
    };
  }
}
