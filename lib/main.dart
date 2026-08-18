import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/audioplayer_provider.dart';
import 'package:provider/provider.dart';
import 'providers/favorite_provider.dart';
import 'pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final favProvider = FavoriteProvider();
  await favProvider.initStorage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: favProvider),
        ChangeNotifierProvider(create: (context) => AudioPlayerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}
