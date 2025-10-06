import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'pembayaran.dart';
import 'dashboard_page.dart';

// 🎨 Warna Tema
const Color primaryDark = Color(0xFFD32F2F);
const Color primaryLight = Color(0xFFFF5252);
const Color background = Color(0xFFF5F5F5);

class KeranjangPage extends StatefulWidget {
  @override
  _KeranjangPageState createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart') ?? [];
    setState(() {
      cartItems = cart
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    });
  }

  String formatCurrency(int price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(price);
  }

  Future<void> removeItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    cartItems.removeAt(index);
    await prefs.setStringList(
      'cart',
      cartItems.map((e) => jsonEncode(e)).toList(),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardPage()),
    );
  }

  Future<void> checkout() async {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Keranjang kosong!")));
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PembayaranPage(selectedProducts: cartItems),
      ),
    );

    if (result == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cart');
      setState(() {
        cartItems.clear();
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    }
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  /// 🧮 Fungsi untuk menentukan durasi berdasarkan membership
  int getMembershipDurationMonths(String productName) {
    switch (productName.toLowerCase()) {
      case 'silver':
        return 9;
      case 'gold':
        return 12;
      case 'platinum':
        return 15;
      default:
        return 0;
    }
  }

  DateTime calculateEndDate(DateTime startDate, int months) {
    return DateTime(startDate.year, startDate.month + months, startDate.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Keranjang",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 3.0,
              colors: [primaryLight, Color(0xFFE53935), primaryDark],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          },
        ),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Keranjang kosong"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final startDate = DateTime.now();

                      final productName = item['product'] ?? '';
                      final months = getMembershipDurationMonths(productName);
                      final endDate = calculateEndDate(startDate, months);

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              item['image'].toString().startsWith('http')
                                  ? Image.network(
                                      item['image'],
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      item['image'],
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                              const SizedBox(height: 12),
                              Text(
                                "$productName Membership",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: primaryDark,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item['description'],
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                formatCurrency(item['price']),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: primaryLight,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text("Durasi: $months Bulan"),
                              const SizedBox(height: 5),

                              // 📅 Tanggal mulai dan berakhir
                              Text(
                                "Tanggal Mulai Membership: ${formatDate(startDate)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Tanggal Berakhir Membership: ${formatDate(endDate)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // 🗑 Tombol hapus
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => removeItem(index),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                  child: const Text(
                                    "Hapus Pesanan",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                      onPressed: checkout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryDark,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Checkout",
                        style: TextStyle(
                          fontSize: 18,
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
