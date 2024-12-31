library background_json_parser;

import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

/// # background_json_parser
///
/// With this package you can easily parse your json and convert your model to json.
///
/// ## Feature:
/// 1. Parse json with main thread.
/// 2. Parse json with multi thread (Asynchronous).
/// 3. Convert model to json with main thread.
/// 4. Convert model to json with multi thread (Asynchronous).
/// ## Usage:
///
/// It has a very easy to use.
///
/// 1. Add this line to pubspec.yaml.
///
/// ```yaml
/// dependencies:
/// background_json_parser: ^1.0.5
/// ```
///
/// 2. import package.
///
/// ```dart
/// import 'package:background_json_parser/background_json_parser.dart';
/// ```
///
/// 3. Extend your model from IBaseModel and enter your model as generic type to IBaseModel.
/// ```dart
///
/// class UserModel extends IBaseModel<UserModel> {
///   UserModel({
///     this.id,
///     this.name,
///     this.username,
///     this.email,
///     this.address,
///     this.phone,
///     this.website,
///     this.company,
///   });
///
///   int? id;
///   String? name;
///   String? username;
///   String? email;
///   Address? address;
///   String? phone;
///   String? website;
///   Company? company;
/// }
/// ```
/// 4. Implement this methods to your class.
/// ```dart
/// @override
/// fromJson(Map<String, dynamic> json) => UserModel(
/// id: json["id"],
/// name: json["name"],
/// username: json["username"],
/// email: json["email"],
/// address: Address.fromJson(json["address"]),
/// phone: json["phone"],
/// website: json["website"],
/// company: Company.fromJson(json["company"]),
/// );
///
/// @override
/// Map<String, dynamic> toJson() => {
/// "id": id,
/// "name": name,
/// "username": username,
/// "email": email,
/// "address": address!.toJson(),
/// "phone": phone,
/// "website": website,
/// "company": company!.toJson(),
/// };
/// ```
///
/// 5. Your class will be such as.
/// ```dart
/// class UserModel extends IBaseModel<UserModel> {
/// UserModel({
/// this.id,
/// this.name,
/// this.username,
/// this.email,
/// this.address,
/// this.phone,
/// this.website,
/// this.company,
/// });
///
/// int? id;
/// String? name;
/// String? username;
/// String? email;
/// Address? address;
/// String? phone;
/// String? website;
/// Company? company;
///
/// @override
/// fromJson(Map<String, dynamic> json) => UserModel(
/// id: json["id"],
/// name: json["name"],
/// username: json["username"],
/// email: json["email"],
/// address: Address.fromJson(json["address"]),
/// phone: json["phone"],
/// website: json["website"],
/// company: Company.fromJson(json["company"]),
/// );
///
/// @override
/// Map<String, dynamic> toJson() => {
/// "id": id,
/// "name": name,
/// "username": username,
/// "email": email,
/// "address": address!.toJson(),
/// "phone": phone,
/// "website": website,
/// "company": company!.toJson(),
/// };
/// }
/// ```
///
/// 6. Json parser methods.
///
/// - Parse json with main thread.
/// ```dart
/// /// If you want parse json object
/// UserModel user = UserModel().jsonParser(response.body);
///
/// /// If you want parse json array
/// List<UserModel> userList = UserModel().jsonParser(response.body);
/// ```
///
/// - Parse json with multi thread.
/// ```dart
/// /// If you want parse json object
/// UserModel user = await UserModel().backgroundJsonParser(response.body);
///
/// /// If you want parse json array
/// List<UserModel> userList = await UserModel().backgroundJsonParser(response.body);
/// ```
///
/// 7. Convert your model to json.
///
/// - Convert your model to json with main thread.
/// ```dart
/// /// If you want convert your Model
/// String json = userModel.convertToJson();
///
/// /// If you want convert your List of Model
/// String json = userModel().convertToJson(list);
/// ```
///
/// - Convert your model to json with multi thread.
/// ```dart
/// /// If you want convert your Model
/// String json = await userModel.backgroundConvertToJson();
///
/// /// If you want convert your List of Model
/// String json = await userModel().backgroundConvertToJson(list);
/// ```

abstract class IBaseModel<T> {
  /// Override this method and convert map (argument) to your class object such as:
  /// @override
  /// UserModel fromJson(Map<String, dynamic> json) => UserModel(
  /// id: json["id"],
  /// name: json["name"],
  /// username: json["username"],
  /// email: json["email"],
  /// address: Address.fromJson(json["address"]),
  /// phone: json["phone"],
  /// website: json["website"],
  /// company: Company.fromJson(json["company"]),
  /// );
  T fromJson(Map<String, dynamic> json);

  /// Override this method and Convert your class object to Map such as:
  /// @override
  /// Map<String, dynamic> toJson() => {
  /// "id": id,
  /// "name": name,
  /// "username": username,
  /// "email": email,
  /// "address": address!.toJson(),
  /// "phone": phone,
  /// "website": website,
  /// "company": company!.toJson(),
  /// };
  Map<String, dynamic> toJson();

  /// You can parse your json with this method such as:
  /// UserModel user = UserModel().jsonParser(response.body);
  ///
  dynamic jsonParser(String jsonBody) {
    // enter your model as generic type to IBaseModel.
    assert(T.toString() != 'dynamic');
    return jsonParserByMap(json.decode(jsonBody));
  }

  /// This method helps you convert a JSON map or a list of JSON maps into
  /// a corresponding model class object.
  /// UserModel user = UserModel().jsonParser(response.body);
  ///
  dynamic jsonParserByMap(dynamic map) {
    // enter your model as generic type to IBaseModel.
    assert(T.toString() != 'dynamic' && (map is Map || map is List));

    if (map is List) {
      return map.map((e) => fromJson(e)).toList().cast<T>();
    } else if (map is Map<String, dynamic>) {
      return fromJson(map);
    } else {
      return map;
    }
  }

  /// You can parse your json in background (multi thread) with this method such as:
  /// UserModel user = await UserModel().backgroundJsonParser(response.body);
  ///
  Future<dynamic> backgroundJsonParser(String jsonBody) async {
    if (kIsWeb) return jsonParser(jsonBody);
    final port = ReceivePort('background_json_parser Package');
    await Isolate.spawn(
      _backgroundJsonParser,
      {'port': port.sendPort, 'body': jsonBody},
      onError: port.sendPort,
    );
    return await port.first;
  }

  _backgroundJsonParser(map) {
    final port = map['port'];
    Isolate.exit(port, jsonParser(map['body']));
  }

  /// You can convert your model to json such as
  /// String json = userModel.convertToJson();
  ///
  /// if you have list of model and want convert it to json array
  /// String json = userModel().convertToJson(list);
  ///
  String convertToJson([dynamic model]) {
    if (model == null) {
      return json.encode(toJson());
    }

    assert(model is T || model is List<T>);

    if (model is List) {
      final list = List.from(model.map((e) => e?.toJson()));
      return json.encode(list);
    } else {
      return json.encode(model.toJson());
    }
  }

  /// You can convert your model to json in background in (with multi thread) such as
  /// String json = await userModel.backgroundConvertToJson();
  ///
  /// if you have list of model and want convert it to json array
  /// String json = await userModel().backgroundConvertToJson(list);
  ///
  Future<String> backgroundConvertToJson([List<T>? model]) async {
    if (kIsWeb) return convertToJson(model);
    final port = ReceivePort('background_json_parser Package');
    await Isolate.spawn<Map>(
      _backgroundConvertToJson,
      {'port': port.sendPort, 'model': model},
      onError: port.sendPort,
    );
    return await port.first;
  }

  _backgroundConvertToJson(Map map) {
    final port = map['port'];
    final model = map['model'];
    Isolate.exit(port, convertToJson(model));
  }
}
