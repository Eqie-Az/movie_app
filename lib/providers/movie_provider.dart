import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieProvider extends ChangeNotifier {
  final MovieService _movieService = MovieService();

  // --- API Methods ---
  Future<List<Movie>> fetchMovies(String languageCode) async {
    try {
      return await _movieService.getNowPlayingMovies(languageCode);
    } catch (e) {
      return [];
    }
  }

  Future<List<Movie>> fetchUpcomingMovies(String languageCode) async {
    try {
      return await _movieService.getUpcomingMovies(languageCode);
    } catch (e) {
      return [];
    }
  }

  Future<List<Movie>> searchMovies(String query, String languageCode) async {
    try {
      return await _movieService.searchMovies(query, languageCode);
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchMovieDetailExtras(
    int movieId,
    String languageCode,
  ) async {
    return await _movieService.getMovieDetailExtras(movieId, languageCode);
  }

  // --- [FIX] BUSINESS LOGIC METHODS (Sesuai Error yang Muncul) ---

  // 1. Ambil jadwal dari Service
  List<String> getShowTimes() {
    return _movieService.getCinemaShowtimes();
  }

  // 2. Logika Generate Tanggal (7 Hari ke depan)
  List<Map<String, dynamic>> generateDateList(bool isIndo) {
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> tempDates = [];

    List<String> months = isIndo
        ? [
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "Mei",
            "Jun",
            "Jul",
            "Agu",
            "Sep",
            "Okt",
            "Nov",
            "Des",
          ]
        : [
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec",
          ];

    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      String dayName = i == 0
          ? (isIndo ? "HARI INI" : "TODAY")
          : _getDayName(date.weekday, isIndo);

      tempDates.add({
        "label": "${date.day} ${months[date.month - 1]}\n$dayName",
        "dateObj": date,
      });
    }
    return tempDates;
  }

  // Helper Private untuk nama hari singkat
  String _getDayName(int day, bool isIndo) {
    if (isIndo) {
      const days = ["SEN", "SEL", "RAB", "KAM", "JUM", "SAB", "MIN"];
      return days[day - 1];
    } else {
      const days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
      return days[day - 1];
    }
  }

  // 3. Logika Format Tanggal Lengkap (untuk dikirim ke Booking)
  String formatDate(DateTime date, bool isIndo) {
    List<String> monthsFull = isIndo
        ? [
            "Januari",
            "Februari",
            "Maret",
            "April",
            "Mei",
            "Juni",
            "Juli",
            "Agustus",
            "September",
            "Oktober",
            "November",
            "Desember",
          ]
        : [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December",
          ];

    String dayNameFull = isIndo
        ? [
            "Senin",
            "Selasa",
            "Rabu",
            "Kamis",
            "Jumat",
            "Sabtu",
            "Minggu",
          ][date.weekday - 1]
        : [
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday",
            "Sunday",
          ][date.weekday - 1];

    return "$dayNameFull, ${date.day} ${monthsFull[date.month - 1]} ${date.year}";
  }
}
