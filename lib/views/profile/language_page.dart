import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil state bahasa saat ini
    final provider = Provider.of<LanguageProvider>(context);
    final isIndo = provider.currentLocale.languageCode == 'id';

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
          "Bahasa",
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Text(
              "• Pilih bahasa Anda\n• Choose your language",
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
          ),
          const SizedBox(height: 10),
          
          // Pilihan Bahasa Indonesia
          _buildLanguageItem(
            context,
            title: "Indonesia",
            isSelected: isIndo,
            onTap: () => provider.changeLanguage('id'),
          ),

          const Divider(height: 1),

          // Pilihan Bahasa Inggris
          _buildLanguageItem(
            context,
            title: "English",
            isSelected: !isIndo,
            onTap: () => provider.changeLanguage('en'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // Radio Button Custom (Lingkaran)
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF1A237E) : Colors.grey,
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF1A237E) : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}