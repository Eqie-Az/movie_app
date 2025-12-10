import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_style.dart';
import 'login_page.dart';
import '../viewmodel/movie_viewmodel.dart';
import '../viewmodel/language_provider.dart';
import '../viewmodel/user_provider.dart';
import '../model/movie.dart';
import 'detailmovie.dart';
import 'booking/seat_selection.dart';

class CinemaDetailPage extends StatefulWidget {
  final Map<String, dynamic> cinemaData;

  const CinemaDetailPage({super.key, required this.cinemaData});

  @override
  State<CinemaDetailPage> createState() => _CinemaDetailPageState();
}

class _CinemaDetailPageState extends State<CinemaDetailPage> {
  int _selectedDateIndex = 0;

  // Variabel untuk menyimpan tiket yang dipilih (termasuk posterPath)
  Map<String, dynamic>? _selectedTicket;

  final MovieViewModel _movieViewModel = MovieViewModel();
  Future<List<Movie>>? _moviesFuture;
  String _lastLanguageCode = '';

  // --- Helper Tanggal Dinamis ---
  DateTime _getDateByIndex(int index) {
    return DateTime.now().add(Duration(days: index));
  }

  String _formatDate(DateTime date, bool isIndo) {
    List<String> monthsIndo = [
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
    ];
    List<String> monthsEng = [
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

    String day = date.day.toString();
    String month = isIndo
        ? monthsIndo[date.month - 1]
        : monthsEng[date.month - 1];
    String year = date.year.toString();

    return "$day $month $year";
  }

  String _getDayName(DateTime date, bool isIndo) {
    List<String> daysIndo = [
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
      "Minggu",
    ];
    List<String> daysEng = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return isIndo ? daysIndo[date.weekday - 1] : daysEng[date.weekday - 1];
  }
  // -----------------------------

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Provider.of<LanguageProvider>(
      context,
    ).currentLocale.languageCode;
    if (_lastLanguageCode != languageCode) {
      _lastLanguageCode = languageCode;
      _moviesFuture = _movieViewModel.fetchMovies(languageCode);
    }
  }

  void _checkLoginAndAction(String actionName) {
    final isLoggedIn = Provider.of<UserProvider>(
      context,
      listen: false,
    ).isLoggedIn;
    final isIndo =
        Provider.of<LanguageProvider>(
          context,
          listen: false,
        ).currentLocale.languageCode ==
        'id';

    if (!isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isIndo
                ? "Silakan login untuk $actionName"
                : "Please login to $actionName",
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      if (_selectedTicket != null) {
        // Generate tanggal lengkap untuk dikirim
        DateTime selectedDateObj = _getDateByIndex(_selectedDateIndex);
        String dayName = _getDayName(selectedDateObj, isIndo);
        String fullDate = _formatDate(selectedDateObj, isIndo);
        String finalDateString = "$dayName, $fullDate";

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeatSelectionPage(
              movieTitle: _selectedTicket!['title'],
              cinemaName: widget.cinemaData['name'],
              time: _selectedTicket!['time'],
              date: finalDateString,
              posterPath:
                  _selectedTicket!['posterPath'], // [PENTING] Kirim URL Poster
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isIndo
                  ? "Silakan pilih jadwal film dulu"
                  : "Please select a showtime first",
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIndo =
        Provider.of<LanguageProvider>(context).currentLocale.languageCode ==
        'id';
    bool isTicketSelected = _selectedTicket != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.cinemaData['name'],
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MAP HEADER
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Image.network(
                          "https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/pass/GoogleMapTA.jpg",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                          errorBuilder: (c, e, s) =>
                              Container(color: Colors.grey.shade300),
                        ),
                        const Center(
                          child: Icon(
                            Icons.location_on,
                            size: 50,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // INFO BIOSKOP
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _checkLoginAndAction(
                            isIndo ? "menambah favorit" : "add to favorites",
                          ),
                          icon: const Icon(
                            Icons.star_border,
                            color: AppColors.primary,
                          ),
                          label: Text(
                            isIndo ? "FAVORIT" : "FAVORITE",
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.cinemaData['address'] ?? "-",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.cinemaData['phone'] ?? "-",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1, height: 1),

                  // JADWAL TANGGAL (REAL TIME)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          bool isSelected = index == _selectedDateIndex;
                          DateTime date = _getDateByIndex(index);

                          String dayNum = date.day.toString();
                          List<String> monthsShort = isIndo
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
                          String monthName = monthsShort[date.month - 1];
                          String dayName = index == 0
                              ? (isIndo ? "HARI INI" : "TODAY")
                              : _getDayName(
                                  date,
                                  isIndo,
                                ).toUpperCase().substring(0, 3);

                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedDateIndex = index),
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 70,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "$dayNum $monthName\n$dayName",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Divider(thickness: 1, height: 1),

                  // LIST FILM
                  FutureBuilder<List<Movie>>(
                    future: _moviesFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const Center(child: CircularProgressIndicator());
                      final movies = snapshot.data!;
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: movies.length,
                        separatorBuilder: (context, index) =>
                            const Divider(thickness: 1, height: 30),
                        itemBuilder: (context, index) =>
                            _buildMovieItem(movies[index], isIndo),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // TOMBOL BELI TIKET
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isTicketSelected
                      ? AppColors.primary
                      : Colors.grey.shade300,
                ),
                onPressed: isTicketSelected
                    ? () => _checkLoginAndAction(
                        isIndo ? "membeli tiket" : "buying ticket",
                      )
                    : null,
                child: Text(
                  isIndo ? "BELI TIKET" : "BUY TICKET",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieItem(Movie movie, bool isIndo) {
    final List<String> showTimes = ["12:05", "14:20", "16:35", "19:00"];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Image.network(
                movie.posterPath,
                width: 80,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    Container(width: 80, height: 120, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      isIndo ? "Inggris/Indonesia" : "English/Indonesian",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "R 13+",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 10,
            children: showTimes.map((time) {
              bool isSelected =
                  _selectedTicket != null &&
                  _selectedTicket!['movieId'] == movie.id &&
                  _selectedTicket!['time'] == time;
              return GestureDetector(
                onTap: () => setState(() {
                  // [PENTING] Simpan URL Poster di sini
                  _selectedTicket = {
                    'movieId': movie.id,
                    'title': movie.title,
                    'time': time,
                    'posterPath': movie.posterPath,
                  };
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
