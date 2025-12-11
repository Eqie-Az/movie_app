class AuthService {
  // Database sementara
  static final List<Map<String, String>> _registeredUsers = [];

  static void register(String name, String phone, String password) {
    _registeredUsers.add({'name': name, 'phone': phone, 'password': password});
  }

  static bool login(String phone, String password) {
    return _registeredUsers.any(
      (user) => user['phone'] == phone && user['password'] == password,
    );
  }

  static Map<String, String>? getUser(String phone) {
    try {
      return _registeredUsers.firstWhere((user) => user['phone'] == phone);
    } catch (e) {
      return null;
    }
  }

  static void updateUser(
    String oldPhone,
    String newName,
    String newPhone,
    String newPassword,
  ) {
    final index = _registeredUsers.indexWhere(
      (user) => user['phone'] == oldPhone,
    );
    if (index != -1) {
      _registeredUsers[index] = {
        'name': newName,
        'phone': newPhone,
        'password': newPassword,
      };
    }
  }

  // [BARU] Fungsi Hapus Akun
  static void deleteUser(String phone) {
    _registeredUsers.removeWhere((user) => user['phone'] == phone);
    print("User dengan nomor $phone telah dihapus.");
  }
}
