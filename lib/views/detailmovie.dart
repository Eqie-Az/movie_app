import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Wajib ada untuk memutar video
import '../model/movie.dart';
import '../theme/app_style.dart';
import '../viewmodel/movie_viewmodel.dart';
import 'booking/seat_selection.dart';

class DetailMoviePage extends StatefulWidget {
  final Movie movie;

  const DetailMoviePage({super.key, required this.movie});

  @override
  State<DetailMoviePage> createState() => _DetailMoviePageState();
}

class _DetailMoviePageState extends State<DetailMoviePage> {
  final MovieViewModel viewModel = MovieViewModel();
  late Future<Map<String, dynamic>> _galleryFuture;

  @override
  void initState() {
    super.initState();
    _galleryFuture = viewModel.fetchMovieGallery(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar Putih Sederhana
      appBar: AppBar(
        title: Text(
          widget.movie.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // 1. AREA GALERI (TRAILER & FOTO)
                  // Menggunakan FutureBuilder untuk memuat data video/gambar
                  FutureBuilder<Map<String, dynamic>>(
                    future: _galleryFuture,
                    builder: (context, snapshot) {
                      // Siapkan data
                      final String? trailerKey = snapshot.data?['trailer'];
                      final List<String> images =
                          snapshot.data?['images'] ?? [];

                      // Cek apakah data sudah siap
                      bool isLoading =
                          snapshot.connectionState == ConnectionState.waiting;

                      // Jika loading atau tidak ada data trailer/gambar sama sekali,
                      // Tampilkan Poster Utama sebagai cadangan
                      if (!isLoading && trailerKey == null && images.isEmpty) {
                        return _buildMainPosterFallback();
                      }

                      // Hitung jumlah item (Trailer + Images)
                      final int itemCount =
                          (trailerKey != null ? 1 : 0) + images.length;

                      return SizedBox(
                        height: 220, // Tinggi area scroll horizontal
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                itemCount: itemCount,
                                itemBuilder: (context, index) {
                                  // Logika penentuan item: Apakah ini Trailer atau Gambar?
                                  bool isTrailerItem =
                                      (trailerKey != null && index == 0);

                                  if (isTrailerItem) {
                                    return _buildTrailerCard(trailerKey);
                                  } else {
                                    // Geser index jika ada trailer (index 0 dipakai trailer)
                                    int imageIndex = trailerKey != null
                                        ? index - 1
                                        : index;
                                    return _buildImageCard(images[imageIndex]);
                                  }
                                },
                              ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // 2. INFO FILM
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul Besar
                        Text(
                          widget.movie.title,
                          style: AppTextStyles.heading1.copyWith(fontSize: 22),
                        ),

                        const SizedBox(height: 10),

                        // Rating & Tanggal
                        Row(
                          children: [
                            // Bintang & Rating
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "${widget.movie.voteAverage}/10",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(width: 20),

                            // Kalender & Tanggal
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              widget.movie.releaseDate,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ), // Garis pembatas tipis
                        const SizedBox(height: 20),

                        // Sinopsis
                        Text("Sinopsis", style: AppTextStyles.heading2),
                        const SizedBox(height: 10),
                        Text(
                          widget.movie.overview,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.justify,
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. TOMBOL BELI TIKET (Fixed di Bawah)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // Warna Biru Tua
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SeatSelectionPage(movieTitle: widget.movie.title),
                    ),
                  );
                },
                child: const Text(
                  "BELI TIKET",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  // 1. Kartu Trailer (Thumbnail + Tombol Play Merah)
  Widget _buildTrailerCard(String youtubeKey) {
    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse(
          "https://www.youtube.com/watch?v=$youtubeKey",
        );
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          debugPrint("Gagal membuka trailer");
        }
      },
      child: Container(
        width: 320, // Lebar fixed agar menonjol
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            // Mengambil thumbnail kualitas tinggi dari YouTube
            image: NetworkImage(
              "https://img.youtube.com/vi/$youtubeKey/mqdefault.jpg",
            ),
            fit: BoxFit.cover,
            opacity: 0.8, // Sedikit gelap agar tombol play terlihat
          ),
        ),
        child: Center(
          // Tombol Play Merah
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
          ),
        ),
      ),
    );
  }

  // 2. Kartu Gambar Tambahan
  Widget _buildImageCard(String imageUrl) {
    return Container(
      width: 140, // Lebih kecil dari trailer
      margin: const EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  // 3. Fallback jika tidak ada trailer/gambar (Tampilkan Poster Utama)
  Widget _buildMainPosterFallback() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          widget.movie.posterPath,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter, // Agar crop bagian atas (wajah aktor)
        ),
      ),
    );
  }
}
