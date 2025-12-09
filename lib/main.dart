import 'package:flutter/material.dart';
import 'views/home.dart';
//Rifqi Azhar Raditya
//230605110145

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movie App",
      theme: ThemeData(primarySwatch: Colors.orange),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
