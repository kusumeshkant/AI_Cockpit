import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Headers;

/// Recorded HTTP request made by a [SupabaseClient] under test.
typedef Recorded = http.Request;

/// Handler returning a canned response for a request.
typedef FakeHandler = http.Response Function(http.Request request);

/// Builds a real [SupabaseClient] whose HTTP traffic goes to [handler], and
/// records every request in [requests].
SupabaseClient fakeSupabase(FakeHandler handler, List<Recorded> requests) {
  final client = MockClient((request) async {
    requests.add(request);
    final response = handler(request);
    // postgrest reads `response.request`, which a bare Response lacks.
    return http.Response.bytes(
      response.bodyBytes,
      response.statusCode,
      headers: response.headers,
      request: request,
    );
  });
  return SupabaseClient(
    'http://supabase.test',
    'anon-test-key',
    httpClient: client,
    authOptions: const AuthClientOptions(
      autoRefreshToken: false,
      authFlowType: AuthFlowType.implicit,
    ),
  );
}

/// JSON response helper.
http.Response jsonResponse(Object body, {int status = 200}) => http.Response(
      jsonEncode(body),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

/// mocktail Dio.
class MockDio extends Mock implements Dio {}

/// Registers fallbacks needed to stub `Dio.post`.
void registerDioFallbacks() {
  registerFallbackValue(Options());
}

/// A successful Edge Function envelope response.
Response<Object?> envelope(Map<String, dynamic> data, {String path = '/'}) => Response<Object?>(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: {'ok': true, 'data': data},
    );

/// A failed Edge Function call as dio surfaces it.
DioException edgeError(
  int status,
  String code, {
  String path = '/',
  Map<String, String> headers = const {},
}) {
  final options = RequestOptions(path: path);
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<Object?>(
      requestOptions: options,
      statusCode: status,
      headers: Headers.fromMap({
        for (final entry in headers.entries) entry.key: [entry.value],
      }),
      data: {
        'ok': false,
        'error': {'code': code, 'message': code},
      },
    ),
  );
}

/// An unsigned but well-formed JWT (Supabase decodes claims client-side).
String fakeJwt(String userId) {
  String part(Map<String, Object> json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  final exp = DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000;
  return '${part({'alg': 'HS256', 'typ': 'JWT'})}.'
      '${part({'sub': userId, 'exp': exp, 'role': 'authenticated'})}.signature';
}
