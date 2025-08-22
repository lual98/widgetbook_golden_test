// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

import 'cases/image_cases.dart'
    as _asset_widgetbook_golden_test_widgetbook_cases_image_cases;
import 'cases/network_image_cases.dart'
    as _asset_widgetbook_golden_test_widgetbook_cases_network_image_cases;
import 'cases/sized_box_cases.dart'
    as _asset_widgetbook_golden_test_widgetbook_cases_sized_box_cases;
import 'cases/text_cases.dart'
    as _asset_widgetbook_golden_test_widgetbook_cases_text_cases;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'painting',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'NetworkImage',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _asset_widgetbook_golden_test_widgetbook_cases_network_image_cases
                    .buildImageNetworkUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Error',
            builder:
                _asset_widgetbook_golden_test_widgetbook_cases_network_image_cases
                    .buildImageNetworkErrorUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Loading',
            builder:
                _asset_widgetbook_golden_test_widgetbook_cases_network_image_cases
                    .buildImageNetworkLoadingUseCase,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'widgets',
    children: [
      _widgetbook.WidgetbookLeafComponent(
        name: 'Image',
        useCase: _widgetbook.WidgetbookUseCase(
          name: 'ResizeCover200x200',
          builder:
              _asset_widgetbook_golden_test_widgetbook_cases_image_cases
                  .buildResizeImageUseCase,
        ),
      ),
      _widgetbook.WidgetbookComponent(
        name: 'SizedBox',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Blue',
            builder:
                _asset_widgetbook_golden_test_widgetbook_cases_sized_box_cases
                    .buildBlueSizedBoxUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Red',
            builder:
                _asset_widgetbook_golden_test_widgetbook_cases_sized_box_cases
                    .buildRedSizedBoxUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'Text',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Custom text with initial value',
            builder:
                _asset_widgetbook_golden_test_widgetbook_cases_text_cases
                    .buildTextUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Custom text without initial value',
            builder:
                _asset_widgetbook_golden_test_widgetbook_cases_text_cases
                    .buildTextWithoutInitialValueUseCase,
          ),
        ],
      ),
    ],
  ),
];
