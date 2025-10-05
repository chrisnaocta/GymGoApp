import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'keranjang.dart';

// 🎨 Warna Tema Aplikasi
const Color primaryDark = Color(0xFFD32F2F); // Merah gelap
const Color primaryLight = Color(0xFFFF5252); // Merah terang
const Color background = Color(0xFFF5F5F5); // Abu muda

class ProductDetailPage extends StatelessWidget {
  final String productId;
  final String productName;
  final int productPrice;
  final String productImage;
  final String productDescription;
  final String productDuration;

  const ProductDetailPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productDescription,
    required this.productDuration,
  });

  String formatCurrency(int price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    String formattedPrice = formatCurrency(productPrice);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // biar rapi
        toolbarHeight: 50,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,

        // Gradient merah
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter, // Titik pusat radial (bisa diubah)
              radius: 3.0, // Semakin besar → semakin melebar
              colors: [
                primaryLight, // merah terang di tengah
                Color(0xFFE53935), // merah sedang
                primaryDark, // merah gelap di pinggir
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ], // titik transisi warna (0 = tengah, 1 = pinggir)
            ),
          ),
        ),

        // Tombol back (leading)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // ⬅️ kembali ke halaman sebelumnya
          },
        ),

        // Judul tengah
        title: const Text(
          "Detail Produk",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // teks putih agar kontras
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: background,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🖼️ Gambar Produk
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: productImage.startsWith('http')
                      ? Image.network(
                          productImage,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.error,
                              size: 100,
                              color: Colors.red,
                            );
                          },
                        )
                      : Image.asset(
                          productImage,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 5),

              // 📝 ID Produk
              Text(
                "ID Produk: $productId",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryDark,
                ),
                textAlign: TextAlign.center,
              ),

              // 📝 Nama Produk
              Text(
                "Membership: $productName",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryDark,
                ),
                textAlign: TextAlign.center,
              ),

              Text(
                "Durasi: $productDuration",
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 0, 0, 0),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 5),

              // 📜 Deskripsi
              Text(
                productDescription,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 0, 0, 0),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              // 💰 Harga
              Text(
                "Harga: $formattedPrice",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryDark,
                ),
              ),
              const SizedBox(height: 15),

              // 🛒 Tombol Tambahkan ke Keranjang (Gradient)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    List<String> cart = prefs.getStringList('cart') ?? [];
                    List<Map<String, dynamic>> cartItems = cart
                        .map((item) => jsonDecode(item) as Map<String, dynamic>)
                        .toList();

                    // Cek apakah ada item di keranjang
                    if (cartItems.isEmpty) {
                      // Tambahkan produk baru
                      Map<String, dynamic> newProduct = {
                        "idproduct": productId,
                        "product": productName,
                        "price": productPrice,
                        "image": productImage,
                        "description": productDescription,
                        "duration": productDuration,
                        "quantity": 1,
                      };
                      cartItems.add(newProduct);

                      await prefs.setStringList(
                        'cart',
                        cartItems.map((e) => jsonEncode(e)).toList(),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                            vertical: MediaQuery.of(context).size.height * 0.4,
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          content: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Membership $productName berhasil ditambahkan ke keranjang",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KeranjangPage(),
                        ),
                      );
                    } else {
                      // Jika ada produk apapun di keranjang, tidak bisa menambah
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.orange,
                          content: const Text(
                            "Keranjang sudah ada produk membership, tidak bisa menambahkan membership lain",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryDark,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Text(
                      'Tambahkan ke keranjang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
