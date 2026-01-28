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
import 'package:widgetbook_samples/cases/image_cases.dart'
    as _widgetbook_samples_cases_image_cases;
import 'package:widgetbook_samples/cases/list_view.dart'
    as _widgetbook_samples_cases_list_view;
import 'package:widgetbook_samples/cases/network_image_cases.dart'
    as _widgetbook_samples_cases_network_image_cases;
import 'package:widgetbook_samples/cases/popup_menu_button.dart'
    as _widgetbook_samples_cases_popup_menu_button;
import 'package:widgetbook_samples/cases/sized_box_cases.dart'
    as _widgetbook_samples_cases_sized_box_cases;
import 'package:widgetbook_samples/cases/svg_picture.dart'
    as _widgetbook_samples_cases_svg_picture;
import 'package:widgetbook_samples/cases/text_cases.dart'
    as _widgetbook_samples_cases_text_cases;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookComponent(
    name: 'SvgPicture',
    useCases: [
      _widgetbook.WidgetbookUseCase(
        name: 'Error Network SVG',
        builder:
            _widgetbook_samples_cases_svg_picture.buildErrorNetworkSvgUseCase,
      ),
      _widgetbook.WidgetbookUseCase(
        name: 'Loading Network SVG',
        builder:
            _widgetbook_samples_cases_svg_picture.buildLoadingNetworkSvgUseCase,
      ),
      _widgetbook.WidgetbookUseCase(
        name: 'Network SVG',
        builder: _widgetbook_samples_cases_svg_picture.buildNetworkSvgUseCase,
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'material',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'PopupMenuButton',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Menu Button',
            builder: _widgetbook_samples_cases_popup_menu_button
                .buildPopupMenuButtonUseCase,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'painting',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'NetworkImage',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _widgetbook_samples_cases_network_image_cases
                .buildImageNetworkUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Error',
            builder: _widgetbook_samples_cases_network_image_cases
                .buildImageNetworkErrorUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Loading',
            builder: _widgetbook_samples_cases_network_image_cases
                .buildImageNetworkLoadingUseCase,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'widgets',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'Image',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'ResizeCover200x200',
            builder:
                _widgetbook_samples_cases_image_cases.buildResizeImageUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'ListView',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Long list with a button',
            builder: _widgetbook_samples_cases_list_view.buildListViewUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'SizedBox',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Blue',
            builder: _widgetbook_samples_cases_sized_box_cases
                .buildBlueSizedBoxUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Green',
            builder: _widgetbook_samples_cases_sized_box_cases
                .buildGreenSizedBoxUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Orange',
            builder: _widgetbook_samples_cases_sized_box_cases
                .buildOrangeSizedBoxUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Red',
            builder: _widgetbook_samples_cases_sized_box_cases
                .buildRedSizedBoxUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'Text',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Custom text with initial value',
            builder: _widgetbook_samples_cases_text_cases.buildTextUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Custom text without initial value',
            builder: _widgetbook_samples_cases_text_cases
                .buildTextWithoutInitialValueUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Custom theme extension text',
            builder: _widgetbook_samples_cases_text_cases
                .buildTextWithCustomThemeExtensionUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Localized text',
            builder:
                _widgetbook_samples_cases_text_cases.buildTextLocalizedUseCase,
          ),
        ],
      ),
    ],
  ),
];
