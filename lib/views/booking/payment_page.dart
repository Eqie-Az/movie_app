import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_style.dart';
import '../../viewmodel/ticket_provider.dart';
import '../../viewmodel/language_provider.dart';
import '../../viewmodel/notification_provider.dart'; // [IMPORT INI]
import '../home/home.dart';

class PaymentPage extends StatefulWidget {
  final String movieTitle;
  final String cinemaName;
  final String date;
  final String time;
  final List<String> seats;
  final int totalPrice;
  final String posterPath;

  const PaymentPage({
    super.key,
    required this.movieTitle,
    required this.cinemaName,
    required this.date,
    required this.time,
    required this.seats,
    required this.totalPrice,
    this.posterPath = "https://image.tmdb.org/t/p/w500/nm9d10Y00X97792a.jpg",
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPayment = "DANA";
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _showPinDialog(bool isIndo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            isIndo
                ? "Masukkan PIN $_selectedPayment"
                : "Enter $_selectedPayment PIN",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isIndo ? "Total Tagihan:" : "Total Amount:",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                "Rp ${widget.totalPrice}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "******",
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _pinController.clear();
                Navigator.pop(ctx);
              },
              child: Text(
                isIndo ? "Batal" : "Cancel",
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                if (_pinController.text.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isIndo ? "PIN harus 6 digit" : "PIN must be 6 digits",
                      ),
                    ),
                  );
                } else {
                  Navigator.pop(ctx);
                  _showLoadingAndProcess(isIndo);
                }
              },
              child: Text(
                isIndo ? "Bayar" : "Pay",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLoadingAndProcess(bool isIndo) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pop(context);

    _processPaymentSuccess(isIndo);
  }

  void _processPaymentSuccess(bool isIndo) {
    // 1. Simpan Tiket
    Provider.of<TicketProvider>(context, listen: false).addTicket(
      movieTitle: widget.movieTitle,
      cinemaName: widget.cinemaName,
      date: widget.date,
      time: widget.time,
      seats: widget.seats,
      posterPath: widget.posterPath,
    );

    // 2. [UPDATE UTAMA] Tambahkan Notifikasi ke Inbox Provider
    Provider.of<NotificationProvider>(context, listen: false).addNotification(
      type: "system",
      titleId: "Pembayaran Berhasil",
      titleEn: "Payment Successful",
      bodyId:
          "Pembayaran tiket ${widget.movieTitle} (${widget.seats.join(', ')}) berhasil.",
      bodyEn:
          "Payment for ${widget.movieTitle} (${widget.seats.join(', ')}) was successful.",
    );

    // 3. Tampilkan Dialog Sukses
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              Text(
                isIndo ? "Pembayaran Berhasil!" : "Payment Successful!",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isIndo
                    ? "Tiket kamu telah terbit. Silakan cek menu Tiket."
                    : "Your ticket has been issued. Please check the Ticket menu.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () {
                    _pinController.clear();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(initialIndex: 2),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(
                    isIndo ? "Lihat Tiket" : "View Ticket",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIndo =
        Provider.of<LanguageProvider>(context).currentLocale.languageCode ==
        'id';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          isIndo ? "Pembayaran" : "Payment",
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
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.movieTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${widget.date}, ${widget.time}",
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.cinemaName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(isIndo ? "Tempat Duduk" : "Seats"),
                            Text(
                              widget.seats.join(", "),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isIndo ? "METODE PEMBAYARAN" : "PAYMENT METHOD",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _buildPaymentMethod(
                          "DANA",
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Logo_dana_blue.svg/2560px-Logo_dana_blue.svg.png",
                        ),
                        const Divider(height: 1),
                        _buildPaymentMethod(
                          "ShopeePay",
                          "https://seeklogo.com/images/S/shopeepay-logo-2219BD1016-seeklogo.com.png",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isIndo ? "Total Bayar" : "Total Payment",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      "Rp ${widget.totalPrice}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                    onPressed: () => _showPinDialog(isIndo),
                    child: Text(
                      isIndo ? "BAYAR SEKARANG" : "PAY NOW",
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
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String name, String imgUrl) {
    return RadioListTile(
      value: name,
      groupValue: _selectedPayment,
      activeColor: AppColors.primary,
      onChanged: (val) => setState(() => _selectedPayment = val.toString()),
      title: Row(
        children: [
          Image.network(
            imgUrl,
            width: 40,
            height: 20,
            errorBuilder: (c, e, s) => const Icon(Icons.payment),
          ),
          const SizedBox(width: 10),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
