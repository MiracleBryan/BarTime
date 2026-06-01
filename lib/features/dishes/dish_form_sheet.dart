part of '../../main.dart';

class DishFormSheet extends StatefulWidget {
  const DishFormSheet({this.dish, super.key});

  final Dish? dish;

  @override
  State<DishFormSheet> createState() => _DishFormSheetState();
}

class _DishFormSheetState extends State<DishFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final List<_IngredientControllers> _ingredientControllers = [];
  final ImagePicker _imagePicker = ImagePicker();
  late final TextEditingController _nameController;
  late final TextEditingController _stepsController;
  String _imageBase64 = '';

  @override
  void initState() {
    super.initState();
    final dish = widget.dish;
    _nameController = TextEditingController(text: dish?.name ?? '');
    _stepsController =
        TextEditingController(text: dish?.steps.join('\n') ?? '');
    _imageBase64 = dish?.imageBase64 ?? '';

    if (dish == null || dish.ingredients.isEmpty) {
      _ingredientControllers.add(_IngredientControllers.empty());
    } else {
      _ingredientControllers.addAll(
        dish.ingredients.map(_IngredientControllers.fromIngredient),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stepsController.dispose();
    for (final controllers in _ingredientControllers) {
      controllers.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FormHeader(
                title: widget.dish == null ? 'Add dish' : 'Edit dish',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Dish name',
                  prefixIcon: Icon(Icons.restaurant),
                ),
                textInputAction: TextInputAction.next,
                validator: requiredValidator,
              ),
              const SizedBox(height: 16),
              RecipeImage(imageBase64: _imageBase64, height: 180),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library),
                label: Text(
                  _imageBase64.isEmpty ? 'Choose dish image' : 'Change image',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ingredients',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: 'Add ingredient',
                    onPressed: _addIngredient,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._ingredientControllers.indexed.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _IngredientMeasureRow(
                    controllers: entry.$2,
                    canRemove: _ingredientControllers.length > 1,
                    onRemove: () => _removeIngredient(entry.$1),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(
                  labelText: 'Cooking steps',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.format_list_numbered),
                ),
                minLines: 5,
                maxLines: 9,
                validator: requiredValidator,
              ),
              const SizedBox(height: 20),
              SaveButton(label: 'Save dish', onPressed: _saveDish),
            ],
          ),
        ),
      ),
    );
  }

  void _addIngredient() {
    setState(() {
      _ingredientControllers.add(_IngredientControllers.empty());
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      final removed = _ingredientControllers.removeAt(index);
      removed.dispose();
    });
  }

  void _saveDish() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final dish = Dish(
      id: widget.dish?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      ingredients: _ingredientControllers
          .map(
            (controllers) => RecipeIngredient(
              name: controllers.name.text.trim(),
              amount: controllers.amount.text.trim(),
              unit: controllers.unit,
            ),
          )
          .toList(),
      steps: linesFrom(_stepsController.text),
      imageBase64: _imageBase64,
    );

    Navigator.of(context).pop(dish);
  }

  Future<void> _pickImage() async {
    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 78,
    );

    if (pickedImage == null) {
      return;
    }

    final bytes = await pickedImage.readAsBytes();
    setState(() {
      _imageBase64 = base64Encode(bytes);
    });
  }
}
