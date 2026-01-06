import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';
import '../providers/connectivity_provider.dart';

class AddEditMealScreen extends StatefulWidget {
  final Meal? meal;

  const AddEditMealScreen({super.key, this.meal});

  @override
  State<AddEditMealScreen> createState() => _AddEditMealScreenState();
}

class _AddEditMealScreenState extends State<AddEditMealScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  String? _description;
  late int _calories;
  late double _protein;
  late double _carbs;
  late double _fat;
  bool _isLoading = false;

  XFile? _imageFile;
  String? _imageUrl;
  String? _localImagePath;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.meal != null) {
      _name = widget.meal!.name;
      _description = widget.meal!.description;
      _calories = widget.meal!.calories;
      _protein = widget.meal!.protein;
      _carbs = widget.meal!.carbs;
      _fat = widget.meal!.fat;
      _imageUrl = widget.meal!.image;
      _localImagePath = widget.meal!.localImagePath;
    } else {
      _name = '';
      _description = '';
      _calories = 0;
      _protein = 0;
      _carbs = 0;
      _fat = 0;
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        imageQuality: 60,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      setState(() {
        _isLoading = true;
      });

      final provider = Provider.of<MealProvider>(context, listen: false);
      final connectivity = Provider.of<ConnectivityProvider>(context, listen: false);

      try {
        final Uint8List? bytes = _imageFile != null ? await _imageFile!.readAsBytes() : null;
        final String? fileName = _imageFile != null ? 'meal_${DateTime.now().millisecondsSinceEpoch}.jpg' : null;

        if (bytes != null && connectivity.isOffline) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Offline: Image will upload once you are back online.'),
              backgroundColor: Colors.orange,
            ),
          );
        }

        if (widget.meal != null) {
          // Update
          final updatedMeal = Meal(
            id: widget.meal!.id,
            name: _name,
            description: _description,
            image: _imageUrl, // Keep old URL for now, background update will replace it
            localImagePath: _localImagePath,
            createdAt: widget.meal!.createdAt,
            lastModified: DateTime.now(),
            calories: _calories,
            protein: _protein,
            carbs: _carbs,
            fat: _fat,
          );
          provider.update(updatedMeal, 
            imageBytes: bytes, 
            fileName: fileName,
            webPath: _imageFile?.path,
          );
        } else {
          // Create
          final newMeal = Meal(
            id: '', 
            name: _name,
            description: _description,
            image: null, 
            createdAt: DateTime.now(),
            lastModified: DateTime.now(),
            calories: _calories,
            protein: _protein,
            carbs: _carbs,
            fat: _fat,
          );
          provider.add(newMeal, 
            imageBytes: bytes, 
            fileName: fileName,
            webPath: _imageFile?.path,
          );
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.meal != null ? 'Meal updated! ✅' : 'Meal added! 🥗'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving meal: $e')),
          );
        }
      } 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal != null ? 'Edit Meal' : 'Add Meal'),
        actions: [
          if (widget.meal != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Meal?'),
                    content: const Text(
                        'Are you sure you want to delete this meal?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                      TextButton(
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                    ],
                  ),
                );

                if (confirm == true && mounted) {
                  // Optimistic UI: Close screen immediately
                  Navigator.of(context).pop();

                  final provider =
                      Provider.of<MealProvider>(context, listen: false);
                  // Perform delete in background
                  await provider.remove(widget.meal!.id);
                }
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Image Picker Section
                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              ),
                            ),
                            child: _imageFile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: kIsWeb 
                                      ? Image.network(_imageFile!.path, fit: BoxFit.cover)
                                      : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                                  )
                                : _imageUrl != null && _imageUrl!.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: CachedNetworkImage(
                                            imageUrl: _imageUrl!,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                            errorWidget: (context, url, error) => _localImagePath != null
                                                ? (kIsWeb 
                                                    ? Image.network(_localImagePath!, fit: BoxFit.cover)
                                                    : Image.file(File(_localImagePath!), fit: BoxFit.cover))
                                                : const Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.broken_image_outlined, size: 40, color: Colors.grey),
                                                      Text('Image failed to load', style: TextStyle(color: Colors.grey)),
                                                    ],
                                                  ),
                                          ),
                                        )
                                      : _localImagePath != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: kIsWeb
                                                  ? Image.network(_localImagePath!, fit: BoxFit.cover)
                                                  : Image.file(File(_localImagePath!), fit: BoxFit.cover),
                                            )
                                          : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo_outlined,
                                              size: 40, color: Theme.of(context).colorScheme.primary),
                                          const SizedBox(height: 8),
                                          Text('Add Meal Image',
                                              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                                        ],
                                      ),
                          ),
                        ),
                        if (_imageFile != null || (_imageUrl != null && _imageUrl!.isNotEmpty) || _localImagePath != null)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _imageFile = null;
                                    _imageUrl = null;
                                    _localImagePath = null;
                                  });
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('General Info',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _name,
                    decoration: const InputDecoration(
                      labelText: 'Meal Name',
                      prefixIcon: Icon(Icons.fastfood_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Please enter a name' : null,
                    onSaved: (v) => _name = v!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _description,
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      prefixIcon: Icon(Icons.description_outlined),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    onSaved: (v) => _description = v,
                  ),
                  const SizedBox(height: 24),
                  Text('Nutrition Facts',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _calories.toString(),
                          decoration: const InputDecoration(
                              labelText: 'Calories', suffixText: 'kcal'),
                          keyboardType: TextInputType.number,
                          validator: (v) => v == null || int.tryParse(v) == null
                              ? 'Invalid'
                              : null,
                          onSaved: (v) => _calories = int.parse(v!),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: _protein.toString(),
                          decoration: const InputDecoration(
                              labelText: 'Protein', suffixText: 'g'),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v == null || double.tryParse(v) == null
                                  ? 'Invalid'
                                  : null,
                          onSaved: (v) => _protein = double.parse(v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _carbs.toString(),
                          decoration: const InputDecoration(
                              labelText: 'Carbs', suffixText: 'g'),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v == null || double.tryParse(v) == null
                                  ? 'Invalid'
                                  : null,
                          onSaved: (v) => _carbs = double.parse(v!),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: _fat.toString(),
                          decoration: const InputDecoration(
                              labelText: 'Fat', suffixText: 'g'),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v == null || double.tryParse(v) == null
                                  ? 'Invalid'
                                  : null,
                          onSaved: (v) => _fat = double.parse(v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  FilledButton.icon(
                    onPressed: _saveForm,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Meal'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
