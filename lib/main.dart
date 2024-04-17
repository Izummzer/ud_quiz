import 'package:flutter/material.dart';
import 'package:quiz_template/home_screen.dart';
// import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    // ChangeNotifierProvider(
    //   create: (context) => AppStates(),
    //   child: 
      MaterialApp(
        home: const Text('TEST FOR WEB'),//HomeScreen(),
        title: 'Urban Dictionary Quiz',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
    )
    // )
    ;
  }
}
