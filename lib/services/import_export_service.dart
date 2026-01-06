import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/meal.dart';

class ImportExportService {
  /// Exports meals to a JSON file and shares it
  Future<void> exportMeals(List<Meal> meals) async {
    try {
      final List<Map<String, dynamic>> jsonData = 
          meals.map((m) => m.toMap()).toList();
      final String jsonString = jsonEncode(jsonData);
      
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/food_diary_export.json');
      
      await file.writeAsString(jsonString);
      
      final xFile = XFile(file.path);
      await Share.shareXFiles([xFile], text: 'My Food Diary Export');
    } catch (e) {
      throw 'Export failed: $e';
    }
  }

  /// Imports meals from a picked JSON file
  Future<List<Meal>> importMeals() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final content = await file.readAsString();
        final List<dynamic> decoded = jsonDecode(content);
        
        return decoded.map((item) {
          // Note: When importing, we treat them as new meals (empty doc ID)
          // so Firestore generates new IDs.
          return Meal.fromMap(item as Map<String, dynamic>, '');
        }).toList();
      }
      return [];
    } catch (e) {
      throw 'Import failed: $e';
    }
  }
}
