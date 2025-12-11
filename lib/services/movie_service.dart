import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const String _apiKey = '3a8b66ce7b80e698cfa26e6104b598d2';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // 1. Fetch Now Playing
  Future<List<Movie>> getNowPlayingMovies(String languageCode) async {
    String apiLang = languageCode == 'id' ? 'id-ID' : 'en-US';
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/movie/now_playing?api_key=$_apiKey&language=$apiLang&page=1',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      return results.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat film');
    }
  }

  // 2. [BARU] Fetch Upcoming (Tambahkan ini!)
  Future<List<Movie>> getUpcomingMovies(String languageCode) async {
    String apiLang = languageCode == 'id' ? 'id-ID' : 'en-US';
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
  }

  // 3. Search Movies
  Future<List<Movie>> searchMovies(String query, String languageCode) async {
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
  }

  // 4. Get Detail Extras
  Future<Map<String, dynamic>> getMovieDetailExtras(
    int movieId,
    String languageCode,
  ) async {
    String apiLang = languageCode == 'id' ? 'id-ID' : 'en-US';
    try {
      final responseDetail = await http.get(
        Uri.parse(
          '$_baseUrl/movie/$movieId?api_key=$_apiKey&language=$apiLang',
        ),
      );
      final responseVideo = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId/videos?api_key=$_apiKey'),
      );
      final responseCredits = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId/credits?api_key=$_apiKey'),
      );

      String genres = "";
      String duration = "-";
      String? trailerKey;
      List<Map<String, String>> castList = [];

      if (responseDetail.statusCode == 200) {
        final data = json.decode(responseDetail.body);
        final List<dynamic> genreList = data['genres'] ?? [];
        genres = genreList.map((g) => g['name'].toString()).join(", ");
        int runtime = data['runtime'] ?? 0;
        duration = "${runtime ~/ 60}j ${runtime % 60}m";
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

      if (responseCredits.statusCode == 200) {
        final data = json.decode(responseCredits.body);
        final cast = data['cast'] as List;
        for (var c in cast.take(10)) {
          castList.add({
            'name': c['name']?.toString() ?? 'Unknown',
            'role': c['character']?.toString() ?? '-',
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
        'cast': castList,
      };
    } catch (e) {
      return {'genres': '', 'duration': '-', 'trailer': null, 'cast': []};
    }
  }
}
