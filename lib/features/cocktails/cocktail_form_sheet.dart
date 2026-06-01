part of '../../main.dart';

class CocktailFormSheet extends StatefulWidget {
  const CocktailFormSheet({this.cocktail, super.key});

  final Cocktail? cocktail;

  @override
  State<CocktailFormSheet> createState() => _CocktailFormSheetState();
}

class _CocktailFormSheetState extends State<CocktailFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final List<_IngredientControllers> _ingredientControllers = [];
  final ImagePicker _imagePicker = ImagePicker();
  late final TextEditingController _nameController;
  late final TextEditingController _stepsController;
  String _imageBase64 = '';

  @override
  void initState() {
    super.initState();
    final cocktail = widget.cocktail;
    _nameController = TextEditingController(text: cocktail?.name ?? '');
    _stepsController =
        TextEditingController(text: cocktail?.steps.join('\n') ?? '');
    _imageBase64 = cocktail?.imageBase64 ?? '';

    if (cocktail == null || cocktail.ingredients.isEmpty) {
      _ingredientControllers.add(_IngredientControllers.empty());
    } else {
      _ingredientControllers.addAll(
        cocktail.ingredients.map(_IngredientControllers.fromIngredient),
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
                title:
                    widget.cocktail == null ? 'Add cocktail' : 'Edit cocktail',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Cocktail name',
                  prefixIcon: Icon(Icons.local_bar),
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
                  _imageBase64.isEmpty
                      ? 'Choose cocktail image'
                      : 'Change image',
                ),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 4),
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(
                  labelText: 'Mixing steps',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.format_list_numbered),
                ),
                minLines: 5,
                maxLines: 9,
                validator: requiredValidator,
              ),
              const SizedBox(height: 20),
              SaveButton(label: 'Save cocktail', onPressed: _saveCocktail),
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

  void _saveCocktail() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cocktail = Cocktail(
      id: widget.cocktail?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
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

    Navigator.of(context).pop(cocktail);
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
