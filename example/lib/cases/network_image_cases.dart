import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';

@widgetbook.UseCase(name: 'Default', type: NetworkImage)
Widget buildImageNetworkUseCase(BuildContext context) {
  return Container(
    color: Colors.green,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        "https://placehold.co/320x240.png",
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, loadingProgress) {
          return loadingProgress == null ? child : Text("Loading...");
        },
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Error', type: NetworkImage)
Widget buildImageNetworkErrorUseCase(BuildContext context) {
  return Container(
    color: Colors.green,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        WidgetbookGoldenTestsProperties.defaultErrorImageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, loadingProgress) {
          return loadingProgress == null ? child : Text("Loading...");
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Text(
              'Error loading image',
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Loading', type: NetworkImage)
Widget buildImageNetworkLoadingUseCase(BuildContext context) {
  return Container(
    color: Colors.blue,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        WidgetbookGoldenTestsProperties.defaultLoadingImageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, loadingProgress) {
          return loadingProgress == null ? child : Text("Loading...");
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Text(
              'Error loading image',
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      ),
    ),
  );
}
