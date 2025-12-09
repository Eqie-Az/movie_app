import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Warna Utama TIX.ID (Biru Tua Gelap)
  static const Color primary = Color(0xFF1A237E);
  static const Color primaryDark = Color(0xFF001A4C);

  // Warna Tombol Beli Tiket (Biru TIX.ID)
  static const Color tixBlue = Color(0xFF00388D);

  // Warna Aksen (Kuning/Emas untuk promo)
  static const Color accent = Color(0xFFFFC107);

  // Background
  static const Color background = Colors.white;
  static const Color surface = Color(0xFFF5F5F5);

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  // Status Kursi
  static const Color seatAvailable = Colors.white;
  static const Color seatSelected = Color(0xFFFFC107);
  static const Color seatOccupied = Colors.grey;
}

class AppTextStyles {
  // Heading 1 (Judul Besar)
  static TextStyle get heading1 => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Heading 2 (Judul Sedang)
  static TextStyle get heading2 => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // --- BAGIAN INI YANG SEPERTINYA HILANG DI KODE ANDA ---
  static TextStyle get sectionHeader => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  // ------------------------------------------------------

  // Judul Film di Card
  static TextStyle get movieTitle => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Body Text Biasa
  static TextStyle get bodyText => GoogleFonts.roboto(
    fontSize: 14,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Teks Tombol
  static TextStyle get buttonText => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Teks Harga
  static TextStyle get price => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.accent,
  );
}
