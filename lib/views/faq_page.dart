import 'package:flutter/material.dart';
import '../theme/app_style.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "FAQ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pertanyaan 1
                  const Text(
                    "1.  Mengapa jadwal hari ini belum muncul di aplikasi TIX ID?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // VISUALISASI JADWAL (SIMULASI GAMBAR)
                  // Baris 1: XXI (Hanya Hari Ini)
                  Row(
                    children: [
                      _buildCinemaLabel("XXI", Colors.amber),
                      const SizedBox(width: 10),
                      _buildDateBox("1 JUN", "HARI INI", true),
                      _buildDateBox("2 JUN", "KAM", false),
                      _buildDateBox("3 JUN", "JUM", false),
                      _buildDateBox("4 JUN", "SAB", false),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Baris 2: CGV/Cinepolis (Pre-sale)
                  Row(
                    children: [
                      _buildCinemaLabel("CGV\nCINEPOLIS", Colors.blue.shade900),
                      const SizedBox(width: 10),
                      _buildDateBox("1 JUN", "HARI INI", true),
                      _buildDateBox("2 JUN", "KAM", true),
                      _buildDateBox("3 JUN", "JUM", true),
                      _buildDateBox("4 JUN", "SAB", false),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Penjelasan Teks 1
                  const Text(
                    "Jika tiket film tersebut dijual secara pre-sale, maka Anda dapat melakukan pembelian untuk beberapa hari kedepan. Namun, jika tidak dijual secara pre-sale maka hanya dapat dilakukan pembelian tiket di hari yang sama.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Penjelasan Teks 2
                  const Text(
                    "Sebagai informasi, seluruh penayangan jadwal film adalah kewenangan dari pihak bioskop masing-masing, kami tidak dapat mengetahui kapan dan jam berapa jadwal tersebut akan tersedia. TIX ID hanyalah berperan sebagai partner pembelian tiket secara online.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Pertanyaan 2
                  const Text(
                    "2.  Bagaimana cara membatalkan atau merubah pemesanan saya yang telah selesai?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // [BAGIAN YANG DIUBAH MENGGUNAKAN RICH TEXT]
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text:
                              "Setelah pembelian tiket Anda dinyatakan berhasil, maka Anda tidak dapat membatalkan atau merubah detail pesanan, dikarenakan ",
                        ),
                        // Bagian Teks Tebal
                        TextSpan(
                          text: "semua penjualan bersifat final",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              ". Agar terhindar dari masalah ini, kami menyarankan agar Anda memastikan kembali detail pembelian sebelum melakukan pembayaran.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tombol Bawah
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "LIHAT FAQ SELENGKAPNYA",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Kotak Logo Bioskop
  Widget _buildCinemaLabel(String text, Color color) {
    return Container(
      width: 60,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget Helper untuk Kotak Tanggal
  Widget _buildDateBox(String date, String day, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey.shade300,
        border: Border.all(color: isActive ? Colors.black : Colors.transparent),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: 9,
              color: isActive ? Colors.black : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            day,
            style: TextStyle(
              fontSize: 8,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
