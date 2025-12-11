import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// [UPDATE IMPORT] Mengarah ke folder providers & models yang baru
import '../../providers/language_provider.dart';
import '../../providers/movie_provider.dart'; // Ganti ViewModel jadi Provider
import '../../providers/notification_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/movie.dart';
import '../../theme/app_style.dart';

// [UPDATE IMPORT] Mengarah ke folder views yang sudah dirapikan
import '../detail/detailmovie.dart';
import 'listmovie.dart'; // Satu folder (home)
import '../profile/profile_page.dart';
import '../ticket/history.dart';
import 'city_selection_page.dart'; // Satu folder (home)
import 'cinema_page.dart'; // Satu folder (home)
import '../notification/notification_page.dart';
import '../auth/login_page.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePageContent(),
    const CinemaPage(),
    const TicketHistoryPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final isIndo =
        Provider.of<LanguageProvider>(context).currentLocale.languageCode ==
        'id';

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_filled),
            label: isIndo ? "Beranda" : "Home",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.location_city),
            label: isIndo ? "Bioskop" : "Cinema",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.confirmation_number_outlined),
            label: isIndo ? "Tiket" : "Tickets",
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  // [UPDATE] Gunakan MovieProvider
  final MovieProvider _movieProvider = MovieProvider();
  final TextEditingController _searchController = TextEditingController();

  Future<List<Movie>>? _moviesFuture;
  bool _isSearching = false;
  String _currentCity = "MALANG";
  String _lastLanguageCode = '';
  int _selectedFilterIndex = 0;
  final Set<int> _watchlist = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Provider.of<LanguageProvider>(
      context,
    ).currentLocale.languageCode;

    if (_lastLanguageCode != languageCode) {
      _lastLanguageCode = languageCode;
      _loadData();
    }
  }

  void _loadData() {
    setState(() {
      _moviesFuture = _movieProvider.fetchMovies(_lastLanguageCode);
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _loadData();
      });
    } else {
      setState(() {
        _isSearching = true;
        _moviesFuture = _movieProvider.searchMovies(query, _lastLanguageCode);
      });
    }
  }

  void _changeCity() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CitySelectionPage()),
    );
    if (result != null) setState(() => _currentCity = result);
  }

  List<Movie> _applyFilter(List<Movie> movies) {
    if (_selectedFilterIndex == 0) return movies;
    return movies.where((movie) {
      if (_selectedFilterIndex == 4) return _watchlist.contains(movie.id);
      if (_selectedFilterIndex == 1) return movie.id % 3 == 0;
      if (_selectedFilterIndex == 2) return movie.id % 3 == 1;
      if (_selectedFilterIndex == 3) return movie.id % 3 == 2;
      return true;
    }).toList();
  }

  void _toggleWatchlist(int movieId) {
    final isLoggedIn = Provider.of<UserProvider>(
      context,
      listen: false,
    ).isLoggedIn;
    if (!isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan login untuk menambahkan ke Watchlist"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    setState(() {
      if (_watchlist.contains(movieId)) {
        _watchlist.remove(movieId);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Dihapus dari Watchlist")));
      } else {
        _watchlist.add(movieId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ditambahkan ke Watchlist")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isIndo = _lastLanguageCode == 'id';
    final notifCount = Provider.of<NotificationProvider>(
      context,
    ).notificationCount;
    final isLoggedIn = Provider.of<UserProvider>(context).isLoggedIn;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _buildSearchBar(isIndo)),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.account_circle_outlined, size: 30),
                    color: Colors.black,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    ),
                  ),
                  if (isLoggedIn) ...[
                    const SizedBox(width: 15),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationPage(),
                            ),
                          ),
                          child: const Icon(
                            Icons.notifications_none_outlined,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        if (notifCount > 0)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "$notifCount",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (!_isSearching) _buildLocationBar(),
            Expanded(
              child: FutureBuilder<List<Movie>>(
                future: _moviesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(child: CircularProgressIndicator());
                  if (!snapshot.hasData || snapshot.data!.isEmpty)
                    return const Center(child: Text("No Data"));
                  final filteredMovies = _applyFilter(snapshot.data!);
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _isSearching
                                    ? (isIndo
                                          ? "Hasil Pencarian"
                                          : "Search Results")
                                    : (isIndo
                                          ? "Sedang Tayang"
                                          : "Now Playing"),
                                style: AppTextStyles.sectionHeader,
                              ),
                              if (!_isSearching)
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ListMoviePage(),
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isIndo ? "Semua >" : "See All >",
                                      style: TextStyle(
                                        color: Colors.orange.shade900,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (!_isSearching) ...[
                          const SizedBox(height: 10),
                          _buildCinemaFilters(isIndo),
                        ],
                        const SizedBox(height: 15),
                        if (!_isSearching && filteredMovies.isNotEmpty)
                          SizedBox(
                            height: 320,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: filteredMovies.length > 5
                                  ? 5
                                  : filteredMovies.length,
                              itemBuilder: (context, index) =>
                                  _buildHorizontalMovieCard(
                                    context,
                                    filteredMovies[index],
                                  ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        if (!_isSearching && filteredMovies.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                isIndo ? "Film Lainnya" : "More Movies",
                                style: AppTextStyles.sectionHeader,
                              ),
                            ),
                          ),
                        if (filteredMovies.isNotEmpty)
                          GridView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _isSearching
                                ? filteredMovies.length
                                : (filteredMovies.length > 5
                                      ? filteredMovies.length - 5
                                      : 0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.62,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                            itemBuilder: (context, index) {
                              final movieIndex = _isSearching
                                  ? index
                                  : index + 5;
                              if (movieIndex < filteredMovies.length)
                                return _buildMovieCard(
                                  context,
                                  filteredMovies[movieIndex],
                                );
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

  // (Helper widgets seperti _buildSearchBar, _buildLocationBar dll, copy dari kode sebelumnya, hanya perbaiki impornya)
  Widget _buildSearchBar(bool isIndo) => Container(
    height: 45,
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(25),
    ),
    child: TextField(
      controller: _searchController,
      onSubmitted: _performSearch,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: isIndo ? "Cari di CinemaTix" : "Search in CinemaTix",
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
  Widget _buildLocationBar() => GestureDetector(
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
  Widget _buildCinemaFilters(bool isIndo) {
    final cinemas = [
      isIndo ? "Semua Film" : "All Movies",
      "XXI",
      "CGV",
      "Cinépolis",
      "Watchlist",
    ];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cinemas.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(20),
                color: isSelected ? AppColors.primary : Colors.white,
              ),
              child: Center(
                child: Text(
                  cinemas[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalMovieCard(BuildContext context, Movie movie) {
    final isLoved = _watchlist.contains(movie.id);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailMoviePage(movie: movie)),
      ),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    movie.posterPath,
                    height: 240,
                    width: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _toggleWatchlist(movie.id),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLoved ? Icons.favorite : Icons.favorite_border,
                        color: isLoved ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.movieTitle.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieCard(BuildContext context, Movie movie) {
    final isLoved = _watchlist.contains(movie.id);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailMoviePage(movie: movie)),
      ),
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
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      child: Image.network(
                        movie.posterPath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _toggleWatchlist(movie.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isLoved ? Icons.favorite : Icons.favorite_border,
                          color: isLoved ? Colors.red : Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
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
