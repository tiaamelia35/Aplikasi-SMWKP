Web build troubleshooting and recommended steps

This project may produce web-specific compilation errors (eg. `PromiseJsImpl`, `handleThenable`, `dartify/jsify`) when `firebase_*_web` packages are compiled. Those are usually caused by mismatched package versions.

Follow these steps locally to resolve and test:

1. Replace placeholder fonts in `assets/fonts/` with real Poppins `.ttf` files (from Google Fonts).

2. Clean and get packages:

```powershell
flutter clean
flutter pub get
```

3. Try a web run:

```powershell
flutter run -d chrome
```

4. If you get errors referencing `PromiseJsImpl`, `handleThenable`, `dartify`, `jsify`, or `platformViewRegistry`:

- Run:

```powershell
flutter pub outdated
```

- Look for `firebase_auth_web`, `firebase_messaging_web`, `image_cropper_for_web`, and similar web packages. Pin them in `pubspec.yaml` under `dependency_overrides` with versions compatible with your Flutter SDK. Example:

```yaml
dependency_overrides:
  firebase_auth_web: 5.8.1
  firebase_messaging_web: 3.5.10
  image_cropper_for_web: 3.0.0
```

- After pinning, run:

```powershell
flutter pub get
flutter clean
flutter run -d chrome
```

5. Alternative quick workaround (if you don't need Firebase on web while developing):

- Comment out the Firebase dependencies in `pubspec.yaml` temporarily, then run `flutter pub get` and `flutter run -d chrome`. Re-enable Firebase later when you want to test push notifications/auth on devices.

6. If `image_cropper` web errors appear (`platformViewRegistry`/`UnmodifiableUint8ListView`):

- Try upgrading `image_cropper` and `image_cropper_for_web` to the latest compatible versions.
- If still failing, remove the web implementation or guard image cropper usage with `kIsWeb` checks.

7. Helpful commands:

```powershell
# show outdated packages
flutter pub outdated

# upgrade all packages where possible
flutter pub upgrade --major-versions
```

If you'd like, I can pin conservative package versions in `pubspec.yaml` for you — tell me whether to (A) pin suggested web package versions now, or (B) keep current versions and provide further diagnostics.