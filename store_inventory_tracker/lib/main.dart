import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'providers/inventory_provider.dart';
import 'screens/product_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase start
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seedColor = const Color(0xFF2563EB); // nice blue

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Store Inventory Tracker',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
          scaffoldBackgroundColor: const Color(0xFFF4F5FB),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF4F5FB),
            elevation: 0,
            centerTitle: false,
            titleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFE5E7EB), // ash background
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 4,
            shape: StadiumBorder(),
          ),
        ),

        home: const ProductListScreen(),
      ),
    );
  }
}
