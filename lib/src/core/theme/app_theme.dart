import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:system_theme/system_theme.dart';

import 'package:fluent_ui/fluent_ui.dart';

import 'app_theme_generic.dart';

enum NavigationIndicators { sticky, end }

// Riverpod provider for AppTheme
final appThemeProvider =
    StateNotifierProvider<AppThemeNotifier, AppThemeGeneric>((ref) {
  return AppThemeNotifier();
});

// StateNotifier for AppTheme
class AppThemeNotifier extends StateNotifier<AppThemeGeneric> {
  AppThemeNotifier() : super(AppThemeGeneric());

  void setColor(AccentColor color) {
    state = state.update(color: color);
  }

  void setMode(ThemeMode mode) {
    state = state.update(mode: mode);
  }

  void setDisplayMode(PaneDisplayMode displayMode) {
    state = state.update(displayMode: displayMode);
  }

  void setIndicator(NavigationIndicators indicator) {
    state = state.update(indicator: indicator);
  }

  void setWindowEffect(WindowEffect windowEffect) {
    state = state.update(windowEffect: windowEffect);
  }

  void setEffect(WindowEffect effect, BuildContext context) {
    Window.setEffect(
      effect: effect,
      color: [
        WindowEffect.solid,
        WindowEffect.acrylic,
      ].contains(effect)
          ? FluentTheme.of(context).micaBackgroundColor.withOpacity(0.05)
          : Colors.transparent,
      dark: FluentTheme.of(context).brightness.isDark,
    );
  }

  void setTextDirection(TextDirection direction) {
    state = state.update(textDirection: direction);
  }

  void setLocale(Locale? locale) {
    state = state.update(locale: locale);
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
