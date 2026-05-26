part of '../main.dart';

class MenuBookApp extends StatelessWidget {
  const MenuBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu Book',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8ECDF7),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFEAF7FF),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFFEAF7FF),
          foregroundColor: Color(0xFF3E7FA8),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFB8E1FF),
          foregroundColor: Color(0xFF245B7C),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFFF8FCFF),
          indicatorColor: const Color(0xFFFFD7E8),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const MenuHomeScreen(),
    );
  }
}
