part of 'generated.dart';

class UpdateMealNotesVariablesBuilder {
  String id;
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateMealNotesVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  UpdateMealNotesVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpdateMealNotesData> dataDeserializer = (dynamic json)  => UpdateMealNotesData.fromJson(jsonDecode(json));
  Serializer<UpdateMealNotesVariables> varsSerializer = (UpdateMealNotesVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateMealNotesData, UpdateMealNotesVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateMealNotesData, UpdateMealNotesVariables> ref() {
    UpdateMealNotesVariables vars= UpdateMealNotesVariables(id: id,notes: _notes,);
    return _dataConnect.mutation("UpdateMealNotes", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateMealNotesMealUpdate {
  final String id;
  UpdateMealNotesMealUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMealNotesMealUpdate otherTyped = other as UpdateMealNotesMealUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateMealNotesMealUpdate({
    required this.id,
  });
}

@immutable
class UpdateMealNotesData {
  final UpdateMealNotesMealUpdate? meal_update;
  UpdateMealNotesData.fromJson(dynamic json):
  
  meal_update = json['meal_update'] == null ? null : UpdateMealNotesMealUpdate.fromJson(json['meal_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMealNotesData otherTyped = other as UpdateMealNotesData;
    return meal_update == otherTyped.meal_update;
    
  }
  @override
  int get hashCode => meal_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (meal_update != null) {
      json['meal_update'] = meal_update!.toJson();
    }
    return json;
  }

  UpdateMealNotesData({
    this.meal_update,
  });
}

@immutable
class UpdateMealNotesVariables {
  final String id;
  late final Optional<String>notes;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateMealNotesVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    notes = Optional.optional(nativeFromJson, nativeToJson);
    notes.value = json['notes'] == null ? null : nativeFromJson<String>(json['notes']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateMealNotesVariables otherTyped = other as UpdateMealNotesVariables;
    return id == otherTyped.id && 
    notes == otherTyped.notes;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, notes.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    return json;
  }

  UpdateMealNotesVariables({
    required this.id,
    required this.notes,
  });
}

