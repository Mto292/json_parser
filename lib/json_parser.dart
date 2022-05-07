library json_parser;

import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';


abstract class IBaseModel<T> {
  T fromJson(Map<String, dynamic> json);
  Map<String ,dynamic> toJson();

  dynamic jsonParser(Uint8List bodyBytes) {
    assert(T.toString() != 'dynamic');

    final jsonBody = json.decode(utf8.decode(bodyBytes));
    if (jsonBody is List) {
      return jsonBody.map((e) => fromJson(e)).toList().cast<T>();
    } else if (jsonBody is Map<String,dynamic>) {
      return fromJson(jsonBody);
    } else {
      return jsonBody;
    }
  }

  Future<dynamic> backgroundJsonParser(Uint8List bodyBytes) async {
    final port = ReceivePort('json_parser Package');
    await Isolate.spawn(_backgroundJsonParser, {'port': port.sendPort, 'body': bodyBytes});
    return await port.first;
  }

  _backgroundJsonParser(map) {
    final port = map['port'];
    Isolate.exit(port,jsonParser(map['body']));
  }

  String convertToJson([dynamic model]) {
    if(model == null){
      return json.encode(toJson());
    }

    assert (model is T || model is List<T>);

    if (model is List) {
      final list = List.from(model.map((e) => e?.toJson()));
      return json.encode(list);
    } else {
      return json.encode(model.toJson());
    }
  }

  Future<String> backgroundConvertToJson([List<T>? model]) async {
    final port = ReceivePort('json_parser Package');
    await Isolate.spawn<Map>(_backgroundConvertToJson, {'port': port.sendPort, 'model': model});
    return await port.first;
  }

  _backgroundConvertToJson(Map map) {
    final port = map['port'];
    final model = map['model'];
    Isolate.exit(port,convertToJson(model));
  }
}
