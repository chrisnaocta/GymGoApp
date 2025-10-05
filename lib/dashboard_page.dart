import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'keranjang.dart';
import 'login.dart';
import 'productdetail_page.dart';

const Color primaryDark = Color(0xFFD32F2F); // Merah gelap
const Color primaryLight = Color(0xFFFF5252); // Merah terang
const Color background = Color(0xFFF5F5F5); // Abu muda

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Dummy data user
  String userName = 'Michael';
  String userEmail = 'michael@email.com';
  String userProfilePhoto =
      'https://awsimages.detik.net.id/community/media/visual/2019/02/19/42393387-9c5c-4be4-97b8-49260708719e.jpeg?w=700&q=90';

  // Data paket membership
  final List<Map<String, dynamic>> memberships = [
    {
      "idproduct": "MB-SL",
      'title': 'Silver',
      'price': 1200000,
      'duration': "9 Bulan",
      'image':
          'https://www.epsb.co.uk/wp-content/uploads/silver-membership2.png',
      'shortDesc':
          "Paket dasar untuk akses gym dan penggunaan locker, cocok bagi pemula yang ingin mulai berolahraga.",
      'fullDesc':
          '''Silver Membership Cocok untuk Anda yang baru memulai fitness.
- Akses gym reguler
- Locker pribadi
- Konsultasi dasar dengan staff gym''',
    },
    {
      "idproduct": "MB-GL",
      'title': 'Gold',
      'price': 1500000,
      'duration': "12 Bulan",
      'image': 'https://www.epsb.co.uk/wp-content/uploads/gold-membership1.png',
      'shortDesc': 'Akses gym + kelas premium & 5x konsultasi trainer.',
      'fullDesc':
          ''' Gold Membership cocok untuk Anda yang ingin hasil maksimal.
- Semua fasilitas Silver
- Akses kelas Zumba, Yoga, Pilates
- Gratis 5x konsultasi dengan trainer''',
    },
    {
      "idproduct": "MB-PL",
      'title': 'Platinum',
      'price': 1700000,
      'duration': "15 Bulan",
      'image': 'assets/images/platinum.png',
      'shortDesc': 'Paket lengkap: akses VIP 24 jam, kelas & personal trainer.',
      'fullDesc': '''
Platinum Membership adalah paket eksklusif dengan semua fasilitas terbaik:
- Semua fasilitas Gold
- Personal Trainer pribadi
- Akses 24 jam ke gym
- Semua kelas dan fasilitas VIP''',
    },
  ];

  String formatCurrency(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');

    // Cek ulang nilai isLogin setelah diset
    bool? status = prefs.getBool('isLogin');
    print("DEBUG: isLogin diset jadi $status"); // tampil di terminal

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Logout berhasil")));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
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

        // Tombol menu (leading)
        leading: SizedBox(
          width: 90,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            ],
          ),
        ),

        // Judul tengah
        title: const Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // teks putih agar kontras
          ),
        ),

        // Tombol logout (kanan)
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),

      // Drawer profil
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryLight, primaryDark],
            ),
          ),
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.transparent),
                accountName: Text(
                  userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(userEmail),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(userProfilePhoto),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart, color: Colors.white),
                title: const Text(
                  'Keranjang',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => KeranjangPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),

      // Body daftar paket membership
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: memberships.length,
          itemBuilder: (context, index) {
            final item = memberships[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Gambar Paket
                    item['image'].toString().startsWith('http')
                        ? Image.network(
                            item['image'],
                            height: 150,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            item['image'],
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                    const SizedBox(height: 12),

                    // Judul
                    Text(
                      "Membership ${item['title']}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryDark,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Deskripsi
                    Text(
                      item['shortDesc'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 7),

                    // Harga
                    Text(
                      formatCurrency(item['price']),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: primaryLight,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tombol Pilih
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryDark,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                productId: item['idproduct'],
                                productName: item['title'],
                                productPrice: item['price'],
                                productDescription: item['fullDesc'],
                                productDuration: item['duration'],
                                productImage: item['image'],
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Pilih Membership',
                          style: TextStyle(fontSize: 16),
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
    );
  }
}
