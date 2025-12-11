import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_style.dart';
import '../../providers/language_provider.dart';
import '../../providers/notification_provider.dart'; // Import Provider

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  // Fungsi menampilkan detail notifikasi saat diklik
  void _showNotificationDetail(
    BuildContext context,
    String title,
    String body,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(body, style: const TextStyle(fontSize: 14, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Tutup",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIndo =
        Provider.of<LanguageProvider>(context).currentLocale.languageCode ==
        'id';

    // Ambil data dinamis dari Provider
    final notifProvider = Provider.of<NotificationProvider>(context);
    final promoList = notifProvider.promoNotifications;
    final inboxList = notifProvider.inboxNotifications; // List Inbox Dinamis

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            isIndo ? "Notifikasi" : "Notifications",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            tabs: [
              Tab(text: isIndo ? "UNTUKMU" : "FOR YOU"),
              Tab(text: "INBOX"),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            // Tab 1: UNTUKMU (Promo)
            promoList.isEmpty
                ? _buildEmptyState(isIndo)
                : _buildNotificationList(
                    context,
                    notifProvider,
                    promoList,
                    isIndo,
                    isInbox: false,
                  ),

            // Tab 2: INBOX (Riwayat Transaksi) - Kosong di awal, terisi setelah bayar
            inboxList.isEmpty
                ? _buildEmptyState(isIndo)
                : _buildNotificationList(
                    context,
                    notifProvider,
                    inboxList,
                    isIndo,
                    isInbox: true,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(
    BuildContext context,
    NotificationProvider provider,
    List<Map<String, dynamic>> data,
    bool isIndo, {
    required bool isInbox,
  }) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8),
      itemCount: data.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 70),
      itemBuilder: (context, index) {
        final item = data[index];
        // Pilih bahasa teks
        final title = isIndo ? item['title_id'] : item['title_en'];
        final body = isIndo ? item['body_id'] : item['body_en'];

        return InkWell(
          // [FITUR KLIK]
          onTap: () {
            if (isInbox) provider.markAsRead(index); // Tandai baca
            _showNotificationDetail(context, title, body); // Buka Pop-up
          },
          child: Container(
            color: item['isRead']
                ? Colors.white
                : Colors.blue.shade50.withOpacity(0.3),
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    item['type'] == 'promo'
                        ? Icons.campaign
                        : Icons.notifications_none,
                    color: item['type'] == 'promo'
                        ? Colors.orange
                        : AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['type'] == 'promo'
                                ? "CinemaTix Promo"
                                : "CinemaTix Info",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item['time'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: item['isRead']
                              ? FontWeight.w600
                              : FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        body,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isIndo) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 50,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isIndo ? "Tidak Ada Notifikasi" : "No Notifications",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
