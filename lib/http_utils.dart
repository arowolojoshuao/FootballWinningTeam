import 'dart:io';

import 'package:http/http.dart' as http;

import 'constants.dart';
import 'exceptions.dart';

class HttpUtil {
  const HttpUtil();

  Future<http.Response> wrapRemoteCall(
      http.BaseRequest request, http.Client client) async {
    try {
      final streamedResponse =
          await client.send(request..headers['X-Auth-Token'] = API_TOKEN);
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode >= 200 && response.statusCode < 400)
        return response;
      else if (response.statusCode == 403) {
        throw InvalidAccessToken();
      } else if (response.statusCode == 404) {
        throw ResourceNotFoundError();
      } else if (response.statusCode == 409) {
        throw TooManyRequests();
      } else {
        throw UnknownException();
      }
    } on SocketException {
      throw NetworkException();
    }
  }
}
