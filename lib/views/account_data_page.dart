import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_style.dart';
import '../viewmodel/user_provider.dart';
import '../viewmodel/auth_service.dart';
import '../viewmodel/language_provider.dart';
import 'home.dart'; // Import Home untuk navigasi setelah hapus

class AccountDataPage extends StatelessWidget {
  const AccountDataPage({super.key});

  // Dialog Edit (Sama seperti sebelumnya)
  void _showEditDialog(
    BuildContext context,
    String title,
    String initialValue,
    Function(String) onSave, {
    bool isPassword = false,
  }) {
    final TextEditingController controller = TextEditingController(
      text: initialValue,
    );

    showDialog(
      context: context,
      builder: (context) {
        final isIndo =
            Provider.of<LanguageProvider>(
              context,
              listen: false,
            ).currentLocale.languageCode ==
            'id';

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            isIndo ? "Ubah $title" : "Change $title",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: isIndo ? "Masukkan $title baru" : "Enter new $title",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                isIndo ? "Batal" : "Cancel",
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onSave(controller.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isIndo
                            ? "$title berhasil diperbarui!"
                            : "$title updated successfully!",
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: Text(
                isIndo ? "Simpan" : "Save",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // [BARU] Dialog Konfirmasi Hapus Akun
  void _showDeleteConfirmDialog(
    BuildContext context,
    UserProvider userProvider,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isIndo =
            Provider.of<LanguageProvider>(
              context,
              listen: false,
            ).currentLocale.languageCode ==
            'id';

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            isIndo ? "Hapus Akun?" : "Delete Account?",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Text(
            isIndo
                ? "Apakah Anda yakin ingin menghapus akun ini? Data yang dihapus tidak dapat dikembalikan."
                : "Are you sure you want to delete this account? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                isIndo ? "Batal" : "Cancel",
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                // 1. Hapus dari Database
                AuthService.deleteUser(userProvider.userPhone);

                // 2. Logout dari Provider
                userProvider.logout();

                // 3. Tutup Dialog
                Navigator.pop(ctx);

                // 4. Kembali ke Home dan Hapus Stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );

                // 5. Tampilkan Pesan
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isIndo
                          ? "Akun berhasil dihapus."
                          : "Account deleted successfully.",
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              child: Text(
                isIndo ? "Hapus" : "Delete",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isIndo =
        Provider.of<LanguageProvider>(context).currentLocale.languageCode ==
        'id';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isIndo ? "Akun" : "Account",
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildInfoField(
              context,
              isIndo ? "NAMA LENGKAP" : "FULL NAME",
              userProvider.userName,
              onEdit: () {
                _showEditDialog(
                  context,
                  isIndo ? "Nama Lengkap" : "Full Name",
                  userProvider.userName,
                  (newValue) {
                    AuthService.updateUser(
                      userProvider.userPhone,
                      newValue,
                      userProvider.userPhone,
                      userProvider.userPassword,
                    );
                    userProvider.updateData(
                      newValue,
                      userProvider.userPhone,
                      userProvider.userPassword,
                    );
                  },
                );
              },
            ),

            _buildInfoField(
              context,
              isIndo ? "NOMOR HANDPHONE" : "PHONE NUMBER",
              userProvider.userPhone,
              onEdit: () {
                _showEditDialog(
                  context,
                  isIndo ? "Nomor HP" : "Phone Number",
                  userProvider.userPhone,
                  (newValue) {
                    String oldPhone = userProvider.userPhone;
                    AuthService.updateUser(
                      oldPhone,
                      userProvider.userName,
                      newValue,
                      userProvider.userPassword,
                    );
                    userProvider.updateData(
                      userProvider.userName,
                      newValue,
                      userProvider.userPassword,
                    );
                  },
                );
              },
            ),

            _buildInfoField(
              context,
              "PASSWORD",
              userProvider.userPassword,
              isPassword: true,
              onEdit: () {
                _showEditDialog(
                  context,
                  "Password",
                  userProvider.userPassword,
                  (newValue) {
                    AuthService.updateUser(
                      userProvider.userPhone,
                      userProvider.userName,
                      userProvider.userPhone,
                      newValue,
                    );
                    userProvider.updateData(
                      userProvider.userName,
                      userProvider.userPhone,
                      newValue,
                    );
                  },
                  isPassword: true,
                );
              },
            ),

            const Spacer(),

            // [UPDATE] Tombol Hapus Akun dengan Konfirmasi
            TextButton(
              onPressed: () {
                _showDeleteConfirmDialog(context, userProvider);
              },
              child: Text(
                isIndo ? "Hapus Akun Saya" : "Delete My Account",
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(
    BuildContext context,
    String label,
    String value, {
    bool isPassword = false,
    required VoidCallback onEdit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            OutlinedButton(
              onPressed: onEdit,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(50, 25),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: const BorderSide(color: Colors.black54),
              ),
              child: const Text(
                "EDIT",
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
            ),
          ],
        ),
        Text(
          isPassword ? "•" * value.length : value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 20),
      ],
    );
  }
}
