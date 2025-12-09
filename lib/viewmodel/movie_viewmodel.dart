import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/movie.dart';

class MovieViewModel {
  // API Key Anda
  static const String _apiKey = '3a8b66ce7b80e698cfa26e6104b598d2';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // ---------------------------------------------------------------------------
  // 1. MENGAMBIL DAFTAR FILM POPULER (HOME PAGE)
  // ---------------------------------------------------------------------------
  Future<List<Movie>> fetchMovies() async {
    try {
      // a. Request Data Bahasa Indonesia (Prioritas Utama)
      // LINK API: https://api.themoviedb.org/3/movie/popular?api_key=3a8b66ce7b80e698cfa26e6104b598d2&language=id-ID
      final responseIndo = await http.get(
        Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=id-ID'),
      );

      // b. Request Data Bahasa Inggris (Sebagai Cadangan jika sinopsis kosong)
      // LINK API: https://api.themoviedb.org/3/movie/popular?api_key=3a8b66ce7b80e698cfa26e6104b598d2&language=en-US
      final responseEn = await http.get(
        Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=en-US'),
      );

      if (responseIndo.statusCode == 200 && responseEn.statusCode == 200) {
        final List<dynamic> resultsIndo = json.decode(
          responseIndo.body,
        )['results'];
        final List<dynamic> resultsEn = json.decode(responseEn.body)['results'];

        List<Movie> movies = [];

        for (int i = 0; i < resultsIndo.length; i++) {
          var movieJson = resultsIndo[i]; // Ambil data Indo

          // LOGIKA UTAMA: Cek apakah overview (sinopsis) kosong?
          if (movieJson['overview'] == null || movieJson['overview'] == "") {
            // Jika kosong, cari film yang sama di list Inggris berdasarkan ID
            var movieEn = resultsEn.firstWhere(
              (element) => element['id'] == movieJson['id'],
              orElse: () => null,
            );

            // Jika ketemu data Inggrisnya, pakai sinopsis Inggris
            if (movieEn != null && movieEn['overview'] != "") {
              movieJson['overview'] = movieEn['overview'];
            }
          }

          // Masukkan ke dalam list model
          movies.add(Movie.fromJson(movieJson));
        }

        return movies;
      } else {
        throw Exception('Gagal memuat daftar film');
      }
    } catch (e) {
      print("Error fetching movies: $e");
      throw Exception('Terjadi kesalahan koneksi');
    }
  }

  // ---------------------------------------------------------------------------
  // 2. FITUR PENCARIAN FILM (SEARCH)
  // ---------------------------------------------------------------------------
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final responseIndo = await http.get(
        Uri.parse(
          '$_baseUrl/search/movie?api_key=$_apiKey&query=$query&language=id-ID',
        ),
      );
      final responseEn = await http.get(
        Uri.parse(
          '$_baseUrl/search/movie?api_key=$_apiKey&query=$query&language=en-US',
        ),
      );

      if (responseIndo.statusCode == 200 && responseEn.statusCode == 200) {
        final List<dynamic> resultsIndo = json.decode(
          responseIndo.body,
        )['results'];
        final List<dynamic> resultsEn = json.decode(responseEn.body)['results'];

        List<Movie> movies = [];
        for (int i = 0; i < resultsIndo.length; i++) {
          var movieJson = resultsIndo[i];

          if (movieJson['overview'] == null || movieJson['overview'] == "") {
            var movieEn = resultsEn.firstWhere(
              (element) => element['id'] == movieJson['id'],
              orElse: () => null,
            );
            if (movieEn != null) {
              movieJson['overview'] = movieEn['overview'];
            }
          }
          movies.add(Movie.fromJson(movieJson));
        }
        return movies;
      } else {
        throw Exception('Gagal mencari film');
      }
    } catch (e) {
      print("Error searching movies: $e");
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // 3. MENGAMBIL TRAILER & GALERI FOTO (DETAIL PAGE) - [BARU]
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchMovieGallery(int movieId) async {
    try {
      // a. Ambil Video (Trailer)
      final responseVideo = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId/videos?api_key=$_apiKey'),
      );

      // b. Ambil Gambar (Backdrops/Posters tambahan)
      final responseImages = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId/images?api_key=$_apiKey'),
      );

      String? trailerKey;
      List<String> imageUrls = [];

      // Proses Data Video
      if (responseVideo.statusCode == 200) {
        final data = json.decode(responseVideo.body);
        final results = data['results'] as List;

        // Cari video yang tipenya 'Trailer' dan situsnya 'YouTube'
        final trailer = results.firstWhere(
          (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
          orElse: () => null,
        );

        if (trailer != null) {
          trailerKey = trailer['key']; // Simpan Key Youtube
        }
      }

      // Proses Data Gambar
      if (responseImages.statusCode == 200) {
        final data = json.decode(responseImages.body);
        final backdrops = data['backdrops'] as List;

        // Ambil maksimal 5 gambar backdrop
        for (var item in backdrops.take(5)) {
          if (item['file_path'] != null) {
            imageUrls.add(
              'https://image.tmdb.org/t/p/w500${item['file_path']}',
            );
          }
        }
      }

      return {
        'trailer': trailerKey, // ID Youtube atau null
        'images': imageUrls, // List URL gambar tambahan
      };
    } catch (e) {
      print("Error gallery: $e");
      return {'trailer': null, 'images': []};
    }
  }
}
