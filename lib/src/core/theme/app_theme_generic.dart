import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/window_effect.dart';
import 'package:system_theme/system_theme.dart';

import 'app_theme.dart';

class AppThemeGeneric {
  AccentColor? color;
  ThemeMode mode;
  PaneDisplayMode displayMode;
  NavigationIndicators indicator;
  WindowEffect windowEffect;
  TextDirection textDirection;
  Locale? locale;

  AppThemeGeneric({
    this.color,
    this.mode = ThemeMode.system,
    this.displayMode = PaneDisplayMode.auto,
    this.indicator = NavigationIndicators.sticky,
    this.windowEffect = WindowEffect.disabled,
    this.textDirection = TextDirection.ltr,
    this.locale,
  });

  AccentColor get effectiveColor => color ?? systemAccentColor;

  AppThemeGeneric update({
    AccentColor? color,
    ThemeMode? mode,
    PaneDisplayMode? displayMode,
    NavigationIndicators? indicator,
    WindowEffect? windowEffect,
    TextDirection? textDirection,
    Locale? locale,
  }) {
    return AppThemeGeneric(
      color: color ?? this.color,
      mode: mode ?? this.mode,
      displayMode: displayMode ?? this.displayMode,
      indicator: indicator ?? this.indicator,
      windowEffect: windowEffect ?? this.windowEffect,
      textDirection: textDirection ?? this.textDirection,
      locale: locale ?? this.locale,
    );
  }
}

AccentColor get systemAccentColor {
  if ((defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.android) &&
      !kIsWeb) {
    return AccentColor.swatch({
      'darkest': SystemTheme.accentColor.darkest,
      'darker': SystemTheme.accentColor.darker,
      'dark': SystemTheme.accentColor.dark,
      'normal': SystemTheme.accentColor.accent,
      'light': SystemTheme.accentColor.light,
      'lighter': SystemTheme.accentColor.lighter,
      'lightest': SystemTheme.accentColor.lightest,
    });
  }
  return Colors.blue;
}
