import 'package:flutter/material.dart';
import '../theme/app_style.dart';

enum LegalType { terms, privacy }

class LegalPage extends StatefulWidget {
  final LegalType type;

  const LegalPage({super.key, required this.type});

  @override
  State<LegalPage> createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> {
  bool _isIndo = true; // Default Bahasa Indonesia

  @override
  Widget build(BuildContext context) {
    // Tentukan Judul & Konten berdasarkan Tipe Halaman (Terms / Privacy)
    String titleAppbar = widget.type == LegalType.terms
        ? "Syarat dan Ketentuan"
        : "Kebijakan Privasi";

    String titleContent = widget.type == LegalType.terms
        ? (_isIndo ? "PERSYARATAN PENGGUNAAN" : "TERMS OF USE")
        : (_isIndo ? "KEBIJAKAN PRIVASI" : "PRIVACY POLICY");

    String content = widget.type == LegalType.terms
        ? (_isIndo ? _termsIndo : _termsEn)
        : (_isIndo ? _privacyIndo : _privacyEn);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          titleAppbar,
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
      body: Column(
        children: [
          const SizedBox(height: 20),

          // --- TOMBOL SWITCH BAHASA ---
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(child: _buildLanguageButton("Indonesia", true)),
                Expanded(child: _buildLanguageButton("English", false)),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // --- KONTEN ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleContent,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    content,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String text, bool isButtonIndo) {
    // Cek apakah tombol ini sedang aktif
    bool isActive = (_isIndo == isButtonIndo);

    return GestureDetector(
      onTap: () {
        setState(() {
          _isIndo = isButtonIndo;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.grey.shade800
              : Colors.transparent, // Warna gelap jika aktif
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bendera (Icon Sederhana)
            Text(
              isButtonIndo ? "🇮🇩" : "🇺🇸",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- DATA TEKS DUMMY (Sesuai Foto & Umum) ---

  final String _termsIndo = """
KETENTUAN PENGGUNAAN DI BAWAH INI HARUS DIBACA SEBELUM MENGGUNAKAN APLIKASI INI.

PENGGUNAAN APLIKASI INI MENUNJUKKAN PENERIMAAN DAN KEPATUHAN TERHADAP SYARAT DAN KETENTUAN INI.

Selamat datang di Aplikasi Movie App yang dimiliki dan dikelola oleh Kami. Aplikasi ini bertujuan untuk memberikan informasi jadwal film dan simulasi pemesanan tiket.

1. Layanan
Aplikasi ini menyediakan informasi mengenai film, jadwal tayang, dan bioskop. Kami berhak mengubah atau menghentikan layanan kapan saja tanpa pemberitahuan sebelumnya.

2. Akun Pengguna
Anda bertanggung jawab untuk menjaga kerahasiaan akun dan kata sandi Anda. Segala aktivitas yang terjadi di bawah akun Anda adalah tanggung jawab Anda sepenuhnya.

3. Pembelian Tiket
Semua simulasi pembelian tiket dalam aplikasi ini bersifat final dan tidak dapat dibatalkan atau diubah setelah konfirmasi, kecuali dinyatakan lain oleh kebijakan bioskop terkait.
""";

  final String _termsEn = """
THE TERMS OF USE BELOW MUST BE READ BEFORE USING THIS APPLICATION.

USE OF THIS APPLICATION INDICATES ACCEPTANCE AND COMPLIANCE WITH THESE TERMS AND CONDITIONS.

Welcome to the Movie App owned and managed by Us. This application aims to provide movie schedule information and ticket booking simulation.

1. Services
This application provides information regarding movies, showtimes, and cinemas. We reserve the right to modify or discontinue the service at any time without prior notice.

2. User Accounts
You are responsible for maintaining the confidentiality of your account and password. All activities that occur under your account are your sole responsibility.

3. Ticket Purchase
All ticket purchase simulations in this application are final and cannot be cancelled or changed after confirmation, unless otherwise stated by the relevant cinema policy.
""";

  final String _privacyIndo = """
Kami menghargai privasi Anda dan berkomitmen untuk melindungi data pribadi Anda. Kebijakan ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi Anda.

1. Informasi yang Kami Kumpulkan
Kami mengumpulkan informasi yang Anda berikan secara langsung, seperti nama, nomor telepon, dan alamat email saat Anda mendaftar akun.

2. Penggunaan Informasi
Informasi Anda digunakan untuk menyediakan layanan, memproses pesanan tiket, dan mengirimkan pembaruan terkait aplikasi.

3. Keamanan Data
Kami menerapkan langkah-langkah keamanan teknis untuk melindungi data Anda dari akses yang tidak sah.
""";

  final String _privacyEn = """
We value your privacy and are committed to protecting your personal data. This policy explains how we collect, use, and protect your information.

1. Information We Collect
We collect information you provide directly, such as your name, phone number, and email address when you register for an account.

2. Use of Information
Your information is used to provide services, process ticket orders, and send application-related updates.

3. Data Security
We implement technical security measures to protect your data from unauthorized access.
""";
}
