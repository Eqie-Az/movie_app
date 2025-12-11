import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_style.dart';
import '../auth/login_page.dart';
import '../../providers/movie_provider.dart'; // Import Provider
import '../../providers/language_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/movie.dart';
import 'detailmovie.dart';
import '../booking/seat_selection.dart';

class CinemaDetailPage extends StatefulWidget {
  final Map<String, dynamic> cinemaData;

  const CinemaDetailPage({super.key, required this.cinemaData});

  @override
  State<CinemaDetailPage> createState() => _CinemaDetailPageState();
}

class _CinemaDetailPageState extends State<CinemaDetailPage> {
  final MovieProvider _movieProvider = MovieProvider();

  int _selectedDateIndex = 0;
  Map<String, dynamic>? _selectedTicket;

  // Data dari Provider
  Future<List<Movie>>? _moviesFuture;
  List<Map<String, dynamic>> _dateList = [];
  List<String> _showTimes = [];

  String _lastLanguageCode = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Provider.of<LanguageProvider>(
      context,
    ).currentLocale.languageCode;

    if (_lastLanguageCode != languageCode) {
      _lastLanguageCode = languageCode;
      final isIndo = languageCode == 'id';

      // [UPDATE] Ambil logika bisnis dari Provider
      _moviesFuture = _movieProvider.fetchMovies(languageCode);
      _dateList = _movieProvider.generateDateList(isIndo);
      _showTimes = _movieProvider.getShowTimes();
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
        DateTime selectedDateObj = _dateList[_selectedDateIndex]['dateObj'];
        // [UPDATE] Format tanggal pakai logika Provider
        String finalDateString = _movieProvider.formatDate(
          selectedDateObj,
          isIndo,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeatSelectionPage(
              movieTitle: _selectedTicket!['title'],
              cinemaName: widget.cinemaData['name'],
              time: _selectedTicket!['time'],
              date: finalDateString,
              posterPath: _selectedTicket!['posterPath'],
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

    // Pastikan dateList terisi jika pertama kali load
    if (_dateList.isEmpty) {
      _dateList = _movieProvider.generateDateList(isIndo);
      _showTimes = _movieProvider.getShowTimes();
    }

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
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.cinemaData['address'] ?? "-",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.cinemaData['phone'] ?? "-",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1, height: 1),

                  // JADWAL TANGGAL (Data dari Provider)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _dateList.length,
                        itemBuilder: (context, index) {
                          bool isSelected = index == _selectedDateIndex;
                          final dateItem = _dateList[index];

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
                                  dateItem['label'],
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            isIndo ? "Tidak ada jadwal" : "No schedule",
                          ),
                        );
                      }

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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isTicketSelected
                      ? AppColors.primary
                      : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                    fontSize: 16,
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
    return Column(
      children: [
        // INFO FILM
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailMoviePage(movie: movie),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie.posterPath,
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        Container(width: 80, height: 120, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isIndo ? "Inggris/Indonesia" : "English/Indonesian",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "${movie.voteAverage}/10",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
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
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // JADWAL JAM (Data diambil dari Provider -> _showTimes)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "2D",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    "Rp35.000",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _showTimes.map((time) {
                  bool isSelected =
                      _selectedTicket != null &&
                      _selectedTicket!['movieId'] == movie.id &&
                      _selectedTicket!['time'] == time;
                  return GestureDetector(
                    onTap: () => setState(() {
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
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
