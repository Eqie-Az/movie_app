import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_style.dart';
import '../../viewmodel/user_provider.dart';
import '../../viewmodel/language_provider.dart'; // [PENTING] Import LanguageProvider
import 'account_data_page.dart';
import '../home/home.dart';
import 'about.dart';
import 'language_page.dart';
import 'faq_page.dart';
import 'legal_page.dart';
import 'contact_us_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // [UPDATE] Ambil status bahasa
    final isIndo =
        Provider.of<LanguageProvider>(context).currentLocale.languageCode ==
        'id';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          isIndo ? "Pengaturan" : "Settings", // [TERJEMAHAN]
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildMenuItem(
                    context,
                    isIndo ? "Akun" : "Account",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccountDataPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildMenuItem(
                    context,
                    isIndo ? "Bahasa" : "Language",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LanguagePage(),
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildMenuItem(
                    context,
                    isIndo ? "Tentang Kami" : "About Us",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutPage(),
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildMenuItem(
                    context,
                    "FAQ",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FAQPage()),
                    ),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildMenuItem(
                    context,
                    isIndo ? "Syarat dan Ketentuan" : "Terms and Conditions",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LegalPage(type: LegalType.terms),
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildMenuItem(
                    context,
                    isIndo ? "Kebijakan Privasi" : "Privacy Policy",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LegalPage(type: LegalType.privacy),
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildMenuItem(
                    context,
                    isIndo ? "Hubungi Kami" : "Contact Us",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactUsPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: Text(isIndo ? "Versi App" : "App Version"),
                    trailing: const Text(
                      "4.2.0",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Divider(height: 1, indent: 16),
                  ListTile(
                    title: Text(
                      isIndo ? "Keluar" : "Log Out",
                      style: const TextStyle(color: Colors.red),
                    ), // [TERJEMAHAN]
                    onTap: () {
                      Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).logout();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
