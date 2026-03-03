import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/coin_viewmodel.dart';
import 'views/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CoinViewModel>(
      create: (_) => CoinViewModel()..init(), // starts API + 1s ticker
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Week 6 API App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        ),
        home: const HomePage(),
      ),
    );
  }
}