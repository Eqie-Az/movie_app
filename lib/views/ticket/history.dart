import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_style.dart';
import '../../viewmodel/ticket_provider.dart';
import '../../viewmodel/language_provider.dart';
import '../../viewmodel/user_provider.dart';
import '../auth/login_page.dart';

class TicketHistoryPage extends StatelessWidget {
  const TicketHistoryPage({super.key});

  // Helper untuk menerjemahkan Tanggal (Senin -> Monday, dst)
  String _formatDate(String originalDate, bool isIndo) {
    // Jika format asli "Senin, 12 Des 2025"
    // Kita perlu parsing manual karena formatnya custom string

    // Kamus Hari
    final Map<String, String> days = {
      "Senin": "Monday",
      "Selasa": "Tuesday",
      "Rabu": "Wednesday",
      "Kamis": "Thursday",
      "Jumat": "Friday",
      "Sabtu": "Saturday",
      "Minggu": "Sunday",
      "Monday": "Senin",
      "Tuesday": "Selasa",
      "Wednesday": "Rabu",
      "Thursday": "Kamis",
      "Friday": "Jumat",
      "Saturday": "Sabtu",
      "Sunday": "Minggu",
    };

    // Kamus Bulan
    final Map<String, String> months = {
      "Jan": "Jan", "Feb": "Feb", "Mar": "Mar", "Apr": "Apr",
      "Mei": "May", "May": "Mei", // Mei/May
      "Jun": "Jun", "Jul": "Jul",
      "Agu": "Aug", "Aug": "Agu", // Agu/Aug
      "Sep": "Sep",
      "Okt": "Oct", "Oct": "Okt", // Okt/Oct
      "Nov": "Nov",
      "Des": "Dec", "Dec": "Des", // Des/Dec
    };

    String formatted = originalDate;

    // Jika target bahasa Inggris, tapi input Indonesia
    if (!isIndo) {
      days.forEach((key, value) {
        if (formatted.contains(key) && _isIndoDay(key)) {
          formatted = formatted.replaceAll(key, value);
        }
      });
      months.forEach((key, value) {
        if (formatted.contains(key) && _isIndoMonth(key)) {
          formatted = formatted.replaceAll(key, value);
        }
      });
    }
    // Jika target bahasa Indonesia, tapi input Inggris
    else {
      days.forEach((key, value) {
        if (formatted.contains(key) && !_isIndoDay(key)) {
          formatted = formatted.replaceAll(key, value);
        }
      });
      months.forEach((key, value) {
        if (formatted.contains(key) && !_isIndoMonth(key)) {
          formatted = formatted.replaceAll(key, value);
        }
      });
    }

    return formatted;
  }

  bool _isIndoDay(String day) {
    return [
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
      "Minggu",
    ].contains(day);
  }

  bool _isIndoMonth(String month) {
    return ["Mei", "Agu", "Okt", "Des"].contains(month);
  }

  @override
  Widget build(BuildContext context) {
    final tickets = Provider.of<TicketProvider>(context).tickets;
    final isIndo =
        Provider.of<LanguageProvider>(context).currentLocale.languageCode ==
        'id';
    final isLoggedIn = Provider.of<UserProvider>(context).isLoggedIn;

    // 1. TAMPILAN GUEST (BELUM LOGIN)
    if (!isLoggedIn) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            isIndo ? "Tiket Saya" : "My Tickets",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isIndo ? "Anda belum login" : "You are not logged in",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isIndo
                      ? "Silakan masuk untuk melihat tiket Anda."
                      : "Please login to view your tickets.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    ),
                    child: Text(
                      isIndo ? "Masuk atau Daftar" : "Login or Register",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 2. TAMPILAN MEMBER (SUDAH LOGIN)
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: Text(
            isIndo ? "Tiket Saya" : "My Tickets",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Container(
              color: AppColors.primary,
              child: TabBar(
                indicatorColor: Colors.yellow,
                indicatorWeight: 3,
                labelColor: Colors.yellow,
                unselectedLabelColor: Colors.white,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: isIndo ? "Tiket Aktif" : "Active Tickets"),
                  Tab(
                    text: isIndo ? "Riwayat Transaksi" : "Transaction History",
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTicketList(tickets, isIndo, isActiveTab: true),
                  _buildTicketList(tickets, isIndo, isActiveTab: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketList(
    List<Map<String, dynamic>> tickets,
    bool isIndo, {
    required bool isActiveTab,
  }) {
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.confirmation_number_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            Text(
              isIndo
                  ? (isActiveTab
                        ? "Belum ada tiket aktif"
                        : "Belum ada riwayat")
                  : (isActiveTab ? "No active tickets" : "No history"),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[tickets.length - 1 - index];
        return _buildTicketCard(ticket, isIndo, isActiveTab);
      },
    );
  }

  Widget _buildTicketCard(
    Map<String, dynamic> ticket,
    bool isIndo,
    bool isActiveTab,
  ) {
    // [UPDATE] Terjemahkan Tanggal di sini
    String displayDate = _formatDate(ticket['date'], isIndo);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            child: Image.network(
              ticket['posterPath'] ?? "https://via.placeholder.com/150",
              width: 100,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) =>
                  Container(width: 100, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket['movieTitle'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ticket['cinemaName'],
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isIndo ? "Tanggal" : "Date",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          // [UPDATE] Gunakan tanggal yang sudah diterjemahkan
                          Text(
                            displayDate,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isIndo ? "Jam" : "Time",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            ticket['time'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              isIndo ? "Tempat Duduk" : "Seats",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              (ticket['seats'] as List).join(", "),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isActiveTab
                                    ? Colors.green.shade50
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isActiveTab
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                              child: Text(
                                isActiveTab
                                    ? (isIndo ? "Aktif" : "Active")
                                    : (isIndo ? "Selesai" : "Completed"),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isActiveTab
                                      ? Colors.green
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
