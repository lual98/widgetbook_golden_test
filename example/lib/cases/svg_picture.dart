import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_golden_test/widgetbook_golden_test.dart';

@widgetbook.UseCase(name: 'Network SVG', type: SvgPicture)
Widget buildNetworkSvgUseCase(BuildContext context) {
  return SvgPicture.network(
    "https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/android.svg",
    height: 600,
    width: 400,
    errorBuilder:
        (context, _, trace) =>
            Container(height: 200, width: 200, color: Colors.red),
  );
}

@widgetbook.UseCase(name: 'Error Network SVG', type: SvgPicture)
Widget buildErrorNetworkSvgUseCase(BuildContext context) {
  return SvgPicture.network(
    WidgetbookGoldenTestsProperties.defaultErrorImageUrl,
    height: 600,
    width: 400,
    errorBuilder:
        (context, _, trace) =>
            Container(height: 200, width: 200, color: Colors.red),
  );
}

@widgetbook.UseCase(name: 'Loading Network SVG', type: SvgPicture)
Widget buildLoadingNetworkSvgUseCase(BuildContext context) {
  return SvgPicture.network(
    WidgetbookGoldenTestsProperties.defaultLoadingImageUrl,
    height: 600,
    width: 400,
    placeholderBuilder: (context) => Text("Loading..."),
    errorBuilder:
        (context, _, trace) =>
            Container(height: 200, width: 200, color: Colors.red),
  );
}
