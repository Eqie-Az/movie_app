import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/movie.dart';
import '../../theme/app_style.dart';
import '../../viewmodel/movie_viewmodel.dart';
import '../../viewmodel/language_provider.dart';
import '../../viewmodel/user_provider.dart';
import '../booking/seat_selection.dart';
import '../auth/login_page.dart';

class DetailMoviePage extends StatefulWidget {
  final Movie movie;

  const DetailMoviePage({super.key, required this.movie});

  @override
  State<DetailMoviePage> createState() => _DetailMoviePageState();
}

class _DetailMoviePageState extends State<DetailMoviePage>
    with SingleTickerProviderStateMixin {
  final MovieViewModel viewModel = MovieViewModel();
  late TabController _tabController;

  String _genreText = "";
  String _durationText = "-";
  String? _trailerKey;

  List<Map<String, String>> _castList = [];
  bool _isDataLoaded = false;

  int _selectedDateIndex = 0;
  List<Map<String, dynamic>> _dateList = [];
  bool _isWatchlisted = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateDates();
      _loadDetailData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateDates() {
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> tempDates = [];

    final isIndo =
        Provider.of<LanguageProvider>(
          context,
          listen: false,
        ).currentLocale.languageCode ==
        'id';

    List<String> months = isIndo
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

    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      String dayName = i == 0
          ? (isIndo ? "HARI INI" : "TODAY")
          : _getDayName(date.weekday, isIndo);

      tempDates.add({
        "label": "${date.day} ${months[date.month - 1]}\n$dayName",
        "dateObj": date,
        "enabled": true,
      });
    }
    setState(() {
      _dateList = tempDates;
    });
  }

  String _getDayName(int day, bool isIndo) {
    if (isIndo) {
      switch (day) {
        case 1:
          return "SEN";
        case 2:
          return "SEL";
        case 3:
          return "RAB";
        case 4:
          return "KAM";
        case 5:
          return "JUM";
        case 6:
          return "SAB";
        case 7:
          return "MIN";
        default:
          return "";
      }
    } else {
      switch (day) {
        case 1:
          return "MON";
        case 2:
          return "TUE";
        case 3:
          return "WED";
        case 4:
          return "THU";
        case 5:
          return "FRI";
        case 6:
          return "SAT";
        case 7:
          return "SUN";
        default:
          return "";
      }
    }
  }

  void _loadDetailData() async {
    final languageCode = Provider.of<LanguageProvider>(
      context,
      listen: false,
    ).currentLocale.languageCode;
    final isIndo = languageCode == 'id';

    setState(() {
      _genreText = isIndo ? "⏳ Memuat..." : "⏳ Loading...";
      _isDataLoaded = false;
    });

    try {
      final data = await viewModel.fetchMovieDetailExtras(
        widget.movie.id,
        languageCode,
      );
      if (!mounted) return;

      setState(() {
        _genreText = (data['genres'] == null || data['genres'].isEmpty)
            ? (isIndo ? "Tidak tersedia" : "Not available")
            : data['genres'];
        _durationText = data['duration'] ?? "-";
        _trailerKey = data['trailer'];
        _castList = (data['cast'] as List)
            .map((item) => Map<String, String>.from(item))
            .toList();
        _isDataLoaded = true;
      });
    } catch (e) {
      setState(() => _isDataLoaded = true);
    }
  }

  void _checkLoginAndAction(
    String actionName, {
    String? cinemaName,
    String? time,
  }) {
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
      if (cinemaName != null && time != null) {
        DateTime selectedDate = _dateList[_selectedDateIndex]['dateObj'];

        List<String> monthsFull = isIndo
            ? [
                "Januari",
                "Februari",
                "Maret",
                "April",
                "Mei",
                "Juni",
                "Juli",
                "Agustus",
                "September",
                "Oktober",
                "November",
                "Desember",
              ]
            : [
                "January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December",
              ];

        String dayNameFull = isIndo
            ? [
                "Senin",
                "Selasa",
                "Rabu",
                "Kamis",
                "Jumat",
                "Sabtu",
                "Minggu",
              ][selectedDate.weekday - 1]
            : [
                "Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday",
                "Saturday",
                "Sunday",
              ][selectedDate.weekday - 1];

        String formattedDate =
            "$dayNameFull, ${selectedDate.day} ${monthsFull[selectedDate.month - 1]} ${selectedDate.year}";

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeatSelectionPage(
              movieTitle: widget.movie.title,
              cinemaName: cinemaName,
              time: time,
              date: formattedDate,
              posterPath: widget.movie.posterPath,
            ),
          ),
        );
      } else if (actionName == "watchlist") {
        setState(() => _isWatchlisted = !_isWatchlisted);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isIndo
                  ? (_isWatchlisted
                        ? "Ditambahkan ke Watchlist"
                        : "Dihapus dari Watchlist")
                  : (_isWatchlisted
                        ? "Added to Watchlist"
                        : "Removed from Watchlist"),
            ),
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

    if (_dateList.isEmpty) _generateDates();

    String buttonText;
    VoidCallback? buttonAction;

    if (_tabController.index == 0) {
      buttonText = isIndo ? "YUK NONTON FILMNYA" : "GET TICKETS";
      buttonAction = () => _tabController.animateTo(1);
    } else {
      buttonText = isIndo ? "PILIH JADWAL DI ATAS" : "CHOOSE SCHEDULE ABOVE";
      buttonAction = () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isIndo
                  ? "Silakan klik salah satu jam tayang di atas"
                  : "Please click a showtime above",
            ),
          ),
        );
      };
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _buildVideoHeader(),
                      _buildMovieInfo(isIndo),
                      const SizedBox(height: 5),
                      _buildRatingAndWatchlist(isIndo),
                      const SizedBox(height: 15),
                    ]),
                  ),
                ];
              },
              body: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 3,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      tabs: [
                        Tab(text: isIndo ? "SINOPSIS" : "SYNOPSIS"),
                        Tab(text: isIndo ? "JADWAL" : "SCHEDULE"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildSynopsisTab(isIndo),
                        _buildScheduleTab(isIndo),
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
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: buttonAction,
                child: Text(
                  buttonText,
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

  // --- WIDGETS ---

  Widget _buildVideoHeader() {
    return Stack(
      children: [
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            image: _trailerKey != null
                ? DecorationImage(
                    image: NetworkImage(
                      "https://img.youtube.com/vi/$_trailerKey/mqdefault.jpg",
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.6,
                  )
                : null,
          ),
          child: _trailerKey == null
              ? const Center(
                  child: Icon(Icons.movie, size: 50, color: Colors.grey),
                )
              : null,
        ),
        if (_trailerKey != null)
          Positioned.fill(
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse(
                    "https://www.youtube.com/watch?v=$_trailerKey",
                  );
                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  ))
                    debugPrint("Gagal buka trailer");
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          top: 40,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieInfo(bool isIndo) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.movie.posterPath,
              width: 100,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) =>
                  Container(color: Colors.grey, width: 100, height: 150),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movie.title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                _buildMetaRow("Genre", _genreText),
                _buildMetaRow(isIndo ? "Durasi" : "Duration", _durationText),
                _buildMetaRow(isIndo ? "Sutradara" : "Director", "TBA"),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey.shade100,
                  ),
                  child: const Text(
                    "R 13+",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
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

  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingAndWatchlist(bool isIndo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "${widget.movie.voteAverage}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  "CinemaTix Score",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _checkLoginAndAction("watchlist"),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isWatchlisted
                    ? Colors.red.shade50
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _isWatchlisted ? Icons.favorite : Icons.favorite_border,
                        color: _isWatchlisted ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isIndo ? "Watchlist" : "Watchlist",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _isWatchlisted ? Colors.red : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isIndo ? "49.514 Orang" : "49.514 People",
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSynopsisTab(bool isIndo) {
    // [UPDATE LOGIKA SINOPSIS]
    String synopsisContent = widget.movie.overview;

    // Cek jika sinopsis kosong
    if (synopsisContent.isEmpty) {
      synopsisContent = isIndo
          ? "Sinopsis dalam Bahasa Indonesia tidak tersedia."
          : "Synopsis not available.";
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            synopsisContent, // Gunakan teks yang sudah dicek
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: widget.movie.overview.isEmpty
                  ? Colors.grey
                  : Colors.black87, // Warna abu jika kosong
              fontStyle: widget.movie.overview.isEmpty
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
          ),
          const SizedBox(height: 20),
          Text(isIndo ? "Pemeran" : "Cast", style: AppTextStyles.heading2),
          const SizedBox(height: 10),
          if (!_isDataLoaded)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                isIndo ? "⏳ Memuat..." : "⏳ Loading...",
                style: const TextStyle(color: Colors.grey),
              ),
            )
          else if (_castList.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                isIndo ? "Tidak tersedia" : "Not available",
                style: const TextStyle(color: Colors.grey),
              ),
            )
          else
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _castList.length,
                itemBuilder: (ctx, idx) => _buildCastItem(_castList[idx]),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCastItem(Map<String, String> cast) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
              image: cast['image']!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(cast['image']!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: cast['image']!.isEmpty
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            cast['name']!,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            cast['role']!,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTab(bool isIndo) {
    final List<Map<String, dynamic>> cinemas = [
      {"name": "ARAYA XXI", "type": "XXI", "price": "Rp35.000"},
      {"name": "DIENG 21", "type": "XXI", "price": "Rp30.000"},
      {"name": "MALANG CITY POINT CGV", "type": "CGV", "price": "Rp40.000"},
      {
        "name": "LIPPO PLAZA BATU CINEPOLIS",
        "type": "Cinepolis",
        "price": "Rp35.000",
      },
    ];

    return Column(
      children: [
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 16),
          color: Colors.white,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _dateList.length,
            itemBuilder: (context, index) {
              final dateInfo = _dateList[index];
              bool isSelected = index == _selectedDateIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedDateIndex = index),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 70,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      dateInfo['label'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: cinemas.length,
            itemBuilder: (context, index) {
              final cinema = cinemas[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_border, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cinema['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            cinema['type'],
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "2D   ${cinema['price']}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: ["12:00", "14:20", "16:40", "19:00", "21:20"]
                          .map((time) {
                            return GestureDetector(
                              onTap: () => _checkLoginAndAction(
                                "membeli tiket",
                                cinemaName: cinema['name'],
                                time: time,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black87),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  time,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
