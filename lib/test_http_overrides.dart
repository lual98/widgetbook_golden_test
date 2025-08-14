import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:widgetbook_golden_test/ignore_network_image_exception.dart';
import 'package:widgetbook_golden_test/widgetbook_golden_tests_properties.dart';

class _MockHttpClientRequest extends Mock implements HttpClientRequest {}

class _MockHttpClientResponse extends Mock implements HttpClientResponse {}

class _MockHttpHeaders extends Mock implements HttpHeaders {}

class _MockHttpOverrides extends Mock implements HttpOverrides {}

HttpOverrides createHttpOverrides(WidgetbookGoldenTestsProperties properties) {
  var mockHttpOverrides = _MockHttpOverrides();
  when(
    () => mockHttpOverrides.createHttpClient(any()),
  ).thenAnswer((_) => _createHttpClient(properties.errorImageUrl));
  return mockHttpOverrides;
}

HttpClient _createHttpClient(String errorImageUrl) {
  final client = _MockHttpClient();

  when(() => client.getUrl(any())).thenAnswer(
    (invokation) async => _createRequest(
      invokation.positionalArguments.first as Uri,
      errorImageUrl,
    ),
  );
  when(() => client.openUrl(any(), any())).thenAnswer(
    (invokation) async => _createRequest(
      invokation.positionalArguments.last as Uri,
      errorImageUrl,
    ),
  );

  return client;
}

HttpClientRequest _createRequest(Uri uri, String errorImageUrl) {
  if (uri.toString().contains(errorImageUrl)) {
    throw IgnoreNetworkImageException();
  }
  final request = _MockHttpClientRequest();
  final headers = _MockHttpHeaders();

  when(() => request.headers).thenReturn(headers);
  when(() => request.addStream(any())).thenAnswer((invocation) {
    final stream = invocation.positionalArguments.first as Stream<List<int>>;
    return stream.fold<List<int>>(
      <int>[],
      (previous, element) => previous..addAll(element),
    );
  });
  when(request.close).thenAnswer((_) async => _createResponse(uri));

  return request;
}

HttpClientResponse _createResponse(Uri uri) {
  final response = _MockHttpClientResponse();
  final headers = _MockHttpHeaders();
  final data = _transparentPixelPng;

  when(() => response.headers).thenReturn(headers);
  when(() => response.contentLength).thenReturn(data.length);
  when(() => response.statusCode).thenReturn(HttpStatus.ok);
  when(() => response.isRedirect).thenReturn(false);
  when(() => response.redirects).thenReturn([]);
  when(() => response.persistentConnection).thenReturn(false);
  when(() => response.reasonPhrase).thenReturn('OK');
  when(
    () => response.compressionState,
  ).thenReturn(HttpClientResponseCompressionState.notCompressed);
  when(
    () => response.handleError(any(), test: any(named: 'test')),
  ).thenAnswer((_) => Stream<List<int>>.value(data));
  when(
    () => response.listen(
      any(),
      onDone: any(named: 'onDone'),
      onError: any(named: 'onError'),
      cancelOnError: any(named: 'cancelOnError'),
    ),
  ).thenAnswer((invocation) {
    final onData =
        invocation.positionalArguments.first as void Function(List<int>);
    final onDone = invocation.namedArguments[#onDone] as void Function()?;
    return Stream<List<int>>.fromIterable(<List<int>>[
      data,
    ]).listen(onData, onDone: onDone);
  });
  return response;
}

class _MockHttpClient extends Mock implements HttpClient {
  _MockHttpClient() {
    registerFallbackValue((List<int> _) {});
    registerFallbackValue(Uri());
    registerFallbackValue(const Stream<List<int>>.empty());
  }
}

final _transparentPixelPng = base64Decode(
  '''iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==''',
);
