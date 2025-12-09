import 'package:flutter/material.dart';
import '../../theme/app_style.dart';

class TicketHistoryPage extends StatelessWidget {
  const TicketHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // DATA DUMMY (MANUAL)
    // Saya ganti link gambarnya dengan poster yang valid (Zootopia 1 & Gladiator)
    final List<Map<String, dynamic>> tickets = [
      {
        "title": "Zootopia 2",
        "cinema": "CGV Grand Indonesia",
        "date": "28 Nov 2025",
        "time": "14:30",
        "seats": "C4, C5",
        "status": "Aktif",
        // [FIX] Menggunakan Link Poster Zootopia yang Valid (Stabil)
        "image":
            "https://image.tmdb.org/t/p/w500/hlK0e0wAQ3VLuJcsfIYPvb4JVud.jpg",
      },
      {
        "title": "Gladiator II",
        "cinema": "XXI Plaza Senayan",
        "date": "15 Nov 2025",
        "time": "19:00",
        "seats": "F10",
        "status": "Selesai",
        // [FIX] Menggunakan Link Poster Gladiator yang Valid
        "image":
            "https://image.tmdb.org/t/p/w500/2cxhvwyEwRlysAmRH4iodkvotO5.jpg",
      },
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: const Text(
            "Tiket Saya",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.primary,
          centerTitle: true,
          elevation: 0,
          bottom: const TabBar(
            labelColor: AppColors.accent,
            unselectedLabelColor: Colors.white70,
            indicatorColor: AppColors.accent,
            tabs: [
              Tab(text: "Tiket Aktif"),
              Tab(text: "Riwayat Transaksi"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Tiket Aktif
            _buildTicketList(
              tickets.where((t) => t['status'] == 'Aktif').toList(),
            ),

            // Tab 2: Tiket Selesai
            _buildTicketList(
              tickets.where((t) => t['status'] == 'Selesai').toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketList(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.confirmation_number_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              "Belum ada tiket",
              style: AppTextStyles.heading2.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final ticket = data[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Poster Film
              Container(
                width: 100,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                  color: Colors.grey.shade300,
                  image: DecorationImage(
                    // Menggunakan link dari data dummy di atas
                    image: NetworkImage(ticket['image']!),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      print("Error loading image: $exception");
                    },
                  ),
                ),
              ),

              // Detail Tiket
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket['title'],
                        style: AppTextStyles.heading2.copyWith(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ticket['cinema'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),

                      const Divider(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Tanggal",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                ticket['date'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Jam",
                                style: TextStyle(
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ticket['status'] == 'Aktif'
                                  ? Colors.green.shade50
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: ticket['status'] == 'Aktif'
                                    ? Colors.green
                                    : Colors.grey.shade400,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              ticket['status'],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: ticket['status'] == 'Aktif'
                                    ? Colors.green
                                    : Colors.grey,
                              ),
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
      },
    );
  }
}
