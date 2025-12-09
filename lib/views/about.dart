import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      // appBar: AppBar(
      //   backgroundColor: Colors.orangeAccent,
      //   title: const Text("About App"),
      //   centerTitle: true,
      // ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.movie_creation_outlined,
                size: 100,
                color: Colors.orangeAccent,
              ),
              SizedBox(height: 20),
              Text(
                "Movie Info App 🎬",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Movie Info App adalah aplikasi Flutter sederhana "
                "yang menampilkan daftar film populer, kategori film, dan detail informasi "
                "dengan menggunakan data JSON lokal tanpa koneksi internet\n(tanpa API).",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 30),
              Text(
                "📱 Dibuat untuk memenuhi UTS Praktikum Mobile Programming\n"
                "Universitas Islam Negeri Maulana Malik Ibrahim Malang, Tahun 2025",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 40),
              Text(
                "Dibuat oleh:\nNama: Rifqi Azhar Raditya\nNIM: 230605110145",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
