import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieProvider extends ChangeNotifier {
  // Instance Service untuk memanggil API
  final MovieService _movieService = MovieService();

  // --- 1. Fetch Now Playing (Sedang Tayang) ---
  Future<List<Movie>> fetchMovies(String languageCode) async {
    try {
      return await _movieService.getNowPlayingMovies(languageCode);
    } catch (e) {
      debugPrint("Error fetching now playing: $e");
      return [];
    }
  }

  // --- 2. Fetch Upcoming (Akan Datang) ---
  Future<List<Movie>> fetchUpcomingMovies(String languageCode) async {
    try {
      return await _movieService.getUpcomingMovies(languageCode);
    } catch (e) {
      debugPrint("Error fetching upcoming: $e");
      return [];
    }
  }

  // --- 3. Search Movies (Pencarian) ---
  Future<List<Movie>> searchMovies(String query, String languageCode) async {
    try {
      return await _movieService.searchMovies(query, languageCode);
    } catch (e) {
      debugPrint("Error searching movies: $e");
      return [];
    }
  }

  // --- 4. Detail Extras (Video, Gambar, Pemeran) ---
  Future<Map<String, dynamic>> fetchMovieDetailExtras(
    int movieId,
    String languageCode,
  ) async {
    try {
      return await _movieService.getMovieDetailExtras(movieId, languageCode);
    } catch (e) {
      debugPrint("Error fetching details: $e");
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
