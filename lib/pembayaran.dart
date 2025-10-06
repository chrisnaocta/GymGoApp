import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 🎨 Warna Tema
const Color primaryDark = Color(0xFFD32F2F);
const Color primaryLight = Color(0xFFFF5252);
const Color background = Color(0xFFF5F5F5);

class PembayaranPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedProducts;

  const PembayaranPage({Key? key, required this.selectedProducts})
    : super(key: key);

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  File? _imageFile;
  List<Map<String, dynamic>> cartItems = [];
  final ImagePicker _picker = ImagePicker();
  bool uploaded = false;
  String _selectedMethod = "qris"; // default ke QRIS

  // Dummy data user
  String userName = 'Michael';
  String userEmail = 'michael@email.com';
  String userAlamat = 'Jalan No. 123, Jakarta';
  String userTelepon = '08123456789';

  // Pilih gambar dari gallery
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
        uploaded = true;
      });
    }
  }

  // Format harga
  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(
      'cart',
    ); // pastikan key 'cart' sesuai dengan yang kamu pakai saat simpan
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Hitung total
    int totalHarga = widget.selectedProducts.fold(0, (sum, item) {
      int price = int.parse(item['price'].toString());
      int qty = (item['quantity'] as num).toInt();
      return sum + (price * qty);
    });

    var uploadedText = uploaded
        ? Text("Uploaded ", style: TextStyle(fontSize: 16, color: Colors.blue))
        : SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Pembayaran",
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ List Produk
            Container(
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.selectedProducts.length,
                itemBuilder: (context, index) {
                  final item = widget.selectedProducts[index];
                  return ListTile(
                    leading: item['image'].toString().startsWith('http')
                        ? Image.network(
                            item['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.error,
                                size: 50,
                                color: Colors.red,
                              );
                            },
                          )
                        : Image.asset(
                            item['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.error,
                                size: 50,
                                color: Colors.red,
                              );
                            },
                          ),
                    title: Text("${item['product']} Membership"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: $userEmail"),
                        const SizedBox(height: 2),
                        Text("Alamat: $userAlamat"),
                        const SizedBox(height: 2),
                        Text("Telepon: $userTelepon"),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 8),

            // ✅ Total
            Container(
              color: Colors.white,
              width: screenWidth,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Harga",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryDark,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    formatCurrency(totalHarga.toString()),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),

            // ✅ Info Pembayaran
            Container(
              color: Colors.white,
              width: screenWidth,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pilih Metode Pembayaran",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryDark,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Radio button CASH
                  RadioListTile<String>(
                    title: Text("CASH"),
                    value: "cash",
                    groupValue: _selectedMethod,
                    activeColor:
                        Colors.black, // ⬅ warna saat dipilih jadi hitam
                    onChanged: (value) {
                      setState(() {
                        _selectedMethod = value!;
                      });
                    },
                  ),

                  // Radio button QRIS
                  RadioListTile<String>(
                    title: Text("QRIS"),
                    value: "qris",
                    groupValue: _selectedMethod,
                    activeColor:
                        Colors.black, // ⬅ warna saat dipilih jadi hitam
                    onChanged: (value) {
                      setState(() {
                        _selectedMethod = value!;
                      });
                    },
                  ),

                  // Radio button Virtual Account
                  RadioListTile<String>(
                    title: Text("Virtual Account"),
                    value: "va",
                    groupValue: _selectedMethod,
                    activeColor:
                        Colors.black, // ⬅ warna saat dipilih jadi hitam
                    onChanged: (value) {
                      setState(() {
                        _selectedMethod = value!;
                      });
                    },
                  ),

                  SizedBox(height: 16),

                  // ✅ Tampilkan detail sesuai pilihan
                  if (_selectedMethod == "qris") ...[
                    Text(
                      "Scan QRIS berikut untuk membayar:",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Image.network(
                      "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=contoh-qris",
                      width: 150,
                      height: 150,
                    ),
                  ] else if (_selectedMethod == "va") ...[
                    Text(
                      "Virtual Account (BCA)",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "1234567890",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text("A.N GymGo"),
                  ] else if (_selectedMethod == "cash")
                    ...[],
                ],
              ),
            ),

            // ✅ Tombol Buat Pesanan
            SizedBox(
              width: screenWidth - 80,
              child: ElevatedButton(
                onPressed: () async {
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
                          child: const Text(
                            "Terima kasih, pesanan telah kami terima",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );

                  // 🧹 Hapus isi keranjang di SharedPreferences
                  await clearCart();

                  // Delay sebentar agar SnackBar sempat tampil
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardPage()),
                      (route) => false,
                    );
                  });
                },
                child: const Text('Confirm'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 36),
                  backgroundColor: primaryDark,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
