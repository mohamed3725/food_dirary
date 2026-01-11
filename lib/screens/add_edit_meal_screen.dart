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
  int _calories = 0;
  double _protein = 0, _carbs = 0, _fat = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final m = widget.meal;
    if (m != null) {
      _name = m.name;
      _description = m.description;
      _calories = m.calories;
      _protein = m.protein;
      _carbs = m.carbs;
      _fat = m.fat;
    } else {
      _name = '';
      _description = '';
    }
  }

  Future<void> _deleteMeal() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Meal?'),
        content: const Text('Are you sure you want to delete this meal?'),
        actions: [
          TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(ctx).pop(false)),
          TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(ctx).pop(true)),
        ],
      ),
    );

    if (confirm == true && mounted) {
      Navigator.of(context).pop();
      await Provider.of<MealProvider>(context, listen: false)
          .remove(widget.meal!.id);
    }
  }

  void _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<MealProvider>(context, listen: false);

      final meal = Meal(
        id: widget.meal?.id ?? '',
        name: _name,
        description: _description,
        createdAt: widget.meal?.createdAt ?? DateTime.now(),
        lastModified: DateTime.now(),
        calories: _calories,
        protein: _protein,
        carbs: _carbs,
        fat: _fat,
      );

      if (widget.meal != null) {
        await provider.update(meal);
      } else {
        await provider.add(meal);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(widget.meal != null ? 'Meal updated! ✅' : 'Meal added! 🥗'),
          behavior: SnackBarBehavior.floating,
        ));
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
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
            IconButton(icon: const Icon(Icons.delete), onPressed: _deleteMeal),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildSectionTitle('General Info'),
                  const SizedBox(height: 16),
                  _buildTextField('Meal Name', Icons.fastfood_outlined, _name,
                      (v) => _name = v!),
                  const SizedBox(height: 16),
                  _buildTextField(
                      'Description (Optional)',
                      Icons.description_outlined,
                      _description ?? '',
                      (v) => _description = v,
                      required: false,
                      maxLines: 3),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Nutrition Facts'),
                  const SizedBox(height: 16),
                  Row(children: [
                    _buildNumField('Calories', 'kcal', _calories,
                        (v) => _calories = v.toInt()),
                    const SizedBox(width: 16),
                    _buildNumField(
                        'Protein', 'g', _protein, (v) => _protein = v),
                  ]),
                  const SizedBox(height: 16),
                  Row(children: [
                    _buildNumField('Carbs', 'g', _carbs, (v) => _carbs = v),
                    const SizedBox(width: 16),
                    _buildNumField('Fat', 'g', _fat, (v) => _fat = v),
                  ]),
                  const SizedBox(height: 40),
                  FilledButton.icon(
                      onPressed: _saveForm,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Meal')),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold));
  }

  Widget _buildTextField(
      String label, IconData icon, String initial, Function(String?) onSaved,
      {bool required = true, int maxLines = 1}) {
    return TextFormField(
      initialValue: initial,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          alignLabelWithHint: maxLines > 1),
      maxLines: maxLines,
      textInputAction: maxLines == 1 ? TextInputAction.next : null,
      validator:
          required ? (v) => v == null || v.isEmpty ? 'Required' : null : null,
      onSaved: onSaved,
    );
  }

  Widget _buildNumField(
      String label, String suffix, num value, Function(double) onSaved) {
    return Expanded(
      child: TextFormField(
        initialValue: value.toString(),
        decoration: InputDecoration(labelText: label, suffixText: suffix),
        keyboardType: TextInputType.number,
        validator: (v) =>
            v == null || double.tryParse(v) == null ? 'Invalid' : null,
        onSaved: (v) => onSaved(double.parse(v!)),
      ),
    );
  }
}
