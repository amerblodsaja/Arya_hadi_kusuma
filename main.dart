import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const KulinerNusantaraApp());
}

// =========================================================================
// 1. DATA MODELS
// =========================================================================
class Menu {
  final String id;
  final String nama;
  final double harga;
  final double rating;
  final String kategori;
  final String deskripsi;
  final String ikon; 
  bool isFavorit;

  Menu({
    required this.id,
    required this.nama,
    required this.harga,
    required this.rating,
    required this.kategori,
    required this.deskripsi,
    required this.ikon,
    this.isFavorit = false,
  });
}

class CartItem {
  final Menu menu;
  int quantity;
  String catatan;
  String levelPedas;

  CartItem({
    required this.menu, 
    this.quantity = 1, 
    this.catatan = '', 
    required this.levelPedas,
  });
}

class Riwayat {
  final String idPesanan;
  final String tanggal;
  final double totalBayar;
  final String status;

  Riwayat({
    required this.idPesanan, 
    required this.tanggal, 
    required this.totalBayar, 
    required this.status,
  });
}

// =========================================================================
// 2. MAIN APPLICATION CONFIG
// =========================================================================
class KulinerNusantaraApp extends StatefulWidget {
  const KulinerNusantaraApp({super.key});

  @override
  State<KulinerNusantaraApp> createState() => _KulinerNusantaraAppState();
}

class _KulinerNusantaraAppState extends State<KulinerNusantaraApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Kuliner',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xff2E7D32),
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xffF7F9FA),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xff2E7D32),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff121212),
      ),
      home: SplashScreen(
        onThemeChanged: (val) => setState(() => _isDarkMode = val),
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

// =========================================================================
// 3. SPLASH SCREEN (3 DETIK)
// =========================================================================
class SplashScreen extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;
  final bool isDarkMode;
  const SplashScreen({super.key, required this.onThemeChanged, required this.isDarkMode});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainFramework(onThemeChanged: widget.onThemeChanged, isDarkMode: widget.isDarkMode)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xff2E7D32), Color(0xff1B5E20)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const CircleAvatar(radius: 45, backgroundColor: Colors.white12, child: Icon(Icons.restaurant, size: 50, color: Colors.white)),
            const SizedBox(height: 20),
            const Text('Go Kuliner', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 6),
            Text('Jelajahi Cita Rasa Indonesia', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8), fontStyle: FontStyle.italic)),
            const Spacer(),
            const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// 4. MAIN PLATFORM NAVIGATION FRAMEWORK
// =========================================================================
class MainFramework extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;
  final bool isDarkMode;
  const MainFramework({super.key, required this.onThemeChanged, required this.isDarkMode});

  @override
  State<MainFramework> createState() => _MainFrameworkState();
}

class _MainFrameworkState extends State<MainFramework> {
  int _currentIndex = 0;

  // URL gambar di bawah ini menggunakan ID spesifik permanen dari Unsplash untuk menjamin akurasi gambar makanan
  final List<Menu> _menuData = [
    Menu(id: '1', nama: 'Nasi Goreng Spesial', harga: 25000, rating: 4.9, kategori: 'Nasi', deskripsi: 'Nasi goreng bumbu rempah pilihan dilengkapi dengan telur mata sapi hiasan emping dan ayam suwir gurih.', ikon: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=500&auto=format&fit=crop'),
    Menu(id: '2', nama: 'Nasi Uduk Komplit', harga: 22000, rating: 4.8, kategori: 'Nasi', deskripsi: 'Nasi uduk harum daun pandan serai bertabur bawang goreng ditemani semur tahu bihun goreng dan empal.', ikon: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&auto=format&fit=crop'),
    Menu(id: '3', nama: 'Mie Ayam Pangsit', harga: 18000, rating: 4.7, kategori: 'Mie', deskripsi: 'Mie kenyal gurih bertabur tumisan ayam cincang bumbu kecap manis disajikan dengan kuah bening segar.', ikon: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500&auto=format&fit=crop'),
    Menu(id: '4', nama: 'Bakso Urat Jumbo', harga: 23000, rating: 4.9, kategori: 'Mie', deskripsi: 'Bakso urat sapi asli super besar disiram kuah sumsum kaldu sapi kental yang gurih segar.', ikon: 'https://images.unsplash.com/photo-1626132647523-66f5bf380027?w=500&auto=format&fit=crop'),
    Menu(id: '5', nama: 'Soto Lamongan Koya', harga: 20000, rating: 4.8, kategori: 'Soto', deskripsi: 'Soto ayam kampung kuah kuning bening segar kaya rempah dengan taburan bubuk koya gurih kental.', ikon: 'https://images.unsplash.com/photo-1608897013039-887f21d8c804?w=500&auto=format&fit=crop'),
    Menu(id: '6', nama: 'Sate Ayam Madura', harga: 25000, rating: 4.8, kategori: 'Sate', deskripsi: '10 Tusuk sate daging ayam fillet tebal empuk dibakar arang tradisional disiram saus kacang tanah halus.', ikon: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=500&auto=format&fit=crop'),
    Menu(id: '7', nama: 'Rendang Padang Asli', harga: 38000, rating: 5.0, kategori: 'Rendang', deskripsi: 'Daging sapi pilihan dimasak berjam-jam menggunakan santan murni kental dan rempah khas minang asli.', ikon: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500&auto=format&fit=crop'),
    Menu(id: '8', nama: 'Udang Bakar Madu', harga: 45000, rating: 4.9, kategori: 'Seafood', deskripsi: 'Udang pancet ukuran besar dibakar merata dengan olesan mentega dan madu hutan alami manis gurih.', ikon: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500&auto=format&fit=crop'),
    Menu(id: '9', nama: 'Batagor Bandung', harga: 15000, rating: 4.6, kategori: 'Jajanan', deskripsi: 'Tahu bakso ikan tenggiri dan siomay goreng renyah disiram bumbu saus kacang tanah kental.', ikon: 'https://images.unsplash.com/photo-1601050690597-df056fb4ce78?w=500&auto=format&fit=crop'),
    Menu(id: '10', nama: 'Es Teh Manis Jumbo', harga: 5000, rating: 4.9, kategori: 'Minuman', deskripsi: 'Seduhan daun teh hijau wangi bunga melati disajikan dingin manis dengan es batu higienis.', ikon: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=500&auto=format&fit=crop'),
    Menu(id: '11', nama: 'Es Dawet Ayu', harga: 12000, rating: 4.7, kategori: 'Minuman', deskripsi: 'Cendol kenyal sagu pandan alami berkuah santan gurih melimpah disiram kentalnya juruh gula merah aren.', ikon: 'https://images.unsplash.com/photo-1497534446932-c925b458314e?w=500&auto=format&fit=crop'),
    Menu(id: '12', nama: 'Jus Alpukat Mentega', harga: 17000, rating: 4.8, kategori: 'Minuman', deskripsi: 'Blenderan daging alpukat mentega kental creamy disajikan dengan hiasan kental manis cokelat.', ikon: 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=500&auto=format&fit=crop'),
  ];

  final List<CartItem> _globalCart = [];
  final List<Riwayat> _riwayatData = [
    Riwayat(idPesanan: 'KN-87234', tanggal: 'Kemarin, 13:20', totalBayar: 55000, status: 'Selesai'),
  ];

  void _addCart(Menu m, int qty, String note, String spicy) {
    setState(() {
      int idx = _globalCart.indexWhere((item) => item.menu.id == m.id && item.levelPedas == spicy);
      if (idx != -1) {
        _globalCart[idx].quantity += qty;
      } else {
        _globalCart.add(CartItem(menu: m, quantity: qty, catatan: note, levelPedas: spicy));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${m.nama} dimasukkan ke keranjang!'),
      backgroundColor: const Color(0xff2E7D32),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      BerandaTab(menus: _menuData, onFav: (m) => setState(() => m.isFavorit = !m.isFavorit), onAdd: _addCart),
      MenuTab(menus: _menuData, onFav: (m) => setState(() => m.isFavorit = !m.isFavorit), onAdd: _addCart),
      WithCartBadge(
        cartItems: _globalCart,
        onUpdate: () => setState(() {}),
        onCheckoutSuccess: (double total) {
          setState(() {
            _riwayatData.insert(0, Riwayat(idPesanan: 'KN-${Random().nextInt(9000) + 1000}', tanggal: 'Hari Ini, Baru saja', totalBayar: total, status: 'Diproses'));
            _globalCart.clear();
          });
        },
      ),
      RiwayatTab(riwayatList: _riwayatData),
      ProfilTab(isDark: widget.isDarkMode, onThemeChanged: widget.onThemeChanged),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        indicatorColor: const Color(0xff2E7D32).withOpacity(0.15),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: Color(0xff2E7D32)), label: 'Beranda'),
          const NavigationDestination(icon: Icon(Icons.restaurant_menu_outlined), selectedIcon: Icon(Icons.restaurant_menu, color: Color(0xff2E7D32)), label: 'Menu'),
          NavigationDestination(
            icon: Badge(isLabelVisible: _globalCart.isNotEmpty, label: Text('${_globalCart.length}'), child: const Icon(Icons.shopping_cart_outlined)),
            selectedIcon: Badge(isLabelVisible: _globalCart.isNotEmpty, label: Text('${_globalCart.length}'), child: const Icon(Icons.shopping_cart, color: Color(0xff2E7D32))),
            label: 'Keranjang',
          ),
          const NavigationDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history, color: Color(0xff2E7D32)), label: 'Riwayat'),
          const NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: Color(0xff2E7D32)), label: 'Profil'),
        ],
      ),
    );
  }
}

// =========================================================================
// 5. TAB 1: BERANDA WIDGET
// =========================================================================
class BerandaTab extends StatefulWidget {
  final List<Menu> menus;
  final Function(Menu) onFav;
  final Function(Menu, int, String, String) onAdd;
  const BerandaTab({super.key, required this.menus, required this.onFav, required this.onAdd});

  @override
  State<BerandaTab> createState() => _BerandaTabState();
}

class _BerandaTabState extends State<BerandaTab> {
  String _selectedCat = 'Semua';
  String _search = '';
  final List<String> _categories = ['Semua', 'Nasi', 'Mie', 'Soto', 'Sate', 'Rendang', 'Minuman'];

  @override
  Widget build(BuildContext context) {
    final listDisplay = widget.menus.where((m) {
      bool catMatch = _selectedCat == 'Semua' || m.kategori == _selectedCat;
      bool searchMatch = m.nama.toLowerCase().contains(_search.toLowerCase());
      return catMatch && searchMatch;
    }).toList();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: Color(0xff2E7D32), child: Icon(Icons.person, color: Colors.white)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selamat Datang,', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('Pecinta Kuliner 👋', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.local_offer, color: Colors.orange), onPressed: () {})
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                onChanged: (v) => setState(() => _search = v),
                decoration: InputDecoration(
                  hintText: 'Cari makanan favoritmu...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xff2E7D32)),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xff2E7D32), Color(0xff43A047)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DISKON NUSANTARA 25%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Text('Nikmati gratis ongkir dan potongan harga di semua menu khas!', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.fastfood, size: 48, color: Colors.white24)
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, idx) {
                  final cat = _categories[idx];
                  final isSelect = _selectedCat == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelect,
                      selectedColor: const Color(0xff2E7D32).withOpacity(0.2),
                      onSelected: (v) => setState(() => _selectedCat = cat),
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(16.0), child: Text('Rekomendasi Menu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))),
          listDisplay.isEmpty
              ? const SliverToBoxAdapter(child: Center(child: Text('Menu tidak ditemukan')))
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.72, crossAxisSpacing: 12, mainAxisSpacing: 12),
                    delegate: SliverChildBuilderDelegate(
                      (ctx, idx) {
                        final item = listDisplay[idx];
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => DetailMenuPage(menu: item, onAdd: widget.onAdd))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    item.ikon,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)));
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(child: Icon(Icons.fastfood, size: 40, color: Colors.grey));
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.nama, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text('Rp ${item.harga.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xff2E7D32), fontWeight: FontWeight.w600)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(children: [const Icon(Icons.star, color: Colors.amber, size: 14), Text(' ${item.rating}', style: const TextStyle(fontSize: 12))]),
                                          IconButton(icon: Icon(item.isFavorit ? Icons.favorite : Icons.favorite_border, size: 18, color: Colors.red), onPressed: () => widget.onFav(item)),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: listDisplay.length,
                    ),
                  ),
                ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// =========================================================================
// 6. TAB 2: MENU JELAJAH
// =========================================================================
class MenuTab extends StatefulWidget {
  final List<Menu> menus;
  final Function(Menu) onFav;
  final Function(Menu, int, String, String) onAdd;
  const MenuTab({super.key, required this.menus, required this.onFav, required this.onAdd});

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  String _activeSort = 'Terpopuler';

  @override
  Widget build(BuildContext context) {
    List<Menu> list = List.from(widget.menus);
    if (_activeSort == 'Harga Murah') list.sort((a, b) => a.harga.compareTo(b.harga));
    if (_activeSort == 'Terpopuler') list.sort((a, b) => b.rating.compareTo(a.rating));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Menu Khas', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          DropdownButton<String>(
            value: _activeSort,
            underline: const SizedBox(),
            icon: const Icon(Icons.sort, color: Color(0xff2E7D32)),
            onChanged: (v) { if (v != null) setState(() => _activeSort = v); },
            items: const [
              DropdownMenuItem(value: 'Terpopuler', child: Text('Terpopuler', style: TextStyle(fontSize: 13))),
              DropdownMenuItem(value: 'Harga Murah', child: Text('Harga Murah', style: TextStyle(fontSize: 13))),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.72, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: list.length,
        itemBuilder: (context, idx) {
          final item = list[idx];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => DetailMenuPage(menu: item, onAdd: widget.onAdd))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      item.ikon,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)));
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.fastfood, size: 40, color: Colors.grey));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.nama, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                        Text('Rp ${item.harga.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xff2E7D32))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [const Icon(Icons.star, color: Colors.amber, size: 14), Text(' ${item.rating}', style: const TextStyle(fontSize: 12))]),
                            IconButton(icon: Icon(item.isFavorit ? Icons.favorite : Icons.favorite_border, size: 16, color: Colors.red), onPressed: () => widget.onFav(item)),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// =========================================================================
// 7. DETAIL MENU PAGE
// =========================================================================
class DetailMenuPage extends StatefulWidget {
  final Menu menu;
  final Function(Menu, int, String, String) onAdd;
  const DetailMenuPage({super.key, required this.menu, required this.onAdd});

  @override
  State<DetailMenuPage> createState() => _DetailMenuPageOverlayState();
}

class _DetailMenuPageOverlayState extends State<DetailMenuPage> {
  int _counter = 1;
  String _spicy = 'Sedang';
  final TextEditingController _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.menu.nama)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        widget.menu.ikon,
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 80),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(widget.menu.nama, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Rp ${widget.menu.harga.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, color: Color(0xff2E7D32), fontWeight: FontWeight.bold)),
                  const Divider(height: 30),
                  const Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(widget.menu.deskripsi, style: const TextStyle(color: Colors.grey)),
                  const Divider(height: 30),
                  const Text('Pilih Level Pedas', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: ['Tidak Pedas', 'Sedang', 'Pedas Gila'].map((e) {
                      return ChoiceChip(label: Text(e), selected: _spicy == e, onSelected: (v) => setState(() => _spicy = e));
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(controller: _note, decoration: const InputDecoration(labelText: 'Catatan tambahan...', border: OutlineInputBorder())),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: _counter > 1 ? () => setState(() => _counter--) : null),
                Text('$_counter', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setState(() => _counter++)),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff2E7D32), foregroundColor: Colors.white),
                  onPressed: () {
                    widget.onAdd(widget.menu, _counter, _note.text, _spicy);
                    Navigator.pop(context);
                  },
                  child: Text('Tambah - Rp ${(widget.menu.harga * _counter).toStringAsFixed(0)}'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// =========================================================================
// 8. TAB 3: KERANJANG WIDGET
// =========================================================================
class WithCartBadge extends StatefulWidget {
  final List<CartItem> cartItems;
  final VoidCallback onUpdate;
  final Function(double) onCheckoutSuccess;
  const WithCartBadge({super.key, required this.cartItems, required this.onUpdate, required this.onCheckoutSuccess});

  @override
  State<WithCartBadge> createState() => _WithCartBadgeState();
}

class _WithCartBadgeState extends State<WithCartBadge> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    double subtotal = widget.cartItems.fold(0, (sum, i) => sum + (i.menu.harga * i.quantity));
    double ppn = subtotal * 0.11;
    double total = subtotal + ppn + (subtotal > 0 ? 2000 : 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja', style: TextStyle(fontWeight: FontWeight.bold))),
      body: _loading
          ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(color: Color(0xff2E7D32)), SizedBox(height: 12), Text('Membuat pesanan anda...')]))
          : widget.cartItems.isEmpty
              ? const Center(child: Text('Keranjang kosong, yuk jajan dulu!'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.cartItems.length,
                        itemBuilder: (context, idx) {
                          final item = widget.cartItems[idx];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(item.menu.ikon, width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.fastfood)),
                              ),
                              title: Text(item.menu.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Rp ${item.menu.harga.toStringAsFixed(0)} (Pedas: ${item.levelPedas})'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, size: 20),
                                      onPressed: () {
                                        if (item.quantity > 1) {
                                          setState(() => item.quantity--);
                                        } else {
                                          setState(() => widget.cartItems.removeAt(idx));
                                        }
                                        widget.onUpdate();
                                      }),
                                  Text('${item.quantity}'),
                                  IconButton(
                                      icon: const Icon(Icons.add_circle_outline, size: 20, color: Color(0xff2E7D32)),
                                      onPressed: () {
                                        setState(() => item.quantity++);
                                        widget.onUpdate();
                                      }),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Theme.of(context).cardColor,
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal'), Text('Rp ${subtotal.toStringAsFixed(0)}')]),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('PPN (11%)'), Text('Rp ${ppn.toStringAsFixed(0)}')]),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Biaya Aplikasi'), Text('Rp 2.000')]),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)), 
                              Text('Rp ${total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff2E7D32), fontSize: 16))
                            ]
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff2E7D32), foregroundColor: Colors.white),
                              onPressed: () {
                                setState(() => _loading = true);
                                Future.delayed(const Duration(seconds: 2), () {
                                  widget.onCheckoutSuccess(total);
                                  setState(() => _loading = false);
                                  showDialog(
                                    context: context,
                                    builder: (c) => AlertDialog(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.check_circle, color: Colors.green),
                                          SizedBox(width: 8),
                                          Text('Checkout Berhasil!'),
                                        ],
                                      ),
                                      content: const Text('Makanan lezat Anda sedang diproses oleh restoran.'),
                                      actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))],
                                    ),
                                  );
                                });
                              },
                              child: const Text('Checkout & Bayar (QRIS/COD)', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
    );
  }
}

// =========================================================================
// 9. TAB 4: RIWAYAT PESANAN
// =========================================================================
class RiwayatTab extends StatelessWidget {
  final List<Riwayat> riwayatList;
  const RiwayatTab({super.key, required this.riwayatList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: riwayatList.length,
        itemBuilder: (context, idx) {
          final r = riwayatList[idx];
          return Card(
            child: ListTile(
              leading: Icon(Icons.receipt, color: r.status == 'Selesai' ? Colors.green : Colors.orange),
              title: Text(r.idPesanan, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(r.tanggal),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Rp ${r.totalBayar.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff2E7D32))),
                  Text(r.status, style: TextStyle(fontSize: 11, color: r.status == 'Selesai' ? Colors.green : Colors.orange, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// =========================================================================
// 10. TAB 5: PROFIL
// =========================================================================
class ProfilTab extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;
  const ProfilTab({super.key, required this.isDark, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Pengguna', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, backgroundColor: Color(0xff2E7D32), child: Icon(Icons.person, size: 50, color: Colors.white)),
            const SizedBox(height: 12),
            const Text('Ahmad Hidayat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('ahmad.hidayat@email.com', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode, color: Color(0xff2E7D32)),
                    title: const Text('Mode Gelap'),
                    value: isDark,
                    onChanged: onThemeChanged,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help, color: Color(0xff2E7D32)),
                    title: const Text('Bantuan / FAQ'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Bantuan'),
                          content: const Text('Pengiriman makanan memerlukan waktu 15-30 menit. Hubungi CS untuk kendala sistem.'),
                          actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Tutup'))],
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Keluar Aplikasi', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Simulasi sistem logout berhasil.')));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}