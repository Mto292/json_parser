import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

const String baseUrl = 'jsonplaceholder.typicode.com';

// written this class for http api
class HttpClient {

  Future<http.Response?> get(String method,
      {Map<String, String> queryParameters = const {},
      required Map<String, String>? header,
      String body = ''}) async {
    // Sends an HTTP get
    var response = await http.get(
        Uri.http(baseUrl, method, queryParameters),
        headers: header);
    _logS(baseUrl + method, header, response);
    return response;
  }

  /// http post method
  Future<http.Response?> post(String method,
      {required String encodedBody,
      required Map<String, String>? header,
      Map<String, dynamic>? queryParameters = const {}}) async {
    //we convert the map to json
    // Sends an HTTP POST
    var response = await http.post(
        Uri.http(baseUrl, method, queryParameters),
        headers: header,
        body: encodedBody,
        encoding: Encoding.getByName("application/json"));
    _logS(baseUrl + method, header, response);
    //returns the resulting Json object.
    return response;
  }

  /// http delete method
  Future<http.Response?> delete(String method,
      {Map<String, dynamic> apiParameters = const {},
      required Map<String, String>? header}) async {
    var encodedBody = json.encode(apiParameters);
    var response = await http.delete(Uri.http(baseUrl, method),
        body: encodedBody, headers: header);
    _logS(baseUrl + method, header, response);
    return response;
  }

  /// http put method
  Future<http.Response?> put(String method,
      {required Map<String, dynamic> apiParameters,
      required Map<String, String>? header}) async {
    //we convert the map to json
    var encodedBody = json.encode(apiParameters);
    // Sends an HTTP put
    var response = await http.put(Uri.http(baseUrl, method),
        headers: header,
        body: encodedBody,
        encoding: Encoding.getByName("application/json"));
    //returns the resulting Json object.
    _logS(baseUrl + method, header, response);
    return response;
  }

  /// http put method
  Future<http.Response?> update(String method,
      {required Map<String, dynamic> apiParameters,
      required Map<String, String>? header}) async {
    //we convert the map to json
    var encodedBody = json.encode(apiParameters);
    // Sends an HTTP put
    var response = await http.post(Uri.http(baseUrl, method),
        headers: header,
        body: encodedBody,
        encoding: Encoding.getByName("application/json"));
    _logS(baseUrl + method, header, response);
    return response;
  }
}

void _logS(String url, Map<String, String>? header, http.Response response) {
  log('__________________________________ Http Start ___________________________________',
      name: 'Http');
  log('http://' + url, name: 'Api Url');
  log(jsonEncode(header), name: 'Header');
  log(response.statusCode.toString(), name: 'Response Code');
  log(response.body, name: 'Response Body');
  log('___________________________________ Http End ____________________________________',
      name: 'Http');
}
