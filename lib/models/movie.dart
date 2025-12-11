class Movie {
  // 1. Definisi Properti (Wajib ada agar file lain tidak error)
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;
  final String category;

  // 2. Constructor (Wajib ada untuk membuat object)
  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    this.category = "General", // Default value
  });

  // 3. Factory Method (Logika parsing JSON yang sudah diperbarui)
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',

      // LOGIKA SINOPSIS:
      // Jika null atau kosong string "", pakai teks default.
      // (Data bahasa Inggris akan masuk ke sini lewat logic di ViewModel)
      overview: (json['overview'] == null || json['overview'] == "")
          ? 'Sinopsis tidak tersedia.'
          : json['overview'],

      // Handle gambar poster
      posterPath: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : 'https://via.placeholder.com/150',

      releaseDate: json['release_date'] ?? 'Unknown',

      // Handle rating
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
