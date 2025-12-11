import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_style.dart';
import '../../providers/language_provider.dart';
import 'city_selection_page.dart';
import '../detail/cinema_detail_page.dart';

class CinemaPage extends StatefulWidget {
  const CinemaPage({super.key});

  @override
  State<CinemaPage> createState() => _CinemaPageState();
}

class _CinemaPageState extends State<CinemaPage> {
  String _currentCity = "MALANG";
  bool _isBannerVisible = true;

  // List yang akan ditampilkan di UI
  List<Map<String, dynamic>> _displayCinemas = [];

  @override
  void initState() {
    super.initState();
    // Load data awal
    _updateCinemaList(_currentCity);
  }

  // --- DATABASE BIOSKOP (DATA LENGKAP) ---
  final Map<String, List<Map<String, dynamic>>> _allCinemasData = {
    "MALANG": [
      {
        "name": "ARAYA XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Plaza Araya Lt. 2",
        "phone": "(0341) 408201",
      },
      {
        "name": "DIENG 21",
        "type": "XXI",
        "isFavorite": false,
        "address": "Cyber Mall Lt. 3",
        "phone": "(0341) 570888",
      },
      {
        "name": "LIPPO PLAZA BATU CINEPOLIS",
        "type": "Cinepolis",
        "isFavorite": false,
        "address": "Lippo Plaza Batu",
        "phone": "(0341) 2991234",
      },
      {
        "name": "MALANG CITY POINT CGV",
        "type": "CGV",
        "isFavorite": false,
        "address": "Malang City Point",
        "phone": "(0341) 5022888",
      },
      {
        "name": "MALANG TOWN SQUARE CINEPOLIS",
        "type": "Cinepolis",
        "isFavorite": false,
        "address": "Matos",
        "phone": "(0341) 559977",
      },
      {
        "name": "MANDALA",
        "type": "XXI",
        "isFavorite": false,
        "address": "Plaza Malang Lt. 3",
        "phone": "(0341) 366666",
      },
      {
        "name": "TRANSMART MX MALL XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "MX Mall Lt. 5",
        "phone": "(0341) 550000",
      },
      {
        "name": "MOVIMAX DINOYO",
        "type": "Movimax",
        "isFavorite": false,
        "address": "Mall Dinoyo City Lt. 4",
        "phone": "(0341) 5088999",
      },
    ],
    "SURABAYA": [
      {
        "name": "TUNJUNGAN 5 XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Tunjungan Plaza 5",
        "phone": "(031) 51164221",
      },
      {
        "name": "PAKUWON MALL CGV",
        "type": "CGV",
        "isFavorite": false,
        "address": "Pakuwon Mall",
        "phone": "(031) 7390888",
      },
      {
        "name": "CIPUTRA WORLD XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Ciputra World",
        "phone": "(031) 51200021",
      },
      {
        "name": "MARVELL CITY CGV",
        "type": "CGV",
        "isFavorite": false,
        "address": "Marvell City",
        "phone": "(031) 99005668",
      },
      {
        "name": "GALAXY XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Galaxy Mall",
        "phone": "(031) 5937121",
      },
    ],
    "JAKARTA": [
      {
        "name": "PLAZA INDONESIA XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Plaza Indonesia",
        "phone": "(021) 39838779",
      },
      {
        "name": "GRAND INDONESIA CGV",
        "type": "CGV",
        "isFavorite": false,
        "address": "Grand Indonesia",
        "phone": "(021) 23580484",
      },
      {
        "name": "GANDARIA CITY XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Gandaria City",
        "phone": "(021) 29053218",
      },
      {
        "name": "KOTA KASABLANKA XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Kota Kasablanka",
        "phone": "(021) 29465221",
      },
      {
        "name": "SENAYAN CITY XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Senayan City",
        "phone": "(021) 72781324",
      },
    ],
    "BANDUNG": [
      {
        "name": "CIWALK XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Cihampelas Walk",
        "phone": "(022) 2061017",
      },
      {
        "name": "PARIS VAN JAVA CGV",
        "type": "CGV",
        "isFavorite": false,
        "address": "PVJ Mall",
        "phone": "(022) 82063630",
      },
      {
        "name": "TRANS STUDIO MALL XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "TSM Bandung",
        "phone": "(022) 86012557",
      },
    ],
    "YOGYAKARTA": [
      {
        "name": "AMBARRUKMO XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Plaza Ambarrukmo",
        "phone": "(0274) 4331221",
      },
      {
        "name": "JWALK CGV",
        "type": "CGV",
        "isFavorite": false,
        "address": "Sahid J-Walk",
        "phone": "(0274) 2800888",
      },
      {
        "name": "EMPIRE XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Jl. Urip Sumoharjo",
        "phone": "(0274) 551021",
      },
    ],
    "BALI": [
      {
        "name": "BEACHWALK XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Beachwalk Bali",
        "phone": "(0361) 8465621",
      },
      {
        "name": "TRANS STUDIO BALI XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Trans Studio Mall Bali",
        "phone": "(0361) 6207021",
      },
      {
        "name": "GALERIA XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Mal Bali Galeria",
        "phone": "(0361) 767021",
      },
    ],
    "MEDAN": [
      {
        "name": "CENTRE POINT XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Centre Point Mall",
        "phone": "(061) 80510521",
      },
      {
        "name": "SUN PLAZA CINEPOLIS",
        "type": "Cinepolis",
        "isFavorite": false,
        "address": "Sun Plaza",
        "phone": "(061) 4501000",
      },
      {
        "name": "HERMES XXI",
        "type": "XXI",
        "isFavorite": false,
        "address": "Hermes Place",
        "phone": "(061) 4556821",
      },
    ],
  };

  void _updateCinemaList(String city) {
    setState(() {
      _displayCinemas = _allCinemasData[city.toUpperCase()] ?? [];
    });
  }

  void _changeCity() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CitySelectionPage()),
    );
    if (result != null) {
      setState(() {
        _currentCity = result;
      });
      _updateCinemaList(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil Status Bahasa
    final isIndo =
        Provider.of<LanguageProvider>(context).currentLocale.languageCode ==
        'id';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. SEARCH BAR (TANPA ICON USER DI DALAMNYA)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    // [TERJEMAHAN]
                    hintText: isIndo
                        ? "Cari di CinemaTix"
                        : "Search in CinemaTix",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    // [FIX] Suffix Icon dihapus agar bersih
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),

            const Divider(height: 1),

            // 2. LOCATION BAR
            GestureDetector(
              onTap: _changeCity,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                color: const Color(0xFFF5F5F5),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _currentCity,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ],
                ),
              ),
            ),

            // 3. BANNER INFO
            AnimatedCrossFade(
              firstChild: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.location_city,
                            size: 30,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // [TERJEMAHAN]
                              Text(
                                isIndo
                                    ? "Tandai bioskop favoritmu!"
                                    : "Mark your favorite cinema!",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isIndo
                                    ? "Bioskop favoritmu akan berada paling atas pada daftar ini."
                                    : "Your favorite cinemas will appear at the top of this list.",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 10),
                              OutlinedButton(
                                onPressed: () =>
                                    setState(() => _isBannerVisible = false),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                                child: Text(
                                  isIndo ? "Mengerti" : "Got it",
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1, height: 1),
                ],
              ),
              secondChild: const SizedBox.shrink(),
              crossFadeState: _isBannerVisible
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 400),
              sizeCurve: Curves.easeInOut,
            ),

            // 4. LIST BIOSKOP
            Expanded(
              child: _displayCinemas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_off,
                            size: 60,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          // [TERJEMAHAN]
                          Text(
                            isIndo
                                ? "Belum ada data bioskop di $_currentCity"
                                : "No cinema data in $_currentCity",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _displayCinemas.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final cinema = _displayCinemas[index];
                        return ListTile(
                          leading: Icon(
                            cinema['isFavorite']
                                ? Icons.star
                                : Icons.star_border,
                            color: cinema['isFavorite']
                                ? Colors.amber
                                : Colors.grey,
                          ),
                          title: Text(
                            cinema['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CinemaDetailPage(cinemaData: cinema),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
