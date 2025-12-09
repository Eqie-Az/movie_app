import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../theme/app_style.dart';

class CitySelectionPage extends StatefulWidget {
  const CitySelectionPage({super.key});

  @override
  State<CitySelectionPage> createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  final List<String> cities = const [
    "AMBON",
    "BALI",
    "BALIKPAPAN",
    "BANDUNG",
    "BANJARBARU",
    "BANJARMASIN",
    "BATAM",
    "BAUBAU",
    "BEKASI",
    "BENGKULU",
    "BINJAI",
    "BLITAR",
    "BOGOR",
    "JAKARTA",
    "MALANG",
    "SURABAYA",
    "YOGYAKARTA",
  ];

  bool _isLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'GPS mati. Silakan nyalakan GPS di pengaturan emulator/HP.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak.';
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak permanen.';
      }

      // --- PERBAIKAN UTAMA DI SINI ---
      // Kita tambahkan .timeout() agar tidak menunggu selamanya
      Position position =
          await Geolocator.getCurrentPosition(
            desiredAccuracy:
                LocationAccuracy.medium, // Ganti ke medium biar lebih cepat
          ).timeout(
            const Duration(seconds: 20),
            onTimeout: () {
              throw 'Waktu habis! Gagal mendapatkan sinyal GPS.';
            },
          );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        String city =
            placemarks[0].subAdministrativeArea ?? "Lokasi Tidak Dikenal";
        city = city
            .replaceAll("Kota ", "")
            .replaceAll("Kabupaten ", "")
            .toUpperCase();

        if (mounted) {
          Navigator.pop(context, city);
        }
      } else {
        throw 'Alamat tidak ditemukan.';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Gagal: ${e.toString().replaceAll("Exception: ", "")}",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Masukkan Kata Kunci",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: cities.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    cities[index],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () => Navigator.pop(context, cities[index]),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
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
                onPressed: _isLoading ? null : _getCurrentLocation,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Gunakan Lokasi Saya",
                        style: TextStyle(
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
}
