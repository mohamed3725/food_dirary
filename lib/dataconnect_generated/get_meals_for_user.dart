part of 'generated.dart';

class GetMealsForUserVariablesBuilder {
  String userId;

  final FirebaseDataConnect _dataConnect;
  GetMealsForUserVariablesBuilder(this._dataConnect, {required  this.userId,});
  Deserializer<GetMealsForUserData> dataDeserializer = (dynamic json)  => GetMealsForUserData.fromJson(jsonDecode(json));
  Serializer<GetMealsForUserVariables> varsSerializer = (GetMealsForUserVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetMealsForUserData, GetMealsForUserVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetMealsForUserData, GetMealsForUserVariables> ref() {
    GetMealsForUserVariables vars= GetMealsForUserVariables(userId: userId,);
    return _dataConnect.query("GetMealsForUser", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetMealsForUserMeals {
  final String id;
  final String mealName;
  final Timestamp mealTime;
  final String? notes;
  final List<GetMealsForUserMealsMealEntriesOnMeal> mealEntries_on_meal;
  GetMealsForUserMeals.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  mealName = nativeFromJson<String>(json['mealName']),
  mealTime = Timestamp.fromJson(json['mealTime']),
  notes = json['notes'] == null ? null : nativeFromJson<String>(json['notes']),
  mealEntries_on_meal = (json['mealEntries_on_meal'] as List<dynamic>)
        .map((e) => GetMealsForUserMealsMealEntriesOnMeal.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMealsForUserMeals otherTyped = other as GetMealsForUserMeals;
    return id == otherTyped.id && 
    mealName == otherTyped.mealName && 
    mealTime == otherTyped.mealTime && 
    notes == otherTyped.notes && 
    mealEntries_on_meal == otherTyped.mealEntries_on_meal;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, mealName.hashCode, mealTime.hashCode, notes.hashCode, mealEntries_on_meal.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['mealName'] = nativeToJson<String>(mealName);
    json['mealTime'] = mealTime.toJson();
    if (notes != null) {
      json['notes'] = nativeToJson<String?>(notes);
    }
    json['mealEntries_on_meal'] = mealEntries_on_meal.map((e) => e.toJson()).toList();
    return json;
  }

  GetMealsForUserMeals({
    required this.id,
    required this.mealName,
    required this.mealTime,
    this.notes,
    required this.mealEntries_on_meal,
  });
}

@immutable
class GetMealsForUserMealsMealEntriesOnMeal {
  final double quantity;
  final GetMealsForUserMealsMealEntriesOnMealFoodItem foodItem;
  GetMealsForUserMealsMealEntriesOnMeal.fromJson(dynamic json):
  
  quantity = nativeFromJson<double>(json['quantity']),
  foodItem = GetMealsForUserMealsMealEntriesOnMealFoodItem.fromJson(json['foodItem']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMealsForUserMealsMealEntriesOnMeal otherTyped = other as GetMealsForUserMealsMealEntriesOnMeal;
    return quantity == otherTyped.quantity && 
    foodItem == otherTyped.foodItem;
    
  }
  @override
  int get hashCode => Object.hashAll([quantity.hashCode, foodItem.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['quantity'] = nativeToJson<double>(quantity);
    json['foodItem'] = foodItem.toJson();
    return json;
  }

  GetMealsForUserMealsMealEntriesOnMeal({
    required this.quantity,
    required this.foodItem,
  });
}

@immutable
class GetMealsForUserMealsMealEntriesOnMealFoodItem {
  final String foodName;
  final double calories;
  final double fat;
  final double carbohydrates;
  final double protein;
  GetMealsForUserMealsMealEntriesOnMealFoodItem.fromJson(dynamic json):
  
  foodName = nativeFromJson<String>(json['foodName']),
  calories = nativeFromJson<double>(json['calories']),
  fat = nativeFromJson<double>(json['fat']),
  carbohydrates = nativeFromJson<double>(json['carbohydrates']),
  protein = nativeFromJson<double>(json['protein']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMealsForUserMealsMealEntriesOnMealFoodItem otherTyped = other as GetMealsForUserMealsMealEntriesOnMealFoodItem;
    return foodName == otherTyped.foodName && 
    calories == otherTyped.calories && 
    fat == otherTyped.fat && 
    carbohydrates == otherTyped.carbohydrates && 
    protein == otherTyped.protein;
    
  }
  @override
  int get hashCode => Object.hashAll([foodName.hashCode, calories.hashCode, fat.hashCode, carbohydrates.hashCode, protein.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['foodName'] = nativeToJson<String>(foodName);
    json['calories'] = nativeToJson<double>(calories);
    json['fat'] = nativeToJson<double>(fat);
    json['carbohydrates'] = nativeToJson<double>(carbohydrates);
    json['protein'] = nativeToJson<double>(protein);
    return json;
  }

  GetMealsForUserMealsMealEntriesOnMealFoodItem({
    required this.foodName,
    required this.calories,
    required this.fat,
    required this.carbohydrates,
    required this.protein,
  });
}

@immutable
class GetMealsForUserData {
  final List<GetMealsForUserMeals> meals;
  GetMealsForUserData.fromJson(dynamic json):
  
  meals = (json['meals'] as List<dynamic>)
        .map((e) => GetMealsForUserMeals.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMealsForUserData otherTyped = other as GetMealsForUserData;
    return meals == otherTyped.meals;
    
  }
  @override
  int get hashCode => meals.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['meals'] = meals.map((e) => e.toJson()).toList();
    return json;
  }

  GetMealsForUserData({
    required this.meals,
  });
}

@immutable
class GetMealsForUserVariables {
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetMealsForUserVariables.fromJson(Map<String, dynamic> json):
  
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMealsForUserVariables otherTyped = other as GetMealsForUserVariables;
    return userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => userId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  GetMealsForUserVariables({
    required this.userId,
  });
}

