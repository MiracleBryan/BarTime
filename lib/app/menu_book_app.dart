part of '../main.dart';

class MenuBookApp extends StatelessWidget {
  const MenuBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bar Time',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFA8C8),
          brightness: Brightness.light,
          primary: const Color(0xFFD96D9A),
          secondary: const Color(0xFF6BB7DF),
          tertiary: const Color(0xFF9BAA82),
          surface: const Color(0xFFFFFBF6),
          onSurface: const Color(0xFF5A3B31),
        ),
        scaffoldBackgroundColor: const Color(0xFFE8F7FF),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xEFFFF8FC),
          foregroundColor: Color(0xFF8D4A63),
          surfaceTintColor: Color(0xFFFFD8E7),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFC7DC),
          foregroundColor: Color(0xFF6B2F46),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFFFBF6).withValues(alpha: 0.92),
          surfaceTintColor: const Color(0xFFFFD8E7),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xEFFFF8FC),
          indicatorColor: const Color(0xFFCFEFFF),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(
              color: Color(0xFF6B2F46),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Color(0xFFFFFBF6),
        ),
      ),
      home: const MenuHomeScreen(),
    );
  }
}
