import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_style.dart';
import '../../providers/language_provider.dart';
import '../../providers/ticket_provider.dart';
import 'payment_page.dart';

class SeatSelectionPage extends StatefulWidget {
  final String movieTitle;
  final String cinemaName;
  final String time;
  final String date;
  final String posterPath; // [BARU] Variable untuk Poster

  const SeatSelectionPage({
    super.key,
    required this.movieTitle,
    required this.cinemaName,
    required this.time,
    required this.date,
    required this.posterPath, // [BARU] Wajib diisi
  });

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  final int _rowCount = 12;
  final int _colCountLeft = 8;
  final int _colCountRight = 8;
  late int _totalCols;

  late List<List<int>> _seatStatus;
  final int _ticketPrice = 35000;
  List<String> _selectedSeats = [];

  @override
  void initState() {
    super.initState();
    _totalCols = _colCountLeft + _colCountRight;
    _initializeSeats();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSoldSeats();
    });
  }

  void _initializeSeats() {
    _seatStatus = List.generate(
      _rowCount,
      (i) => List.generate(_totalCols, (j) => 0),
    );
  }

  void _loadSoldSeats() {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    List<String> soldSeats = ticketProvider.getSoldSeats(
      widget.movieTitle,
      widget.cinemaName,
      widget.date,
      widget.time,
    );

    setState(() {
      for (String seatCode in soldSeats) {
        try {
          int row = seatCode.codeUnitAt(0) - 65;
          int colNum = int.parse(seatCode.substring(1));
          int colIndex = colNum - 1;

          if (row >= 0 &&
              row < _rowCount &&
              colIndex >= 0 &&
              colIndex < _totalCols) {
            _seatStatus[row][colIndex] = 1;
          }
        } catch (e) {
          debugPrint("Error parsing seat: $seatCode");
        }
      }
    });
  }

  void _toggleSeat(int row, int col) {
    setState(() {
      if (row >= _seatStatus.length || col >= _seatStatus[row].length) return;

      if (_seatStatus[row][col] == 0) {
        _seatStatus[row][col] = 2;
        _selectedSeats.add("${String.fromCharCode(65 + row)}${col + 1}");
      } else if (_seatStatus[row][col] == 2) {
        _seatStatus[row][col] = 0;
        _selectedSeats.remove("${String.fromCharCode(65 + row)}${col + 1}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_seatStatus.length != _rowCount ||
        _seatStatus[0].length != _totalCols) {
      _initializeSeats();
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadSoldSeats());
    }

    final isIndo =
        Provider.of<LanguageProvider>(context).currentLocale.languageCode ==
        'id';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.cinemaName,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "${widget.date} | ${widget.time}",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // INFO BAR
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.red.shade300),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isIndo
                        ? "Anak usia 2 tahun ke atas wajib membeli tiket."
                        : "Children aged 2+ must buy a ticket.",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // LEGENDA
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                  AppColors.primary,
                  isIndo ? "Tersedia" : "Available",
                ),
                const SizedBox(width: 16),
                _buildLegendItem(
                  Colors.grey.shade300,
                  isIndo ? "Tidak Tersedia" : "Sold Out",
                ),
                const SizedBox(width: 16),
                _buildLegendItem(
                  Colors.blue,
                  isIndo ? "Pilihanmu" : "Selected",
                ),
              ],
            ),
          ),

          // AREA KURSI
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: [
                      ...List.generate(_rowCount, (rowIndex) {
                        String rowLabel = String.fromCharCode(65 + rowIndex);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 25,
                                child: Text(
                                  rowLabel,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              ...List.generate(
                                _colCountLeft,
                                (colIndex) => _buildSeat(rowIndex, colIndex),
                              ),
                              const SizedBox(width: 30),
                              ...List.generate(
                                _colCountRight,
                                (colIndex) => _buildSeat(
                                  rowIndex,
                                  colIndex + _colCountLeft,
                                ),
                              ),
                              SizedBox(
                                width: 25,
                                child: Text(
                                  rowLabel,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 30),
                      CustomPaint(
                        size: const Size(360, 40),
                        painter: ScreenPainter(),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        isIndo ? "LAYAR BIOSKOP" : "CINEMA SCREEN",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // BOTTOM BAR
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
                      isIndo ? "TOTAL HARGA" : "TOTAL PRICE",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isIndo ? "TEMPAT DUDUK" : "SEATS",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedSeats.isEmpty
                          ? "Rp -"
                          : "Rp ${(_selectedSeats.length * _ticketPrice).toString()}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      _selectedSeats.isEmpty ? "-" : _selectedSeats.join(", "),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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
                      backgroundColor: _selectedSeats.isEmpty
                          ? Colors.grey.shade300
                          : AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _selectedSeats.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                  movieTitle: widget.movieTitle,
                                  cinemaName: widget.cinemaName,
                                  time: widget.time,
                                  date: widget.date,
                                  seats: _selectedSeats,
                                  totalPrice:
                                      _selectedSeats.length * _ticketPrice,
                                  posterPath: widget
                                      .posterPath, // [PENTING] Kirim Poster ke Payment
                                ),
                              ),
                            );
                          },
                    child: Text(
                      isIndo ? "RINGKASAN ORDER" : "ORDER SUMMARY",
                      style: TextStyle(
                        color: _selectedSeats.isEmpty
                            ? Colors.grey
                            : Colors.white,
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

  Widget _buildSeat(int row, int col) {
    if (row >= _seatStatus.length || col >= _seatStatus[row].length)
      return const SizedBox(width: 30, height: 30);

    int status = _seatStatus[row][col];
    Color color;
    Color borderColor = Colors.transparent;

    if (status == 0) {
      color = Colors.white;
      borderColor = AppColors.primary;
    } else if (status == 1) {
      color = Colors.grey.shade300;
    } else {
      color = Colors.blue;
    }

    return GestureDetector(
      onTap: status == 1 ? null : () => _toggleSeat(row, col),
      child: Container(
        margin: const EdgeInsets.all(3),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: status == 0 ? Border.all(color: borderColor, width: 1) : null,
        ),
        child: status == 2
            ? Center(
                child: Text(
                  "${col + 1}",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color == AppColors.primary ? Colors.white : color,
            borderRadius: BorderRadius.circular(4),
            border: color == AppColors.primary
                ? Border.all(color: AppColors.primary)
                : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height);

    canvas.drawPath(path, paint);

    final glowPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
