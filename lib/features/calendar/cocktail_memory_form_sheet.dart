part of '../../main.dart';

class CocktailMemoryFormSheet extends StatefulWidget {
  const CocktailMemoryFormSheet({this.initialDate, this.memory, super.key});

  final DateTime? initialDate;
  final CocktailMemory? memory;

  @override
  State<CocktailMemoryFormSheet> createState() =>
      _CocktailMemoryFormSheetState();
}

class _CocktailMemoryFormSheetState extends State<CocktailMemoryFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  late final TextEditingController _nameController;
  late final TextEditingController _barNameController;
  late final TextEditingController _locationController;
  late DateTime _selectedDate;
  String? _imageBase64;

  @override
  void initState() {
    super.initState();
    final memory = widget.memory;
    _nameController = TextEditingController(text: memory?.name ?? '');
    _barNameController = TextEditingController(text: memory?.barName ?? '');
    _locationController = TextEditingController(text: memory?.location ?? '');
    _selectedDate = memory?.date ?? widget.initialDate ?? DateTime.now();
    _imageBase64 = memory?.imageBase64;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final imageBase64 = _imageBase64;

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
                    widget.memory == null ? 'Add footprint' : 'Edit footprint',
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
              TextFormField(
                controller: _barNameController,
                decoration: const InputDecoration(
                  labelText: 'Bar name',
                  prefixIcon: Icon(Icons.storefront),
                ),
                textInputAction: TextInputAction.next,
                validator: requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.place),
                ),
                textInputAction: TextInputAction.next,
                validator: requiredValidator,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _openGoogleMaps,
                  icon: const Icon(Icons.map),
                  label: const Text('Search in Google Maps'),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_month),
                label: Text(formatDate(_selectedDate)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF7FF),
                    ),
                    child: imageBase64 == null
                        ? const _MemoryImagePlaceholder()
                        : Image.memory(
                            base64Decode(imageBase64),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.add_a_photo),
                  label: Text(
                    imageBase64 == null
                        ? 'Upload cocktail image'
                        : 'Change image',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SaveButton(label: 'Save footprint', onPressed: _saveMemory),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xFF8ECDF7),
                  secondary: const Color(0xFFFFD7E8),
                ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _pickImage() async {
    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
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

  void _saveMemory() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final imageBase64 = _imageBase64;
    if (imageBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a cocktail image')),
      );
      return;
    }

    final memory = CocktailMemory(
      id: widget.memory?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      date:
          DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day),
      imageBase64: imageBase64,
      barName: _barNameController.text.trim(),
      location: _locationController.text.trim(),
    );

    Navigator.of(context).pop(memory);
  }

  Future<void> _openGoogleMaps() async {
    final query = [
      _barNameController.text.trim(),
      _locationController.text.trim(),
    ].where((part) => part.isNotEmpty).join(' ');

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a bar name or location first')),
      );
      return;
    }

    final mapsUri = Uri.https(
      'www.google.com',
      '/maps/search/',
      {
        'api': '1',
        'query': query,
      },
    );

    final didLaunch = await launchUrl(mapsUri);
    if (!didLaunch && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps')),
      );
    }
  }
}

class _MemoryImagePlaceholder extends StatelessWidget {
  const _MemoryImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_a_photo,
            size: 46,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'Cocktail photo',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
