part of 'generated.dart';

class CreateFoodItemVariablesBuilder {
  double calories;
  double carbohydrates;
  double fat;
  String foodName;
  double protein;
  Optional<double> _servingSize = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _unit = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreateFoodItemVariablesBuilder servingSize(double? t) {
   _servingSize.value = t;
   return this;
  }
  CreateFoodItemVariablesBuilder unit(String? t) {
   _unit.value = t;
   return this;
  }

  CreateFoodItemVariablesBuilder(this._dataConnect, {required  this.calories,required  this.carbohydrates,required  this.fat,required  this.foodName,required  this.protein,});
  Deserializer<CreateFoodItemData> dataDeserializer = (dynamic json)  => CreateFoodItemData.fromJson(jsonDecode(json));
  Serializer<CreateFoodItemVariables> varsSerializer = (CreateFoodItemVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateFoodItemData, CreateFoodItemVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateFoodItemData, CreateFoodItemVariables> ref() {
    CreateFoodItemVariables vars= CreateFoodItemVariables(calories: calories,carbohydrates: carbohydrates,fat: fat,foodName: foodName,protein: protein,servingSize: _servingSize,unit: _unit,);
    return _dataConnect.mutation("CreateFoodItem", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateFoodItemFoodItemInsert {
  final String id;
  CreateFoodItemFoodItemInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFoodItemFoodItemInsert otherTyped = other as CreateFoodItemFoodItemInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateFoodItemFoodItemInsert({
    required this.id,
  });
}

@immutable
class CreateFoodItemData {
  final CreateFoodItemFoodItemInsert foodItem_insert;
  CreateFoodItemData.fromJson(dynamic json):
  
  foodItem_insert = CreateFoodItemFoodItemInsert.fromJson(json['foodItem_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFoodItemData otherTyped = other as CreateFoodItemData;
    return foodItem_insert == otherTyped.foodItem_insert;
    
  }
  @override
  int get hashCode => foodItem_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['foodItem_insert'] = foodItem_insert.toJson();
    return json;
  }

  CreateFoodItemData({
    required this.foodItem_insert,
  });
}

@immutable
class CreateFoodItemVariables {
  final double calories;
  final double carbohydrates;
  final double fat;
  final String foodName;
  final double protein;
  late final Optional<double>servingSize;
  late final Optional<String>unit;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateFoodItemVariables.fromJson(Map<String, dynamic> json):
  
  calories = nativeFromJson<double>(json['calories']),
  carbohydrates = nativeFromJson<double>(json['carbohydrates']),
  fat = nativeFromJson<double>(json['fat']),
  foodName = nativeFromJson<String>(json['foodName']),
  protein = nativeFromJson<double>(json['protein']) {
  
  
  
  
  
  
  
    servingSize = Optional.optional(nativeFromJson, nativeToJson);
    servingSize.value = json['servingSize'] == null ? null : nativeFromJson<double>(json['servingSize']);
  
  
    unit = Optional.optional(nativeFromJson, nativeToJson);
    unit.value = json['unit'] == null ? null : nativeFromJson<String>(json['unit']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateFoodItemVariables otherTyped = other as CreateFoodItemVariables;
    return calories == otherTyped.calories && 
    carbohydrates == otherTyped.carbohydrates && 
    fat == otherTyped.fat && 
    foodName == otherTyped.foodName && 
    protein == otherTyped.protein && 
    servingSize == otherTyped.servingSize && 
    unit == otherTyped.unit;
    
  }
  @override
  int get hashCode => Object.hashAll([calories.hashCode, carbohydrates.hashCode, fat.hashCode, foodName.hashCode, protein.hashCode, servingSize.hashCode, unit.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['calories'] = nativeToJson<double>(calories);
    json['carbohydrates'] = nativeToJson<double>(carbohydrates);
    json['fat'] = nativeToJson<double>(fat);
    json['foodName'] = nativeToJson<String>(foodName);
    json['protein'] = nativeToJson<double>(protein);
    if(servingSize.state == OptionalState.set) {
      json['servingSize'] = servingSize.toJson();
    }
    if(unit.state == OptionalState.set) {
      json['unit'] = unit.toJson();
    }
    return json;
  }

  CreateFoodItemVariables({
    required this.calories,
    required this.carbohydrates,
    required this.fat,
    required this.foodName,
    required this.protein,
    required this.servingSize,
    required this.unit,
  });
}

