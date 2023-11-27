import 'package:bus_eka/firebase_options.dart';
import 'package:bus_eka/screens/home.dart';
import 'package:bus_eka/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      debugShowCheckedModeBanner: false,
      title: "Bus eka",
      home: const Home(),
      // home: const LoginScreen(),
    );
  }
}
