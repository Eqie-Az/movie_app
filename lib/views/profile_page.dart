import 'package:flutter/material.dart';
import '../theme/app_style.dart';
import 'login_page.dart'; // [PENTING] Jangan lupa import ini!

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Akun Saya",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER BIRU
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // [BAGIAN PENTING] Pastikan kodingan ini ada:
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    // ----------------------------------------------------
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007BFF),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Masuk atau Daftar Akun",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // MENU LIST
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  _buildMenuItem("Bahasa"),
                  const Divider(height: 1, indent: 16),
                  _buildMenuItem("Tentang Kami"),
                  const Divider(height: 1, indent: 16),
                  _buildMenuItem("FAQ"),
                  const Divider(height: 1, indent: 16),
                  _buildMenuItem("Syarat dan Ketentuan"),
                  const Divider(height: 1, indent: 16),
                  _buildMenuItem("Kebijakan Privasi"),
                  const Divider(height: 1, indent: 16),
                  _buildMenuItem("Hubungi Kami"),
                ],
              ),
            ),

            // FOOTER VERSI
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Versi App", style: TextStyle(color: Colors.grey)),
                  Text("4.2.0", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
