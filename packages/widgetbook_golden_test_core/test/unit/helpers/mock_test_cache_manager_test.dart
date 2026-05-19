import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetbook_golden_test_core/widgetbook_golden_test_core.dart';

void main() {
  group(MockTestCacheManager, () {
    test(
      'returns error stream when URL matches errorImageUrl exactly',
      () async {
        final properties = WidgetbookGoldenTestsProperties(
          errorImageUrl: 'error-network-image',
        );
        final cacheManager = MockTestCacheManager(properties: properties);

        // The check is exact equality, so pass the exact errorImageUrl as URL
        final stream = cacheManager.getFileStream('error-network-image');

        await expectLater(
          stream,
          emitsInOrder([
            emitsError(isA<IgnoreNetworkImageException>()),
            emitsDone,
          ]),
        );
      },
    );

    test(
      'returns error stream when URL matches custom errorImageUrl',
      () async {
        final properties = WidgetbookGoldenTestsProperties(
          errorImageUrl: 'custom-error-url',
        );
        final cacheManager = MockTestCacheManager(properties: properties);

        final stream = cacheManager.getFileStream('custom-error-url');

        await expectLater(
          stream,
          emitsError(isA<IgnoreNetworkImageException>()),
        );
      },
    );

    test('returns error stream for default errorImageUrl', () async {
      final properties = WidgetbookGoldenTestsProperties();
      final cacheManager = MockTestCacheManager(properties: properties);

      final stream = cacheManager.getFileStream(
        WidgetbookGoldenTestsProperties.defaultErrorImageUrl,
      );

      await expectLater(
        stream,
        emitsInOrder([
          emitsError(isA<IgnoreNetworkImageException>()),
          emitsDone,
        ]),
      );
    });

    test('returns pending stream when URL ends with loadingImageUrl', () async {
      final properties = WidgetbookGoldenTestsProperties(
        loadingImageUrl: 'loading-network-image',
      );
      final cacheManager = MockTestCacheManager(properties: properties);

      // URL must END WITH the loadingImageUrl string
      final stream = cacheManager.getFileStream(
        'https://example.com/image-loading-network-image',
      );

      // Pending stream never emits and never completes - verify no event within timeout
      await expectLater(
        stream.first.timeout(const Duration(milliseconds: 100)),
        throwsA(isA<TimeoutException>()),
      );
    });

    test(
      'returns pending stream when URL ends with custom loadingImageUrl',
      () async {
        final properties = WidgetbookGoldenTestsProperties(
          loadingImageUrl: 'custom-loading-url',
        );
        final cacheManager = MockTestCacheManager(properties: properties);

        // URL must END WITH the loadingImageUrl string (not just contain it)
        final stream = cacheManager.getFileStream(
          'https://example.com/custom-loading-url',
        );

        await expectLater(
          stream.first.timeout(const Duration(milliseconds: 100)),
          throwsA(isA<TimeoutException>()),
        );
      },
    );

    test('returns pending stream for default loadingImageUrl', () async {
      final properties = WidgetbookGoldenTestsProperties();
      final cacheManager = MockTestCacheManager(properties: properties);

      final stream = cacheManager.getFileStream(
        'https://example.com/image-loading-network-image',
      );

      await expectLater(
        stream.first.timeout(const Duration(milliseconds: 100)),
        throwsA(isA<TimeoutException>()),
      );
    });

    test('returns success stream with FileInfo for normal URLs', () async {
      final properties = WidgetbookGoldenTestsProperties();
      final cacheManager = MockTestCacheManager(properties: properties);

      final stream = cacheManager.getFileStream(
        'https://example.com/image.png',
      );

      await expectLater(stream, emitsInOrder([isA<FileInfo>(), emitsDone]));
    });

    test('returns success stream with custom networkImageResolver', () async {
      final properties = WidgetbookGoldenTestsProperties(
        networkImageResolver: (uri) => [1, 2, 3, 4],
      );
      final cacheManager = MockTestCacheManager(properties: properties);

      final fileInfo = await streamFirstValue(
        cacheManager.getFileStream('https://example.com/custom.png'),
      );
      expect(fileInfo, isA<FileInfo>());
    });

    test('getFileStream with named arguments works correctly', () async {
      final properties = WidgetbookGoldenTestsProperties();
      final cacheManager = MockTestCacheManager(properties: properties);

      final stream = cacheManager.getFileStream(
        'https://example.com/image.png',
        headers: {'Authorization': 'Bearer token'},
        key: 'test-key',
        withProgress: true,
      );

      await expectLater(stream, emitsInOrder([isA<FileInfo>(), emitsDone]));
    });

    test('handles multiple getFileStream calls independently', () async {
      final properties = WidgetbookGoldenTestsProperties();
      final cacheManager = MockTestCacheManager(properties: properties);

      // Use exact errorImageUrl string for error stream
      final errorStream = cacheManager.getFileStream('error-network-image');
      // URL ending with loadingImageUrl for pending stream
      final loadingStream = cacheManager.getFileStream(
        'https://example.com/image-loading-network-image',
      );
      final successStream = cacheManager.getFileStream(
        'https://example.com/normal.png',
      );

      // Error stream should emit error
      await expectLater(
        errorStream,
        emitsInOrder([
          emitsError(isA<IgnoreNetworkImageException>()),
          emitsDone,
        ]),
      );

      // Loading stream should never emit (pending)
      await expectLater(
        loadingStream.first.timeout(const Duration(milliseconds: 100)),
        throwsA(isA<TimeoutException>()),
      );

      // Success stream should emit FileInfo and complete
      await expectLater(
        successStream,
        emitsInOrder([isA<FileInfo>(), emitsDone]),
      );
    });
  });

  group('_MockFileInfo', () {
    test('file returns a mock File', () async {
      final properties = WidgetbookGoldenTestsProperties();
      final cacheManager = MockTestCacheManager(properties: properties);

      final fileInfoStream = cacheManager.getFileStream(
        'https://example.com/image.png',
      );

      await for (final response in fileInfoStream) {
        expect(response, isA<FileInfo>());
        final fileInfo = response as FileInfo;
        expect(fileInfo.file, isA<File>());
        break;
      }
    });

    test(
      'file.readAsBytes() resolves to bytes from default resolver for PNG',
      () async {
        final properties = WidgetbookGoldenTestsProperties();
        final cacheManager = MockTestCacheManager(properties: properties);

        final fileInfoStream = cacheManager.getFileStream(
          'https://example.com/image.png',
        );

        await for (final response in fileInfoStream) {
          final fileInfo = response as FileInfo;
          final bytes = await fileInfo.file.readAsBytes();
          expect(bytes, isA<Uint8List>());
          // Default resolver returns transparent PNG for .png extension
          expect(bytes.length, greaterThan(0));
          break;
        }
      },
    );

    test(
      'file.readAsBytes() resolves to SVG bytes from default resolver',
      () async {
        final properties = WidgetbookGoldenTestsProperties();
        final cacheManager = MockTestCacheManager(properties: properties);

        final fileInfoStream = cacheManager.getFileStream(
          'https://example.com/image.svg',
        );

        await for (final response in fileInfoStream) {
          final fileInfo = response as FileInfo;
          final bytes = await fileInfo.file.readAsBytes();
          expect(bytes, isA<Uint8List>());
          // Default resolver returns empty SVG for .svg extension
          expect(bytes, equals('<svg viewBox="0 0 10 10" />'.codeUnits));
          break;
        }
      },
    );

    test(
      'file.readAsBytes() resolves to transparent PNG for unknown extensions',
      () async {
        final properties = WidgetbookGoldenTestsProperties();
        final cacheManager = MockTestCacheManager(properties: properties);

        final fileInfoStream = cacheManager.getFileStream(
          'https://example.com/image.unknown',
        );

        await for (final response in fileInfoStream) {
          final fileInfo = response as FileInfo;
          final bytes = await fileInfo.file.readAsBytes();
          expect(bytes, isA<Uint8List>());
          // Default resolver returns transparent PNG as fallback
          expect(bytes.length, greaterThan(0));
          break;
        }
      },
    );

    test('file.readAsBytes() resolves to custom resolver bytes', () async {
      final customBytes = Uint8List.fromList([10, 20, 30, 40]);
      final properties = WidgetbookGoldenTestsProperties(
        networkImageResolver: (uri) => customBytes.toList(),
      );
      final cacheManager = MockTestCacheManager(properties: properties);

      final fileInfoStream = cacheManager.getFileStream(
        'https://example.com/custom.png',
      );

      await for (final response in fileInfoStream) {
        final fileInfo = response as FileInfo;
        final bytes = await fileInfo.file.readAsBytes();
        expect(bytes, equals(customBytes));
        break;
      }
    });

    test('file.readAsBytes() passes correct URI to resolver', () async {
      Uri? capturedUri;
      final properties = WidgetbookGoldenTestsProperties(
        networkImageResolver: (uri) {
          capturedUri = uri;
          return [1, 2, 3];
        },
      );
      final cacheManager = MockTestCacheManager(properties: properties);

      final fileInfoStream = cacheManager.getFileStream(
        'https://example.com/path/to/image.png',
      );

      await for (final response in fileInfoStream) {
        final fileInfo = response as FileInfo;
        await fileInfo.file.readAsBytes();
        expect(capturedUri, isNotNull);
        expect(
          capturedUri!.toString(),
          equals('https://example.com/path/to/image.png'),
        );
        break;
      }
    });

    test(
      'file.readAsBytes() resolves bytes for normal URLs even when errorImageUrl is set',
      () async {
        final properties = WidgetbookGoldenTestsProperties(
          errorImageUrl: 'error-network-image',
          networkImageResolver: (uri) => [99, 88, 77],
        );
        final cacheManager = MockTestCacheManager(properties: properties);

        final fileInfoStream = cacheManager.getFileStream(
          'https://example.com/normal.png',
        );

        await for (final response in fileInfoStream) {
          final fileInfo = response as FileInfo;
          final bytes = await fileInfo.file.readAsBytes();
          expect(bytes, equals([99, 88, 77]));
          break;
        }
      },
    );
  });

  group('MockTestCacheManager integration', () {
    test('errorImageUrl takes precedence over loadingImageUrl check', () async {
      // If errorImageUrl and loadingImageUrl could overlap (e.g., both in URL),
      // errorImageUrl should take priority since it's checked first.
      final properties = WidgetbookGoldenTestsProperties(
        errorImageUrl: 'loading-network-image',
        loadingImageUrl: 'loading-network-image',
      );
      final cacheManager = MockTestCacheManager(properties: properties);

      // Since errorImageUrl check comes first, this should emit an error
      final stream = cacheManager.getFileStream('loading-network-image');

      await expectLater(
        stream,
        emitsInOrder([
          emitsError(isA<IgnoreNetworkImageException>()),
          emitsDone,
        ]),
      );
    });

    test('loadingImageUrl uses endsWith matching', () async {
      final properties = WidgetbookGoldenTestsProperties(
        loadingImageUrl: 'loading',
      );
      final cacheManager = MockTestCacheManager(properties: properties);

      // URL ending with "loading" should be treated as loading state
      final stream = cacheManager.getFileStream(
        'https://example.com/image-loading',
      );

      await expectLater(
        stream.first.timeout(const Duration(milliseconds: 100)),
        throwsA(isA<TimeoutException>()),
      );
    });

    test('properties are stored and accessible', () async {
      final properties = WidgetbookGoldenTestsProperties(
        errorImageUrl: 'my-error',
        loadingImageUrl: 'my-loading',
      );
      final cacheManager = MockTestCacheManager(properties: properties);

      expect(cacheManager.properties.errorImageUrl, equals('my-error'));
      expect(cacheManager.properties.loadingImageUrl, equals('my-loading'));
    });

    test(
      'normal URLs are not affected by error or loading URL patterns',
      () async {
        final properties = WidgetbookGoldenTestsProperties(
          errorImageUrl: 'error-network-image',
          loadingImageUrl: 'loading-network-image',
        );
        final cacheManager = MockTestCacheManager(properties: properties);

        // A normal URL that doesn't match either pattern should succeed
        final stream = cacheManager.getFileStream(
          'https://example.com/normal.png',
        );

        await expectLater(stream, emitsInOrder([isA<FileInfo>(), emitsDone]));
      },
    );

    test('errorImageUrl exact match does not trigger for similar URLs', () async {
      final properties = WidgetbookGoldenTestsProperties(
        errorImageUrl: 'error-network-image',
      );
      final cacheManager = MockTestCacheManager(properties: properties);

      // A URL that contains the error string but doesn't exactly match should succeed
      final stream = cacheManager.getFileStream(
        'https://example.com/error-network-image.png',
      );

      await expectLater(stream, emitsInOrder([isA<FileInfo>(), emitsDone]));
    });
  });
}

/// Helper to get the first value emitted by a stream.
Future<T> streamFirstValue<T>(Stream<T> stream) async {
  final controller = StreamController<T>();
  final sub = stream.listen(
    (data) {
      if (!controller.isClosed) {
        controller.add(data);
        controller.close();
      }
    },
    onError: (error) {
      if (!controller.isClosed) {
        controller.addError(error);
        controller.close();
      }
    },
    onDone: () {
      if (!controller.isClosed) {
        controller.close();
      }
    },
  );
  controller.onCancel = () => sub.cancel();
  return controller.stream.first;
}
