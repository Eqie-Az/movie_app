import 'package:flutter/material.dart';
import '../viewmodel/movie_viewmodel.dart';
import '../model/movie.dart';
import '../theme/app_style.dart';
import 'detailmovie.dart';
import 'listmovie.dart';
import 'profile_page.dart';
import '../views/ticket/history.dart';
import 'city_selection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePageContent(),
    const ListMoviePage(),
    const TicketHistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation_outlined),
            label: "Bioskop",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_outlined),
            label: "Tiket",
          ),
        ],
      ),
    );
  }
}

// === KONTEN BERANDA (HOME) ===
class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final MovieViewModel viewModel = MovieViewModel();

  final TextEditingController _searchController = TextEditingController();
  late Future<List<Movie>> _moviesFuture;
  bool _isSearching = false;
  String _currentCity = "JAKARTA";

  @override
  void initState() {
    super.initState();
    _moviesFuture = viewModel.fetchMovies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _moviesFuture = viewModel.fetchMovies();
      });
    } else {
      setState(() {
        _isSearching = true;
        _moviesFuture = viewModel.searchMovies(query);
      });
    }
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 1. HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _buildSearchBar()),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.account_circle_outlined, size: 35),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // 2. LOKASI
            if (!_isSearching) _buildLocationBar(),

            // 3. KONTEN SCROLL
            Expanded(
              child: FutureBuilder<List<Movie>>(
                future: _moviesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Gagal memuat: ${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Film tidak ditemukan."));
                  }

                  final movies = snapshot.data!;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        // HEADER SECTION "Sedang Tayang"
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _isSearching
                                    ? "Hasil Pencarian"
                                    : "Sedang Tayang",
                                style: AppTextStyles.sectionHeader,
                              ),
                              if (!_isSearching)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "Semua >",
                                    style: TextStyle(
                                      color: Colors.orange.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // FILTER BIOSKOP
                        if (!_isSearching) ...[
                          const SizedBox(height: 10),
                          _buildCinemaFilters(),
                        ],

                        const SizedBox(height: 15),

                        // --- BAGIAN BARU: LIST HORIZONTAL (GESER KIRI/KANAN) ---
                        // Hanya tampil jika TIDAK sedang searching
                        if (!_isSearching)
                          SizedBox(
                            height: 320, // Tinggi area scroll
                            child: ListView.builder(
                              scrollDirection:
                                  Axis.horizontal, // Scroll mendatar
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: movies.length > 5
                                  ? 5
                                  : movies.length, // Ambil 5 film teratas
                              itemBuilder: (context, index) {
                                return _buildHorizontalMovieCard(
                                  context,
                                  movies[index],
                                );
                              },
                            ),
                          ),

                        // -------------------------------------------------------
                        const SizedBox(height: 20),

                        // LIST FILM LAINNYA (Grid di Bawah)
                        if (!_isSearching)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Akan Datang",
                              style: AppTextStyles.sectionHeader,
                            ),
                          ),

                        GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          // Jika tidak searching, skip 5 film pertama karena sudah ada di atas
                          itemCount: _isSearching
                              ? movies.length
                              : (movies.length > 5 ? movies.length - 5 : 0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.62,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemBuilder: (context, index) {
                            // Sesuaikan index
                            final movieIndex = _isSearching ? index : index + 5;
                            if (movieIndex < movies.length) {
                              return _buildMovieCard(
                                context,
                                movies[movieIndex],
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildSearchBar() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: (value) => _performSearch(value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Cari di TIX ID",
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch("");
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildLocationBar() {
    return GestureDetector(
      onTap: _changeCity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.grey, size: 20),
            const SizedBox(width: 8),
            Text(
              _currentCity,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCinemaFilters() {
    final cinemas = ["Semua Film", "XXI", "CGV", "Cinépolis", "Watchlist"];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cinemas.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(20),
              color: index == 0 ? AppColors.primary : Colors.white,
            ),
            child: Center(
              child: Text(
                cinemas[index],
                style: TextStyle(
                  color: index == 0 ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // KARTU FILM HORIZONTAL (BESAR)
  Widget _buildHorizontalMovieCard(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailMoviePage(movie: movie),
          ),
        );
      },
      child: Container(
        width: 160, // Lebar kartu
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                movie.posterPath,
                height: 240, // Tinggi Poster
                width: 160,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            // Judul
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.movieTitle.copyWith(
                fontSize: 16,
              ), // Font lebih besar
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // KARTU FILM VERTICAL (KECIL)
  Widget _buildMovieCard(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailMoviePage(movie: movie),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.movieTitle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
