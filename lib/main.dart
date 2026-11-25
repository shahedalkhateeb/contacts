import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'splash_screen.dart';

void main() => runApp(const ContactsApp());

class ContactsApp extends StatelessWidget {
  const ContactsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contacts',
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}