import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/movie_provider.dart'; // [GANTI] ViewModel ke Provider
import '../../models/movie.dart';
import '../../theme/app_style.dart';
import '../detail/detailmovie.dart';

class ListMoviePage extends StatefulWidget {
  const ListMoviePage({super.key});

  @override
  State<ListMoviePage> createState() => _ListMoviePageState();
}

class _ListMoviePageState extends State<ListMoviePage> {
  // [UPDATE] Gunakan Provider
  final MovieProvider _movieProvider = MovieProvider();
  Future<List<Movie>>? _nowPlayingFuture;
  Future<List<Movie>>? _upcomingFuture;
  String _lastLanguageCode = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Provider.of<LanguageProvider>(
      context,
    ).currentLocale.languageCode;
    if (_lastLanguageCode != languageCode) {
      _lastLanguageCode = languageCode;
      setState(() {
        // Fetch data via Provider -> Service
        _nowPlayingFuture = _movieProvider.fetchMovies(languageCode);
        _upcomingFuture = _movieProvider.fetchUpcomingMovies(languageCode);
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
            onPressed: () => Navigator.pop(context),
          ),
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
            _buildMovieGrid(_nowPlayingFuture, isIndo),
            _buildMovieGrid(_upcomingFuture, isIndo),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieGrid(Future<List<Movie>>? future, bool isIndo) {
    return FutureBuilder<List<Movie>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        if (snapshot.hasError)
          return Center(
            child: Text(
              isIndo
                  ? "Gagal memuat: ${snapshot.error}"
                  : "Failed to load: ${snapshot.error}",
            ),
          );
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return Center(child: Text(isIndo ? "Tidak ada film." : "No movies."));

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.60,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final movie = snapshot.data![index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailMoviePage(movie: movie),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        movie.posterPath,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
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
