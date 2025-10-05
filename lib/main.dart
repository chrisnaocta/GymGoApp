import 'package:flutter/material.dart';
import 'login.dart'; // Pastikan file login.dart sudah ada

// 🎨 Warna Tema Aplikasi
const Color primaryDark = Color(0xFFD32F2F); // Merah gelap
const Color primaryLight = Color(0xFFFF5252); // Merah terang
const Color background = Color(0xFFF5F5F5); // Abu muda

void main() {
  runApp(const GymGoApp());
}

class GymGoApp extends StatelessWidget {
  const GymGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      title: 'GymGo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primaryDark, // Warna utama tombol & elemen aktif
          onPrimary: Colors.white, // Warna teks di atas tombol utama
          secondary: primaryLight, // Warna aksen (misalnya ikon, highlight)
          onSecondary: Colors.white,
          error: Colors.red.shade700,
          onError: Colors.white,
          background: background, // Warna latar belakang utama
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryDark,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
      ),
      home: LoginPage(), // Halaman pertama: Login
    );
  }
}
