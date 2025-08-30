import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

var magentaPixel = base64Decode(
  """iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAD0lEQVR4AQEEAPv/AP8A/wQAAf/2bp8NAAAAAElFTkSuQmCC""",
);

@widgetbook.UseCase(name: 'ResizeCover200x200', type: Image)
Widget buildResizeImageUseCase(BuildContext context) {
  var image = MemoryImage(magentaPixel);
  return Image(
    image: ResizeImage(image, width: 200, height: 200),
    width: 200,
    height: 200,
    fit: BoxFit.cover,
  );
}
