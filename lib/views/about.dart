import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Pastikan sudah 'flutter pub add url_launcher'
import '../theme/app_style.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // Link Repository GitHub
  final String _repoUrl = 'https://github.com/Eqie-Az/movie_app';

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(_repoUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $_repoUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Tentang Kami",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo Aplikasi
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.movie_creation_outlined,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),

            // Judul Aplikasi
            const Text(
              "CinemaTIX",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),

            // Deskripsi
            const Text(
              "Aplikasi ini dibuat untuk memudahkan pengguna dalam melihat jadwal film bioskop, "
              "mencari informasi film terbaru, dan melakukan simulasi pemesanan tiket secara online.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 1),
            const SizedBox(height: 20),

            // Informasi Pembuat (Sesuai Request)
            const Text(
              "Dibuat Oleh:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.person, color: AppColors.primary),
                      title: Text("Nama Lengkap"),
                      subtitle: Text(
                        "Rifqi Azhar Raditya",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.badge, color: AppColors.primary),
                      title: Text("NIM"),
                      subtitle: Text(
                        "230605110145",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Tombol Download / GitHub
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _launchUrl,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Warna ala GitHub
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.code, color: Colors.white),
                label: const Text(
                  "Lihat Source Code & Download",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Versi 1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
