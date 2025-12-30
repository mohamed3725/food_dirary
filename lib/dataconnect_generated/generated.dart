library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_food_item.dart';

part 'get_meals_for_user.dart';

part 'update_meal_notes.dart';

part 'delete_food_item.dart';







class ExampleConnector {
  
  
  CreateFoodItemVariablesBuilder createFoodItem ({required double calories, required double carbohydrates, required double fat, required String foodName, required double protein, }) {
    return CreateFoodItemVariablesBuilder(dataConnect, calories: calories,carbohydrates: carbohydrates,fat: fat,foodName: foodName,protein: protein,);
  }
  
  
  GetMealsForUserVariablesBuilder getMealsForUser ({required String userId, }) {
    return GetMealsForUserVariablesBuilder(dataConnect, userId: userId,);
  }
  
  
  UpdateMealNotesVariablesBuilder updateMealNotes ({required String id, }) {
    return UpdateMealNotesVariablesBuilder(dataConnect, id: id,);
  }
  
  
  DeleteFoodItemVariablesBuilder deleteFoodItem ({required String id, }) {
    return DeleteFoodItemVariablesBuilder(dataConnect, id: id,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'example',
    'fooddirary',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
