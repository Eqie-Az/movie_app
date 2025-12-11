import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_style.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $urlString");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Hubungi Kami",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Punya pertanyaan atau kendala? Hubungi kami melalui saluran berikut:",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),

            _buildContactItem(
              icon: Icons.email_outlined,
              title: "Email",
              subtitle: "rifqiazharraditya@gmail.com",
              onTap: () => _launchUrl("mailto:rifqiazharraditya@gmail.com"),
            ),
            const Divider(),
            _buildContactItem(
              icon: Icons.phone_outlined,
              title: "Telepon / WhatsApp",
              subtitle: "+62 878-5382-2686",
              onTap: () => _launchUrl("https://wa.me/6287853822686"),
            ),
            const Divider(),
            _buildContactItem(
              icon: Icons.map_outlined,
              title: "Alamat Kantor",
              subtitle: "Jl. Gajayana No. 50, Malang, Indonesia",
              onTap: () {}, // Bisa diarahkan ke Google Maps jika mau
            ),

            const Spacer(),

            Center(
              child: Text(
                "Jam Operasional:\nSenin - Jumat, 09.00 - 17.00 WIB",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
