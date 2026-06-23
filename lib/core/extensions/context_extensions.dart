import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Custom semantic colors fallback
  CustomSemanticColors get appColors =>
      Theme.of(this).extension<CustomSemanticColors>() ?? CustomSemanticColors.fallback();

  /// User-facing strings stub to comply with context.l10n standard.
  AppLocalizationsStub get l10n => AppLocalizationsStub();
}

class AppLocalizationsStub {
  String get musicList => 'Music List';
  String get search => 'Search';
  String get player => 'Now Playing';
  String get searchPlaceholder => 'Search artist, song...';
  String get offlineMessage => 'No Internet Connection';
  String get unstableMessage => 'Connection is unstable';
  String get email => 'Email Address';
  String get password => 'Password';
  String get login => 'Log In';
  String get signUp => 'Sign Up';
  String get welcomeBack => 'Welcome to Spotify';
  String get explore => 'Explore';
  String get library => 'Your Library';
  String get premium => 'Premium';
  String get queue => 'Play Queue';
  String get lyrics => 'Lyrics';
  String get songs => 'Songs';
  String get home => 'Home';
}

class CustomSemanticColors extends ThemeExtension<CustomSemanticColors> {
  final Color success;
  final Color warning;
  final Color info;

  const CustomSemanticColors({
    required this.success,
    required this.warning,
    required this.info,
  });

  factory CustomSemanticColors.fallback() => const CustomSemanticColors(
        success: Color(0xFF1DB954), // Spotify Green
        warning: Colors.orange,
        info: Colors.blue,
      );

  @override
  CustomSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
  }) => CustomSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );

  @override
  CustomSemanticColors lerp(ThemeExtension<CustomSemanticColors>? other, double t) {
    if (other is! CustomSemanticColors) return this;
    return CustomSemanticColors(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      info: Color.lerp(info, other.info, t) ?? info,
    );
  }
}
