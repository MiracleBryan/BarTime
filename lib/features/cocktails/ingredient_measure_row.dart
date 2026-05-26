part of '../../main.dart';

class _IngredientControllers {
  _IngredientControllers({
    required this.name,
    required this.amount,
    required this.unit,
  });

  factory _IngredientControllers.empty() {
    return _IngredientControllers(
      name: TextEditingController(),
      amount: TextEditingController(),
      unit: 'g',
    );
  }

  factory _IngredientControllers.fromIngredient(RecipeIngredient ingredient) {
    return _IngredientControllers(
      name: TextEditingController(text: ingredient.name),
      amount: TextEditingController(text: ingredient.amount),
      unit: ingredient.unit,
    );
  }

  final TextEditingController name;
  final TextEditingController amount;
  String unit;

  void dispose() {
    name.dispose();
    amount.dispose();
  }
}

class _IngredientMeasureRow extends StatefulWidget {
  const _IngredientMeasureRow({
    required this.controllers,
    required this.canRemove,
    required this.onRemove,
  });

  final _IngredientControllers controllers;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  State<_IngredientMeasureRow> createState() => _IngredientMeasureRowState();
}

class _IngredientMeasureRowState extends State<_IngredientMeasureRow> {
  static const _units = ['g', 'ml'];

  @override
  Widget build(BuildContext context) {
    final controllers = widget.controllers;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controllers.name,
            decoration: const InputDecoration(
              labelText: 'Ingredient',
              prefixIcon: Icon(Icons.spa),
            ),
            validator: requiredValidator,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: controllers.amount,
            decoration: const InputDecoration(
              labelText: 'Amount',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: requiredValidator,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          child: DropdownButtonFormField<String>(
            initialValue:
                _units.contains(controllers.unit) ? controllers.unit : 'g',
            decoration: const InputDecoration(labelText: 'Unit'),
            items: _units
                .map(
                  (unit) => DropdownMenuItem(
                    value: unit,
                    child: Text(unit),
                  ),
                )
                .toList(),
            onChanged: (unit) {
              if (unit == null) {
                return;
              }

              setState(() {
                controllers.unit = unit;
              });
            },
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          tooltip: 'Remove ingredient',
          onPressed: widget.canRemove ? widget.onRemove : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
      ],
    );
  }
}
