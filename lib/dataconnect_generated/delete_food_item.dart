part of 'generated.dart';

class DeleteFoodItemVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteFoodItemVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteFoodItemData> dataDeserializer = (dynamic json)  => DeleteFoodItemData.fromJson(jsonDecode(json));
  Serializer<DeleteFoodItemVariables> varsSerializer = (DeleteFoodItemVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteFoodItemData, DeleteFoodItemVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteFoodItemData, DeleteFoodItemVariables> ref() {
    DeleteFoodItemVariables vars= DeleteFoodItemVariables(id: id,);
    return _dataConnect.mutation("DeleteFoodItem", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteFoodItemFoodItemDelete {
  final String id;
  DeleteFoodItemFoodItemDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteFoodItemFoodItemDelete otherTyped = other as DeleteFoodItemFoodItemDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteFoodItemFoodItemDelete({
    required this.id,
  });
}

@immutable
class DeleteFoodItemData {
  final DeleteFoodItemFoodItemDelete? foodItem_delete;
  DeleteFoodItemData.fromJson(dynamic json):
  
  foodItem_delete = json['foodItem_delete'] == null ? null : DeleteFoodItemFoodItemDelete.fromJson(json['foodItem_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteFoodItemData otherTyped = other as DeleteFoodItemData;
    return foodItem_delete == otherTyped.foodItem_delete;
    
  }
  @override
  int get hashCode => foodItem_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (foodItem_delete != null) {
      json['foodItem_delete'] = foodItem_delete!.toJson();
    }
    return json;
  }

  DeleteFoodItemData({
    this.foodItem_delete,
  });
}

@immutable
class DeleteFoodItemVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteFoodItemVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteFoodItemVariables otherTyped = other as DeleteFoodItemVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteFoodItemVariables({
    required this.id,
  });
}

