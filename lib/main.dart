import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Views & Providers
import 'views/home/home.dart';
import 'providers/language_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/user_provider.dart';
import 'providers/ticket_provider.dart';
import 'services/auth_service.dart'; // Jika auth_service masih di viewmodel (sesuaikan path jika dipindah ke services)

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      // [FIX] Pastikan nama kelasnya MovieApp, bukan MyApp
      child: const MovieApp(),
    ),
  );
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: "CinemaTix",
      theme: ThemeData(primarySwatch: Colors.orange),
      debugShowCheckedModeBanner: false,
      locale: languageProvider.currentLocale,
      home: const HomePage(),
    );
  }
}
