# CinemaTix - Aplikasi Pemesanan Tiket Bioskop

CinemaTix adalah aplikasi mobile berbasis Flutter yang dikembangkan untuk memenuhi Ujian Akhir Semester (UAS) mata kuliah Mobile Programming. Aplikasi ini memungkinkan pengguna untuk melihat daftar film yang sedang tayang, akan datang, mencari film, melihat detail film, dan mensimulasikan pemesanan tiket bioskop.

Aplikasi ini menerapkan prinsip **Clean Architecture** dengan memisahkan logic pengambilan data (Service), manajemen state (Provider), dan tampilan (UI).

## Fitur Utama

1.  **Integrasi API Real-time:** Mengambil data film dari TheMovieDB (TMDB).
2.  **Kategori Film:** Menampilkan tab "Sedang Tayang" (Now Playing) dan "Akan Datang" (Upcoming).
3.  **Pencarian (Search):** Mencari film berdasarkan judul.
4.  **Detail Film:** Menampilkan sinopsis, rating, poster, dan trailer.
5.  **Sistem Booking:** Simulasi pemilihan kursi dan pembayaran.
6.  **Notifikasi & Riwayat:** Notifikasi otomatis setelah pembayaran dan riwayat tiket.
7.  **Manajemen State:** Menggunakan `Provider` untuk manajemen data yang efisien.

## Daftar Endpoint API (TheMovieDB)

Aplikasi ini menggunakan API Publik dari [TheMovieDB](https://developer.themoviedb.org/docs). Berikut endpoint yang digunakan:

- **Now Playing:** `GET /movie/now_playing`
  - Digunakan untuk menampilkan daftar film di halaman Beranda.
- **Upcoming:** `GET /movie/upcoming`
  - Digunakan untuk menampilkan daftar film yang akan segera tayang.
- **Search Movie:** `GET /search/movie`
  - Digunakan untuk fitur pencarian film berdasarkan kata kunci.
- **Movie Detail:** `GET /movie/{movie_id}`
  - Digunakan untuk mengambil detail lengkap, durasi, dan genre.
- **Credits (Cast):** `GET /movie/{movie_id}/credits`
  - Digunakan untuk menampilkan daftar pemeran film.
- **Videos (Trailer):** `GET /movie/{movie_id}/videos`
  - Digunakan untuk mendapatkan link trailer YouTube.

## Arsitektur Aplikasi

Aplikasi ini dibangun dengan struktur direktori yang memisahkan tanggung jawab (Separation of Concerns):

- `lib/services/`: Menangani komunikasi HTTP langsung ke API.
- `lib/providers/`: Menangani logika bisnis dan manajemen state aplikasi.
- `lib/views/`: Menangani tampilan UI dan interaksi pengguna.
- `lib/models/`: Mendefinisikan struktur data (objek) dari respon JSON.

## Cara Instalasi

Pastikan Anda telah menginstal Flutter SDK pada komputer Anda.

1.  **Clone Repository:**
    ```bash
    git clone [https://github.com/Eqie-Az/movie_app.git](https://github.com/Eqie-Az/movie_app.git)
    ```
2.  **Masuk ke Direktori:**
    ```bash
    cd movie_app
    ```
3.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Jalankan Aplikasi:**
    ```bash
    flutter run
    ```

---

**Dikembangkan oleh:** Rifqi Azhar Raditya (230605110145)
