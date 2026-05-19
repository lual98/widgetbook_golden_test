import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';
import 'package:widgetbook_samples/main.directories.g.dart';

void main() {
  final properties = WidgetbookGoldenTestsProperties();
  GetIt.instance.registerLazySingleton<BaseCacheManager>(
    () => MockTestCacheManager(properties: properties),
  );
  runWidgetbookGoldenTests(nodes: directories, properties: properties);
}
