# Examples

## Declaring your test file

First, you need to create a test file with the `_test` suffix in your test folder. You could use something like `test/golden_test.dart`.

Inside it, wrap your call to `runAlchemistWidgetbookGoldenTests` inside an `AlchemistConfig.runWithConfig` block and pass the necessary parameters:

```dart
import 'package:alchemist/alchemist.dart';
import 'package:widgetbook_samples/main.directories.g.dart';
import 'package:widgetbook_golden_test_alchemist/widgetbook_golden_test_alchemist.dart';

/// Main example with minimum customization.
void main() {
  AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      // Add any platform configuration here
    ),
    run: () {
      runAlchemistWidgetbookGoldenTests(
        nodes: directories,
        properties: WidgetbookGoldenTestsProperties(),
      );
    },
  );
}
```


### Customized WidgetbookGoldenTestsProperties

The `WidgetbookGoldenTestsProperties` allows you to customize the behavior of the golden tests. You can modify the locale, theme, add Widgetbook addons and more. Here is an example of how:

```dart
void main() async {
  // Pre-load assets
  var mySvg = await File("./test/assets/custom.svg").readAsBytes();
  var myJpg =
      await File("./test/assets/custom.jpg").readAsBytes();
  const isRunningInCI = bool.fromEnvironment(
    'CI',
    defaultValue: true,
  );

  final properties = WidgetbookGoldenTestsProperties(
    theme: ThemeData.dark(),
    // Swap un purpose error and loading URLs for testing purposes
    errorImageUrl: "loading-network-image",
    loadingImageUrl: "error-network-image",
    testGroupName: "Widgetbook golden tests with custom properties",
    addons: [
      ViewportAddon([AndroidViewports.samsungGalaxyA50]),
      GridAddon(),
      AlignmentAddon(initialAlignment: Alignment.center),
      LocalizationAddon(
        locales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        initialLocale: Locale("es"),
      ),
      TextScaleAddon(initialScale: 2),
      ThemeAddon(
        themes: [
          WidgetbookTheme(
            name: 'Dark',
            data: ThemeData.dark().copyWith(
              extensions: [MyCustomTheme.dark()],
            ),
          ),
        ],
        themeBuilder: (BuildContext context, theme, Widget child) {
          return Theme(data: theme, child: child);
        },
      ),
    ],
    networkImageResolver: (uri) {
      if (uri.path.toLowerCase().endsWith(".svg")) {
        return mySvg;
      }
      return myJpg;
    },
  );

  runAlchemistWidgetbookGoldenTests(
    nodes: directories,
    goldenSnapshotsOutputPath: "./customized/",
    properties: properties,
  );
}
```

With all this customization, a snapshot would look like this:

## Use cases

### Red Sized Box

Let's start with a simple case. Given the following use case.

```dart
@widgetbook.UseCase(name: 'Red', type: SizedBox)
Widget buildRedSizedBoxUseCase(BuildContext context) {
  return SizedBox(height: 20, width: 20, child: Container(color: Colors.red));
}
```

#### Generated snapshots

![Snapshot generated for red Sized Box](<./test/goldens/ci/widgets/SizedBox/Red.png>)

If you are using the customization like the one mentioned in [above](#customized-widgetbookgoldentestsproperties), it will generate this instead:

![Snapshot generated for red Sized Box with customizations](<./test/goldens/ci/customized/widgets/SizedBox/Red.png>)

### Error builder of NetworkImage

Use `WidgetbookGoldenTestsProperties.defaultErrorImageUrl` as the URL of the Image.network widget to generate a snapshot of its errorBuilder.

#### Use case code snippet

```dart
@widgetbook.UseCase(name: 'Error', type: NetworkImage)
Widget buildImageNetworkErrorUseCase(BuildContext context) {
  return WidgetbookGoldenTestBuilder(
    constraints: const BoxConstraints(maxWidth: 320, maxHeight: 240),
    builder: (context) => Container(
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
    ),
  );
}
```

#### Generated snapshot

![Snapshot generated for error builder of NetworkImage](<./test/goldens/ci/painting/NetworkImage/Error.png>)

### Loading builder of NetworkImage

Use `WidgetbookGoldenTestsProperties.defaultLoadingImageUrl` as the URL of the Image.network widget to generate a snapshot of its loadingBuilder.

#### Use case code snippet

```dart
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
```

#### Generated snapshot

![Snapshot generated for loading builder of NetworkImage](<./test/goldens/ci/painting/NetworkImage/Loading.png>)

### CachedNetworkImage with GetIt integration

When using `CachedNetworkImage`, the package relies on a `BaseCacheManager` registered in `GetIt`. The test framework provides `MockTestCacheManager` to intercept network requests and return deterministic responses based on the configured URLs.

#### Setting up the mock cache manager

Register the mock cache manager before calling `runAlchemistWidgetbookGoldenTests`:

```dart
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:widgetbook_golden_test_alchemist/widgetbook_golden_test_alchemist.dart';

void main() {

  final properties = WidgetbookGoldenTestsProperties();
  GetIt.instance.registerLazySingleton<BaseCacheManager>(
    () => MockTestCacheManager(properties: properties),
  );

  runAlchemistWidgetbookGoldenTests(
    nodes: directories,
    properties: properties,
  );
}
```

The `MockTestCacheManager` uses the following URL conventions from `WidgetbookGoldenTestsProperties`:

- **`errorImageUrl`** (default: `"error-network-image"`) — Returns an error stream, triggering the `errorWidget` callback.
- **`loadingImageUrl`** (default: `"loading-network-image"`) — Returns a never-completing stream, simulating indefinite loading. The framework automatically skips precaching these images to avoid hanging indefinitely.
- **All other URLs** — Resolved via `networkImageResolver`, which returns pre-loaded bytes from your test assets.

#### Use case code snippet

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_it/get_it.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_golden_test_alchemist/widgetbook_golden_test_alchemist.dart';

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

@widgetbook.UseCase(name: 'Default', type: CachedNetworkImage)
Widget buildCachedNetworkImageUseCase(BuildContext context) {
  return WidgetbookGoldenTestBuilder(
    constraints: const BoxConstraints(maxWidth: 320, maxHeight: 240),
    builder: (context) =>
        cachedNetworkImageInContainer("https://placehold.co/320x240.png"),
  );
}

@widgetbook.UseCase(name: 'Error', type: CachedNetworkImage)
Widget buildCachedNetworkImageErrorUseCase(BuildContext context) {
  return WidgetbookGoldenTestBuilder(
    constraints: const BoxConstraints(maxWidth: 320, maxHeight: 240),
    builder: (context) => cachedNetworkImageInContainer(
      WidgetbookGoldenTestsProperties.defaultErrorImageUrl,
    ),
  );
}

@widgetbook.UseCase(name: 'Loading', type: CachedNetworkImage)
Widget buildCachedNetworkImageLoadingUseCase(BuildContext context) {
  return WidgetbookGoldenTestBuilder(
    constraints: const BoxConstraints(maxWidth: 320, maxHeight: 240),
    builder: (context) => cachedNetworkImageInContainer(
      WidgetbookGoldenTestsProperties.defaultLoadingImageUrl,
    ),
  );
}
```

#### Generated snapshots
##### Default
Fetches the image via `networkImageResolver` and displays it.
![Snapshot generated for CachedNetworkImage default](<./test/goldens/ci/CachedNetworkImage/GetIt cache manager.png>)

##### Error
Uses `defaultErrorImageUrl`, triggering the error widget.
![Snapshot generated for CachedNetworkImage error](<./test/goldens/ci/CachedNetworkImage/GetIt cache manager error.png>)

##### Loading
Uses `defaultLoadingImageUrl`, which returns a never-completing stream. The framework skips precaching this image, so the `progressIndicatorBuilder` renders static text ("Loading...") in this case.
![Snapshot generated for CachedNetworkImage loading](<./test/goldens/ci/CachedNetworkImage/GetIt cache manager loading.png>)

### Handling infinite animations with pump control

Widgets like `CircularProgressIndicator` run continuous animations that never settle. By default, the test framework calls `pumpAndSettle()` before and after precaching images, which would hang indefinitely on such widgets. Use `pumpBeforeImagePrecache` and `pumpAfterImagePrecache` to take control of the pump behavior.

#### How it works

The golden test rendering pipeline follows this sequence:

1. **Pump before** — Executes `pumpBeforeImagePrecache` (defaults to `tester.pumpAndSettle()`). Use this if you need to advance time or interact with widgets *before* precaching images.
2. **Precache images** — Precaches all image providers except those matching the `loadingImageUrl`, preventing infinite waits on loading states.
3. **Pump after** — Executes `pumpAfterImagePrecache` (defaults to `tester.pumpAndSettle()`). Use this to advance animations or settle widgets *after* precaching.

For widgets with infinite animations, set `pumpBeforeImagePrecache` to an empty function and use `pumpAfterImagePrecache` to pump a specific duration:

#### Use case code snippet

```dart
@widgetbook.UseCase(name: 'At 500ms', type: CircularProgressIndicator)
Widget buildCircularProgressIndicatorUseCase(BuildContext context) {
  return WidgetbookGoldenTestBuilder(
    // Skip settling before precaching (no images to precache here)
    pumpBeforeImagePrecache: (_) async => {},
    // Pump 500ms into the animation cycle for a deterministic snapshot
    pumpAfterImagePrecache: (tester) async => {
      await tester.pump(const Duration(milliseconds: 500)),
    },
    builder: (context) => const CircularProgressIndicator(),
  );
}

@widgetbook.UseCase(name: 'At 800ms', type: CircularProgressIndicator)
Widget buildCircularProgressIndicatorUseCaseAt800ms(BuildContext context) {
  return WidgetbookGoldenTestBuilder(
    pumpBeforeImagePrecache: (_) async => {},
    // Pump 800ms into the animation cycle for a different snapshot
    pumpAfterImagePrecache: (tester) async => {
      await tester.pump(const Duration(milliseconds: 800)),
    },
    builder: (context) => const CircularProgressIndicator(),
  );
}
```

#### Generated snapshots

Each use case captures the `CircularProgressIndicator` at a specific point in its animation cycle, producing deterministic golden images despite the continuous rotation. The "At 500ms" and "At 800ms" snapshots show the indicator at different positions:

![Snapshot generated for CircularProgressIndicator at 500ms](<./test/goldens/ci/material/CircularProgressIndicator/At 500ms.png>)
![Snapshot generated for CircularProgressIndicator at 800ms](<./test/goldens/ci/material/CircularProgressIndicator/At 800ms.png>)

### Pop up menu button with tap interaction

Wrap the widget in the use case in a `WidgetbookGoldenTestBuilder`. This will allow you to interact with the widget through the `goldenActions` you add to it before generating the snapshot.

#### Use case code snippet

```dart
@widgetbook.UseCase(name: 'Menu Button', type: PopupMenuButton)
Widget buildPopupMenuButtonUseCase(BuildContext context) {
  return WidgetbookGoldenTestBuilder(
    goldenActions: [
      GoldenPlayAction(
        name: "clicked",
        callback:
            (tester, find) async => tester.tap(find.byType(PopupMenuButton)),
        goldenFinder: (find) => find.byType(MaterialApp).first,
      ),
    ],
    builder:
        (context) => PopupMenuButton(
          itemBuilder:
              (context) => [
                PopupMenuItem(child: Text("First option")),
                PopupMenuItem(child: Icon(Icons.share)),
              ],
        ),
  );
}
```

#### Generated snapshots

The previous case will generate the following 2 snapshots, one for its default state and one for the `clicked` golden action:

##### Closed

![Snapshot generated for the PopupMenuButton closed](<./test/goldens/ci/material/PopupMenuButton/Menu Button.png>)

##### Opened

![Snapshot generated for PopupMenuButton opened](<./test/goldens/ci/material/PopupMenuButton/Menu Button - clicked.png>)
