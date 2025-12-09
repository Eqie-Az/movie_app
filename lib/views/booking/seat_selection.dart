import 'package:flutter/material.dart';
import '../../theme/app_style.dart';

class SeatSelectionPage extends StatefulWidget {
  final String movieTitle;
  const SeatSelectionPage({super.key, required this.movieTitle});

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  // 0: Available, 1: Occupied, 2: Selected
  List<int> seatStatus = [
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    1,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    2,
    0,
    0,
    0,
    0,
    1,
    1,
    0,
    0,
    1,
    1,
  ];

  @override
  Widget build(BuildContext context) {
    int selectedCount = seatStatus.where((s) => s == 2).length;
    int price = selectedCount * 45000;

    return Scaffold(
      backgroundColor: AppColors.primary, // Latar bioskop gelap
      appBar: AppBar(
        title: Text(
          widget.movieTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Layar Putih
          Container(
            height: 40,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.3), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: const Border(
                top: BorderSide(color: Colors.white, width: 4),
              ),
            ),
            child: const Center(
              child: Text("LAYAR", style: TextStyle(color: Colors.white54)),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: GridView.builder(
                itemCount: seatStatus.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (seatStatus[index] == 1) {
                        return; // Kalau terisi jangan diapa-apain
                      }
                      setState(() {
                        seatStatus[index] = seatStatus[index] == 0 ? 2 : 0;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: seatStatus[index] == 1
                            ? AppColors.seatOccupied
                            : seatStatus[index] == 2
                            ? AppColors.seatSelected
                            : AppColors.seatAvailable,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Bottom Payment Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Harga", style: AppTextStyles.bodyText),
                    Text("Rp $price", style: AppTextStyles.price),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: selectedCount > 0 ? () {} : null,
                    child: Text(
                      "BAYAR SEKARANG",
                      style: AppTextStyles.buttonText,
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
}
