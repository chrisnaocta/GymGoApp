import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'login.dart';

// 🎨 Warna Tema GymGo
const Color primaryDark = Color(0xFFD32F2F); // Merah gelap
const Color primaryLight = Color(0xFFFF5252); // Merah terang
const Color background = Color(0xFFF5F5F5); // Abu muda

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  String _message = '';
  File? _imageFile;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _register() async {
    final nama = _namaController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final alamat = _alamatController.text.trim();
    final telepon = _teleponController.text.trim();

    // Validasi sederhana
    if (nama.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        alamat.isEmpty ||
        telepon.isEmpty) {
      setState(() {
        _message = "Semua data wajib diisi!";
      });
      return;
    }

    if (password != confirmPassword) {
      // setState(() {
      //   _message = "Password dan Konfirmasi Password tidak cocok!";
      // });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password dan Konfirmasi Password tidak cocok!'),
          backgroundColor: primaryDark,
        ),
      );
      return;
    }

    setState(() {
      // _message = "Registrasi berhasil! Silakan login.";
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil! Silakan login.'),
          backgroundColor: Colors.green,
        ),
      );
    });

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryDark),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 16.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 12),

              // 🖼️ Foto Profil
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey[300],
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : null,
                child: _imageFile == null
                    ? const Icon(Icons.person, size: 55, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 8),

              // Hanya menampilkan nama file
              if (_imageFile != null)
                Text(
                  'Nama file: ${_namaController.text.split(" ")[0]}.jpg',
                  style: const TextStyle(fontSize: 14),
                ),

              // Tombol Upload
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryDark,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Upload Foto (Opsional)'),
              ),
              const SizedBox(height: 16),

              // 📝 Form Input
              SizedBox(
                width: screenWidth * 0.9,
                child: Column(
                  children: [
                    TextField(
                      controller: _namaController,
                      decoration: _inputDecoration(
                        'Nama Lengkap',
                        Icons.person,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: _inputDecoration('Email', Icons.email),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Password dengan toggle eye
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: _inputDecoration(
                        'Password',
                        Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: primaryDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Konfirmasi Password
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: _inputDecoration(
                        'Konfirmasi Password',
                        Icons.lock_outline,
                        // suffixIcon: IconButton(
                        //   icon: Icon(
                        //     _obscureConfirmPassword
                        //         ? Icons.visibility_off
                        //         : Icons.visibility,
                        //     color: primaryDark,
                        //   )
                        //   onPressed: () {
                        //     setState(() {
                        //       _obscureConfirmPassword =
                        //           !_obscureConfirmPassword;
                        //     });
                        //   },
                        // ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _alamatController,
                      decoration: _inputDecoration('Alamat', Icons.home),
                      minLines: 3,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _teleponController,
                      decoration: _inputDecoration('No. Telepon', Icons.phone),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Info
              const SizedBox(
                width: 300,
                child: Text(
                  "Setelah registrasi, Anda akan diarahkan ke halaman Login.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(height: 20),

              // 🔘 Tombol Register
              SizedBox(
                height: 48,
                width: 180,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pesan validasi
              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: const TextStyle(
                    color: primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
