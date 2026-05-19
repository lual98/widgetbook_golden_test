import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';

Widget cachedNetworkImageInContainer(String url) {
  return Container(
    color: Colors.green,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CachedNetworkImage(
        cacheManager: GetIt.instance.get(),
        imageUrl: url,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (_, _, _) {
          return const Text("Loading...");
        },
        errorWidget: (_, _, _) {
          return const Text(
            "Error loading",
            style: TextStyle(color: Colors.red),
          );
        },
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GetIt cache manager', type: CachedNetworkImage)
Widget buildCachedNetworkImageUseCase(BuildContext context) {
  return WidgetbookGoldenTestBuilder(
    constraints: const BoxConstraints(maxWidth: 320, maxHeight: 240),
    builder: (context) =>
        cachedNetworkImageInContainer("https://placehold.co/320x240.png"),
  );
}

@widgetbook.UseCase(name: 'GetIt cache manager error', type: CachedNetworkImage)
Widget buildCachedNetworkImageErrorUseCase(BuildContext context) {
  return WidgetbookGoldenTestBuilder(
    constraints: const BoxConstraints(maxWidth: 320, maxHeight: 240),
    builder: (context) => cachedNetworkImageInContainer(
      WidgetbookGoldenTestsProperties.defaultErrorImageUrl,
    ),
  );
}

@widgetbook.UseCase(
  name: 'GetIt cache manager loading',
  type: CachedNetworkImage,
)
Widget buildCachedNetworkImageLoadingUseCase(BuildContext context) {
  return WidgetbookGoldenTestBuilder(
    constraints: const BoxConstraints(maxWidth: 320, maxHeight: 240),
    builder: (context) => cachedNetworkImageInContainer(
      WidgetbookGoldenTestsProperties.defaultLoadingImageUrl,
    ),
  );
}
