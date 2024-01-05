import 'package:flutter/material.dart';
import 'package:project_mobile/auth/login_page.dart';
import 'package:project_mobile/pages/cart_provider.dart';
import 'package:project_mobile/pages/category_screen.dart';
import 'package:provider/provider.dart';

import 'auth/AuthProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    authProvider.initializeUserData();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: authProvider.isLoggedIn ? CategoryScreen() : LoginPage(),
    );
  }
}

