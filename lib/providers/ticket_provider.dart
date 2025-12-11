import 'package:flutter/material.dart';

class TicketProvider extends ChangeNotifier {
  // List untuk menyimpan tiket
  final List<Map<String, dynamic>> _tickets = [];

  // Getter agar bisa diambil dari UI
  List<Map<String, dynamic>> get tickets => _tickets;

  // Fungsi Tambah Tiket
  void addTicket({
    required String movieTitle,
    required String cinemaName,
    required String date,
    required String time,
    required List<String> seats,
    required String posterPath,
  }) {
    // Debug Print untuk memastikan fungsi terpanggil
    print("Menambahkan Tiket: $movieTitle, $seats");

    _tickets.add({
      'movieTitle': movieTitle,
      'cinemaName': cinemaName,
      'date': date,
      'time': time,
      'seats': seats,
      'posterPath': posterPath,
      'status': 'Aktif',
    });

    // PENTING: Beri tahu UI bahwa data berubah
    notifyListeners();
  }

  // Fungsi Cek Kursi Terjual (Untuk Seat Selection)
  List<String> getSoldSeats(
    String movieTitle,
    String cinemaName,
    String date,
    String time,
  ) {
    List<String> soldSeats = [];
    final relevantTickets = _tickets.where(
      (ticket) =>
          ticket['movieTitle'] == movieTitle &&
          ticket['cinemaName'] == cinemaName &&
          ticket['time'] == time,
    );

    for (var ticket in relevantTickets) {
      soldSeats.addAll(List<String>.from(ticket['seats']));
    }
    return soldSeats;
  }
}
