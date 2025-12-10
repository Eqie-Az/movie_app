import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/home.dart';
import 'viewmodel/language_provider.dart';
import 'viewmodel/notification_provider.dart'; // Provider Notifikasi
import 'viewmodel/user_provider.dart';
import 'viewmodel/ticket_provider.dart';
import 'viewmodel/auth_service.dart'; // [SUDAH DIKEMBALIKAN]

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
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
