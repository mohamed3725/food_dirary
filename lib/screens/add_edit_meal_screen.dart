import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';

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
    } else {
      _name = '';
      _description = '';
      _calories = 0;
      _protein = 0;
      _carbs = 0;
      _fat = 0;
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Close screen immediately for optimistic UI
      if (mounted) Navigator.of(context).pop();

      final provider = Provider.of<MealProvider>(context, listen: false);

      try {
        if (widget.meal != null) {
          // Update
          final updatedMeal = Meal(
            id: widget.meal!.id,
            name: _name,
            description: _description,
            image: widget.meal!.image,
            createdAt: widget.meal!.createdAt,
            lastModified: DateTime.now(),
            calories: _calories,
            protein: _protein,
            carbs: _carbs,
            fat: _fat,
          );
          await provider.update(updatedMeal);
        } else {
          // Create
          final newMeal = Meal(
            id: '', // Will be generated
            name: _name,
            description: _description,
            createdAt: DateTime.now(),
            lastModified: DateTime.now(),
            calories: _calories,
            protein: _protein,
            carbs: _carbs,
            fat: _fat,
          );
          await provider.add(newMeal);
        }
      } catch (e) {
          // Since we already popped, we might want to show a global error manually, 
          // or just log it as we did in provider.
          debugPrint('Error saving meal: $e');
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
