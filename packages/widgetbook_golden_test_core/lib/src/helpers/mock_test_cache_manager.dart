import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mocktail/mocktail.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

class MockTestCacheManager extends Mock implements BaseCacheManager {
  final WidgetbookGoldenTestsProperties properties;

  MockTestCacheManager({required this.properties}) {
    when(
      () => getFileStream(
        any(),
        headers: any(named: "headers"),
        key: any(named: "key"),
        withProgress: any(named: "withProgress"),
      ),
    ).thenAnswer((params) {
      final url = params.positionalArguments.first as String;
      if (properties.errorImageUrl == url) {
        return Stream.error(IgnoreNetworkImageException());
      } else if (url.endsWith(properties.loadingImageUrl)) {
        return Completer<FileResponse>().future.asStream();
      }

      return Stream.value(
        _MockFileInfo(imageUrl: url, resolver: properties.networkImageResolver),
      );
    });
  }
}

class _MockFileInfo extends Mock implements FileInfo {
  final NetworkImageResolver resolver;
  final String imageUrl;

  _MockFileInfo({required this.resolver, required this.imageUrl}) {
    final mockFile = _MockFile();
    when(() => mockFile.readAsBytes()).thenAnswer((_) async {
      final uri = Uri.parse(imageUrl);
      return Uint8List.fromList(resolver(uri));
    });
    when(() => file).thenReturn(mockFile);
  }
}

class _MockFile extends Mock implements File {}
