import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  // 1. LIST INBOX (Riwayat Transaksi) - DIMULAI KOSONG []
  final List<Map<String, dynamic>> _inboxNotifications = [];

  // 2. LIST PROMO (Marketing - Tetap ada sebagai hiasan)
  final List<Map<String, dynamic>> _promoNotifications = [
    {
      "type": "promo",
      "title_id": "Udah Siap Nonton? 🍿",
      "title_en": "Ready to Watch? 🍿",
      "body_id":
          "Sambil pilih film, pesan cemilan dulu yuk! 🤤 Beli di CinemaTix Food.",
      "body_en":
          "While choosing a movie, let's order snacks! 🤤 Buy at CinemaTix Food.",
      "time": "21m",
      "isRead": false,
    },
    {
      "type": "info",
      "title_id": "ShopeePay Ada Promo 10K! 🤩",
      "title_en": "ShopeePay 10K Promo! 🤩",
      "body_id":
          "Buat kamu yang mau transaksi pakai ShopeePay, di CinemaTix ada promo cashback.",
      "body_en": "For those using ShopeePay, CinemaTix has cashback promos.",
      "time": "1h",
      "isRead": true,
    },
  ];

  List<Map<String, dynamic>> get inboxNotifications => _inboxNotifications;
  List<Map<String, dynamic>> get promoNotifications => _promoNotifications;

  // Getter Jumlah Notifikasi Belum Dibaca (Opsional untuk Badge Lonceng)
  int get notificationCount =>
      _inboxNotifications.where((n) => !n['isRead']).length;

  // [FUNGSI UTAMA] Menambah Notifikasi Baru (Dipanggil saat Bayar Sukses)
  void addNotification({
    required String titleId,
    required String titleEn,
    required String bodyId,
    required String bodyEn,
    required String type, // 'system' atau 'promo'
  }) {
    // Insert di index 0 agar muncul paling atas
    _inboxNotifications.insert(0, {
      "type": type,
      "title_id": titleId,
      "title_en": titleEn,
      "body_id": bodyId,
      "body_en": bodyEn,
      "time": "Baru saja", // Simplifikasi waktu
      "isRead": false,
    });
    notifyListeners();
  }

  // Fungsi Tandai Sudah Dibaca (Saat diklik)
  void markAsRead(int index) {
    if (index < _inboxNotifications.length) {
      _inboxNotifications[index]['isRead'] = true;
      notifyListeners();
    }
  }
}
