[<img alt="alt_text" width="240px" src="https://cdn.buymeacoffee.com/buttons/default-orange.png" />](https://www.buymeacoffee.com/mustafahusF)

# background_json_parser

With this package you can easily parse your json and convert your model to json.

## Feature:
1. Parse json with main thread.
2. Parse json in background with multi thread (Asynchronous).
3. Convert model to json with main thread.
4. Convert model to json in background with multi thread (Asynchronous).
## Usage:

It has a very easy to use.

1. Add this line to pubspec.yaml.

```yaml
   dependencies:
     background_json_parser: ^1.0.5
```

2. import package.

```dart
import 'package:background_json_parser/background_json_parser.dart';
```

3. Extend your model from IBaseModel and enter your model as generic type to IBaseModel.
```dart

class UserModel extends IBaseModel<UserModel> {
  UserModel({
    this.id,
    this.name,
    this.username,
    this.email,
    this.address,
    this.phone,
    this.website,
    this.company,
  });

  int? id;
  String? name;
  String? username;
  String? email;
  Address? address;
  String? phone;
  String? website;
  Company? company;
}
```
4. Implement this methods to your class.
```dart
  @override
  fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        address: Address.fromJson(json["address"]),
        phone: json["phone"],
        website: json["website"],
        company: Company.fromJson(json["company"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "address": address!.toJson(),
        "phone": phone,
        "website": website,
        "company": company!.toJson(),
      };
```

5. Your class will be such as.
```dart
class UserModel extends IBaseModel<UserModel> {
  UserModel({
    this.id,
    this.name,
    this.username,
    this.email,
    this.address,
    this.phone,
    this.website,
    this.company,
  });

  int? id;
  String? name;
  String? username;
  String? email;
  Address? address;
  String? phone;
  String? website;
  Company? company;

  @override
  fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        address: Address.fromJson(json["address"]),
        phone: json["phone"],
        website: json["website"],
        company: Company.fromJson(json["company"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "address": address!.toJson(),
        "phone": phone,
        "website": website,
        "company": company!.toJson(),
      };
}
```

6. Json parser methods.

- Parse json with main thread.
```dart
// If you want parse json object
UserModel user = UserModel().jsonParser(response.body);

// If you want parse json array
List<UserModel> userList = UserModel().jsonParser(response.body);
```

- Parse json with multi thread.
```dart
// If you want parse json object
UserModel user = await UserModel().backgroundJsonParser(response.body);

// If you want parse json array
List<UserModel> userList = await UserModel().backgroundJsonParser(response.body);
```

7. Convert your model to json.

- Convert your model to json with main thread.
```dart
// If you want convert your Model
String json = userModel.convertToJson();

// If you want convert your List of Model
String json = userModel().convertToJson(list);
```

- Convert your model to json with multi thread.
```dart
// If you want convert your Model
String json = await userModel.backgroundConvertToJson();

// If you want convert your List of Model
String json = await userModel().backgroundConvertToJson(list);
```
