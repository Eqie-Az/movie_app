import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_style.dart';
import '../../viewmodel/user_provider.dart';
import '../../viewmodel/language_provider.dart'; // [PENTING] Import LanguageProvider
import '../auth/login_page.dart';
import 'settings_page.dart';
import 'about.dart';
import 'language_page.dart';
import 'faq_page.dart';
import 'legal_page.dart';
import 'contact_us_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // [UPDATE] Ambil status bahasa
    final isIndo =
        Provider.of<LanguageProvider>(context).currentLocale.languageCode ==
        'id';
    final isLoggedIn = userProvider.isLoggedIn;

    // ------------------------------------------
    // MODE MEMBER (SUDAH LOGIN)
    // ------------------------------------------
    if (isLoggedIn) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: Text(
            isIndo ? "Akun Saya" : "My Account", // [TERJEMAHAN]
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
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header User
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userProvider.userName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "+62 ${userProvider.userPhone}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Banner VIP (CinemaTIX)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.stars, color: Colors.orange),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              // [GANTI NAMA & TERJEMAHAN]
                              isIndo
                                  ? "Jadilah CinemaTix VIP ✨ Dapatkan untung lebih 🤩"
                                  : "Be a CinemaTix VIP ✨ Get more benefits 🤩",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Menu Member
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      isIndo ? "Voucher Saya" : "My Vouchers",
                      Icons.card_giftcard,
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuItem(
                      context,
                      isIndo ? "Film Saya" : "My Movies",
                      Icons.movie_creation_outlined,
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuItem(
                      context,
                      isIndo ? "Konten Yang Disukai" : "Liked Content",
                      Icons.favorite_border,
                    ),
                    const Divider(height: 1, indent: 56),

                    // [UPDATE] Bagikan CinemaTIX
                    _buildMenuItem(
                      context,
                      isIndo
                          ? "Bagikan CinemaTix & Dapatkan Koin!"
                          : "Share CinemaTix & Get Coins!",
                      Icons.share,
                      trailing: "AXGDV2",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    // ------------------------------------------
    // MODE GUEST (BELUM LOGIN)
    // ------------------------------------------
    else {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: Text(
            isIndo ? "Akun Saya" : "My Account", // [TERJEMAHAN]
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                decoration: const BoxDecoration(color: AppColors.primary),
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007BFF),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isIndo
                            ? "Masuk atau Daftar Akun"
                            : "Login or Register", // [TERJEMAHAN]
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _buildMenuGuest(
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
                    _buildMenuGuest(
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
                    _buildMenuGuest(
                      context,
                      "FAQ",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FAQPage(),
                        ),
                      ),
                    ),
                    const Divider(height: 1, indent: 16),
                    _buildMenuGuest(
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
                    _buildMenuGuest(
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
                    _buildMenuGuest(
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

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isIndo ? "Versi App" : "App Version",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Text("4.2.0", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon, {
    String? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) ...[
            Text(
              trailing,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(width: 8),
          ],
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildMenuGuest(
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
