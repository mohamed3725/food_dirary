# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetMealsForUser
#### Required Arguments
```dart
String userId = ...;
ExampleConnector.instance.getMealsForUser(
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMealsForUserData, GetMealsForUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getMealsForUser(
  userId: userId,
);
GetMealsForUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = ExampleConnector.instance.getMealsForUser(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateFoodItem
#### Required Arguments
```dart
double calories = ...;
double carbohydrates = ...;
double fat = ...;
String foodName = ...;
double protein = ...;
ExampleConnector.instance.createFoodItem(
  calories: calories,
  carbohydrates: carbohydrates,
  fat: fat,
  foodName: foodName,
  protein: protein,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateFoodItem, we created `CreateFoodItemBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateFoodItemVariablesBuilder {
  ...
   CreateFoodItemVariablesBuilder servingSize(double? t) {
   _servingSize.value = t;
   return this;
  }
  CreateFoodItemVariablesBuilder unit(String? t) {
   _unit.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createFoodItem(
  calories: calories,
  carbohydrates: carbohydrates,
  fat: fat,
  foodName: foodName,
  protein: protein,
)
.servingSize(servingSize)
.unit(unit)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateFoodItemData, CreateFoodItemVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createFoodItem(
  calories: calories,
  carbohydrates: carbohydrates,
  fat: fat,
  foodName: foodName,
  protein: protein,
);
CreateFoodItemData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
double calories = ...;
double carbohydrates = ...;
double fat = ...;
String foodName = ...;
double protein = ...;

final ref = ExampleConnector.instance.createFoodItem(
  calories: calories,
  carbohydrates: carbohydrates,
  fat: fat,
  foodName: foodName,
  protein: protein,
).ref();
ref.execute();
```


### UpdateMealNotes
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.updateMealNotes(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateMealNotes, we created `UpdateMealNotesBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateMealNotesVariablesBuilder {
  ...
   UpdateMealNotesVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.updateMealNotes(
  id: id,
)
.notes(notes)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateMealNotesData, UpdateMealNotesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateMealNotes(
  id: id,
);
UpdateMealNotesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.updateMealNotes(
  id: id,
).ref();
ref.execute();
```


### DeleteFoodItem
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteFoodItem(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteFoodItemData, DeleteFoodItemVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteFoodItem(
  id: id,
);
DeleteFoodItemData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteFoodItem(
  id: id,
).ref();
ref.execute();
```

