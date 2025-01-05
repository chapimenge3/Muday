import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;
  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2B6777), // Calm teal
      surfaceTint: Color(0xff2B6777),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffC8E3E7), // Soft light teal
      onPrimaryContainer: Color(0xff001F26),
      secondary: Color(0xff52AB98), // Muted green
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffD5E8E3), // Soft light green
      onSecondaryContainer: Color(0xff0F1F1B),
      tertiary: Color(0xff7C8CA1), // Gentle blue-gray
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffE2E7F0), // Soft light blue-gray
      onTertiaryContainer: Color(0xff161B23),
      error: Color(0xffBA1A1A),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffFFDAD6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xffFAFAFA), // Almost white
      onSurface: Color(0xff1A1C1D),
      onSurfaceVariant: Color(0xff41484D),
      outline: Color(0xff72787D),
      outlineVariant: Color(0xffC1C7CD),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2E3132),
      inversePrimary: Color(0xff8ECFD6),
      surfaceDim: Color(0xffDBDCDD),
      surfaceBright: Color(0xffFAFAFA),
      surfaceContainerLowest: Color(0xffFFFFFF),
      surfaceContainerLow: Color(0xffF4F4F5),
      surfaceContainer: Color(0xffEEEEEF),
      surfaceContainerHigh: Color(0xffE8E8E9),
      surfaceContainerHighest: Color(0xffE2E2E3),
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff8ECFD6), // Soft teal
      surfaceTint: Color(0xff8ECFD6),
      onPrimary: Color(0xff00363D),
      primaryContainer: Color(0xff204E55), // Deep muted teal
      onPrimaryContainer: Color(0xffB9EAEF),
      secondary: Color(0xff9CCEC4), // Soft green
      onSecondary: Color(0xff233430),
      secondaryContainer: Color(0xff3A4B47), // Deep muted green
      onSecondaryContainer: Color(0xffD5E8E3),
      tertiary: Color(0xffBBC7DB), // Soft blue-gray
      onTertiary: Color(0xff263141),
      tertiaryContainer: Color(0xff3C4858), // Deep muted blue-gray
      onTertiaryContainer: Color(0xffD7E2F6),
      error: Color(0xffFFB4AB),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000A),
      onErrorContainer: Color(0xffFFDAD6),
      surface: Color(0xff1A1C1D), // Almost black
      onSurface: Color(0xffE2E2E3),
      onSurfaceVariant: Color(0xffC1C7CD),
      outline: Color(0xff8B9198),
      outlineVariant: Color(0xff41484D),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffE2E2E3),
      inversePrimary: Color(0xff2B6777),
      surfaceDim: Color(0xff1A1C1D),
      surfaceBright: Color(0xff37393A),
      surfaceContainerLowest: Color(0xff0F1112),
      surfaceContainerLow: Color(0xff1A1C1D),
      surfaceContainer: Color(0xff1E2021),
      surfaceContainerHigh: Color(0xff282A2B),
      surfaceContainerHighest: Color(0xff333536),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );
}
