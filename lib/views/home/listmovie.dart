import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/language_provider.dart';
import '../../viewmodel/movie_viewmodel.dart';
import '../../models/movie.dart';
import '../../theme/app_style.dart';
import '../detail/detailmovie.dart';

class ListMoviePage extends StatefulWidget {
  const ListMoviePage({super.key});

  @override
  State<ListMoviePage> createState() => _ListMoviePageState();
}

class _ListMoviePageState extends State<ListMoviePage> {
  final MovieViewModel viewModel = MovieViewModel();

  // Dua Future terpisah agar data tidak tercampur
  Future<List<Movie>>? _nowPlayingFuture; // Untuk Tab "Sedang Tayang"
  Future<List<Movie>>? _upcomingFuture; // Untuk Tab "Akan Datang"

  String _lastLanguageCode = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final languageCode = Provider.of<LanguageProvider>(
      context,
    ).currentLocale.languageCode;

    // Load data hanya jika bahasa berubah atau data belum ada
    if (_lastLanguageCode != languageCode) {
      _lastLanguageCode = languageCode;
      setState(() {
        // [PENTING] Panggil fungsi yang berbeda untuk setiap kategori
        _nowPlayingFuture = viewModel.fetchMovies(
          languageCode,
        ); // API: Now Playing
        _upcomingFuture = viewModel.fetchUpcomingMovies(
          languageCode,
        ); // API: Upcoming
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIndo = _lastLanguageCode == 'id';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            isIndo ? "Film Bioskop" : "Cinema Movies",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
          // TAB BAR
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            tabs: [
              Tab(text: isIndo ? "SEDANG TAYANG" : "NOW PLAYING"),
              Tab(text: isIndo ? "AKAN DATANG" : "COMING SOON"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: SEDANG TAYANG
            _buildMovieGrid(_nowPlayingFuture, isIndo),

            // TAB 2: AKAN DATANG
            _buildMovieGrid(_upcomingFuture, isIndo),
          ],
        ),
      ),
    );
  }

  // Widget Helper Grid (Reusable)
  Widget _buildMovieGrid(Future<List<Movie>>? future, bool isIndo) {
    return FutureBuilder<List<Movie>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              isIndo
                  ? "Gagal memuat: ${snapshot.error}"
                  : "Failed to load: ${snapshot.error}",
              textAlign: TextAlign.center,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(isIndo ? "Tidak ada film." : "No movies."));
        }

        final movies = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.60,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailMoviePage(movie: movie),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        movie.posterPath,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Judul
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Rating
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "${movie.voteAverage}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
