import 'package:fluent_ui/fluent_ui.dart';

class RaptorThemeData {
  static FluentThemeData myFluentTheme = FluentThemeData(
    accentColor: AccentColor.swatch(
      const {
        'normal': Color(0xFF2E8C40), // themePrimary
        'lighter': Color(0xFF07160A), // themeLighter
        'darker': Color(0xFF3C984D), // themeDarkAlt
      },
    ), // themePrimary
    brightness: Brightness.dark, // Assuming dark theme based on colors

    // Customizing colors
    scaffoldBackgroundColor: const Color(0xFF0B0E1C), // white
    cardColor: const Color(0xFF15192F), // neutralLighter

    typography: const Typography.raw(
      display: TextStyle(
        color: Color(0xFFFFFFFF), // neutralPrimary
        fontSize: 20, // Customize as needed
      ),
      body: TextStyle(
        color: Color(0xFFC8C8C8), // neutralTertiary
        fontSize: 16, // Customize as needed
      ),
      caption: TextStyle(
        color: Color(0xFFDADADA), // neutralPrimaryAlt
        fontSize: 14, // Customize as needed
      ),
    ),

    // Optional additional mapping
    focusTheme: FocusThemeData(
      glowColor: const Color(0xFF3C984D), // themeDarkAlt
    ),

    // NavigationPane theme example
    navigationPaneTheme: NavigationPaneThemeData(
      backgroundColor: const Color(0xFF101326), // neutralLighterAlt
      selectedIconColor: WidgetStateProperty.all(const Color(0xFF2E8C40)),
      selectedTextStyle: WidgetStateProperty.all(
          const TextStyle(color: Color(0xFF2E8C40))), // themePrimary
      // themePrimary
    ),
  );
}
