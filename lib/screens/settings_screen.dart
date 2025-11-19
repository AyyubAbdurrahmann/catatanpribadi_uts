import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.teal,
                    child: Text(
                      user?.email?[0].toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.email ?? 'User',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pengguna Catatanku',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Theme Section
          Text(
            'Tampilan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 12),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Tema Gelap'),
                  subtitle: const Text('Aktifkan mode gelap'),
                  secondary: Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: Colors.teal,
                  ),
                  value: themeProvider.isDarkMode,
                  activeColor: Colors.teal,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // About Section
          Text(
            'Tentang',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 12),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.teal),
                  title: const Text('Versi Aplikasi'),
                  subtitle: const Text('1.0.0'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Tentang Aplikasi'),
                        content: const Text(
                          'Catatanku v1.0.0\n\n'
                          'Aplikasi catatan pribadi dengan fitur:\n'
                          '• Authentication dengan Firebase\n'
                          '• Cloud storage menggunakan Firestore\n'
                          '• Dark/Light Mode\n'
                          '• UI yang clean dan modern\n\n'
                          'Dikembangkan dengan Flutter & Firebase',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: Colors.teal),
                  title: const Text('Bantuan'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Bantuan'),
                        content: const Text(
                          'Cara menggunakan aplikasi:\n\n'
                          '1. Login dengan email dan password\n'
                          '2. Tap tombol + untuk menambah catatan baru\n'
                          '3. Tap catatan untuk mengedit\n'
                          '4. Geser atau tap icon hapus untuk menghapus\n'
                          '5. Ubah tema di menu pengaturan\n\n'
                          'Jika ada pertanyaan, hubungi support.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Mengerti'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.privacy_tip_outlined,
                    color: Colors.teal,
                  ),
                  title: const Text('Kebijakan Privasi'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Kebijakan Privasi'),
                        content: const SingleChildScrollView(
                          child: Text(
                            'Kami menghargai privasi Anda.\n\n'
                            'Data yang kami kumpulkan:\n'
                            '• Email untuk autentikasi\n'
                            '• Catatan yang Anda buat\n\n'
                            'Data Anda:\n'
                            '• Disimpan dengan aman di Firebase\n'
                            '• Hanya dapat diakses oleh Anda\n'
                            '• Tidak dibagikan kepada pihak ketiga\n'
                            '• Dapat dihapus kapan saja\n\n'
                            'Keamanan:\n'
                            '• Enkripsi data saat transmisi\n'
                            '• Autentikasi yang aman\n'
                            '• Backup otomatis\n\n'
                            'Untuk informasi lebih lanjut, hubungi kami.',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // App Info
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.note_alt_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'Catatanku',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Made with ❤️ using Flutter',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
