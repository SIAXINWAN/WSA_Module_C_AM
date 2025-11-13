import 'package:flutter/material.dart';
import 'package:functionality_tablet/pages/welcomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/sidebar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  final prefs = await SharedPreferences.getInstance();
  final bool isEng = prefs.getBool('eng') ?? true; 

  runApp(MyApp(isEng: isEng));
}

class MyApp extends StatelessWidget {
  final bool isEng;

  const MyApp({super.key, required this.isEng});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomePage(isEng: isEng),
    );
  }
}
