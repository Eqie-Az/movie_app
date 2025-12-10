import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/movie.dart';

class MovieViewModel {
  static const String _apiKey =
      '3a8b66ce7b80e698cfa26e6104b598d2'; // API Key Anda
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // 1. SEDANG TAYANG (Menggunakan endpoint 'now_playing' agar lebih akurat)
  Future<List<Movie>> fetchMovies(String languageCode) async {
    try {
      String apiLang = languageCode == 'id' ? 'id-ID' : 'en-US';
      // Gunakan now_playing agar beda dengan upcoming
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/movie/now_playing?api_key=$_apiKey&language=$apiLang&page=1',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body)['results'];
        return results.map((e) => Movie.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat film sedang tayang');
      }
    } catch (e) {
      throw Exception('Kesalahan koneksi: $e');
    }
  }

  // 2. AKAN DATANG (Menggunakan endpoint 'upcoming')
  Future<List<Movie>> fetchUpcomingMovies(String languageCode) async {
    try {
      String apiLang = languageCode == 'id' ? 'id-ID' : 'en-US';
      // Endpoint upcoming berisi film masa depan
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/movie/upcoming?api_key=$_apiKey&language=$apiLang&page=1',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body)['results'];
        return results.map((e) => Movie.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat film akan datang');
      }
    } catch (e) {
      return [];
    }
  }

  // 3. SEARCH (Pencarian)
  Future<List<Movie>> searchMovies(String query, String languageCode) async {
    try {
      String apiLang = languageCode == 'id' ? 'id-ID' : 'en-US';
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/search/movie?api_key=$_apiKey&query=$query&language=$apiLang',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body)['results'];
        return results.map((e) => Movie.fromJson(e)).toList();
      } else {
        throw Exception('Gagal mencari film');
      }
    } catch (e) {
      return [];
    }
  }

  // 4. FETCH DETAIL (Detail Film)
  Future<Map<String, dynamic>> fetchMovieDetailExtras(
    int movieId,
    String languageCode,
  ) async {
    try {
      String apiLang = languageCode == 'id' ? 'id-ID' : 'en-US';

      final responseDetail = await http.get(
        Uri.parse(
          '$_baseUrl/movie/$movieId?api_key=$_apiKey&language=$apiLang',
        ),
      );
      final responseVideo = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId/videos?api_key=$_apiKey'),
      );
      final responseImages = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId/images?api_key=$_apiKey'),
      );
      final responseCredits = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId/credits?api_key=$_apiKey'),
      );

      String genres = "";
      String duration = "-";
      String? trailerKey;
      List<String> imageUrls = [];
      List<Map<String, String>> castList = [];

      if (responseDetail.statusCode == 200) {
        final data = json.decode(responseDetail.body);
        final List<dynamic> genreList = data['genres'] ?? [];
        genres = genreList.map((g) => g['name'].toString()).join(", ");

        int runtime = data['runtime'] ?? 0;
        int hours = runtime ~/ 60;
        int minutes = runtime % 60;
        duration = "${hours}j ${minutes}m";
      }

      if (responseVideo.statusCode == 200) {
        final data = json.decode(responseVideo.body);
        final results = data['results'] as List;
        final trailer = results.firstWhere(
          (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
          orElse: () => null,
        );
        if (trailer != null) trailerKey = trailer['key'];
      }

      if (responseImages.statusCode == 200) {
        final data = json.decode(responseImages.body);
        final backdrops = data['backdrops'] as List;
        for (var item in backdrops.take(5)) {
          if (item['file_path'] != null) {
            imageUrls.add(
              'https://image.tmdb.org/t/p/w500${item['file_path']}',
            );
          }
        }
      }

      if (responseCredits.statusCode == 200) {
        final data = json.decode(responseCredits.body);
        final cast = data['cast'] as List;
        for (var c in cast.take(10)) {
          castList.add({
            'name': c['name'] ?? 'Unknown',
            'role': c['character'] ?? '-',
            'image': c['profile_path'] != null
                ? 'https://image.tmdb.org/t/p/w200${c['profile_path']}'
                : '',
          });
        }
      }

      return {
        'genres': genres,
        'duration': duration,
        'trailer': trailerKey,
        'images': imageUrls,
        'cast': castList,
      };
    } catch (e) {
      return {
        'genres': '',
        'duration': '-',
        'trailer': null,
        'images': [],
        'cast': [],
      };
    }
  }
}
