import 'package:flutter/material.dart';

void main() {
  runApp(const ShoppingApp());
}

// DATA PRODUK
class Product {
  final String name;
  final String brand;
  final String image;
  final int price;

  Product({
    required this.name,
    required this.brand,
    required this.image,
    required this.price,
  });
}

// APP
class ShoppingApp extends StatefulWidget {
  const ShoppingApp({super.key});

  @override
  State<ShoppingApp> createState() => _ShoppingAppState();
}

class _ShoppingAppState extends State<ShoppingApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Shopping',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const HomePage(),
    );
  }
}

// HOME PAGE
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // DATA PRODUK
  final products = [
    Product(
      name: 'Mechanical Keyboard',
      brand: 'Logitech',
      image: 'https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWVjaGFuaWNhbCUyMGtleWJvYXJkfGVufDB8fDB8fHww',
      price: 850000,
    ),
    Product(
      name: 'Wireless Mouse',
      brand: 'Logitech',
      image: 'https://images.unsplash.com/photo-1618499890638-3a0dd4b278b7?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8d2lyZWxlc3MlMjBtb3VzZSUyMGxvZ2l0ZWNofGVufDB8fDB8fHww',
      price: 450000,
    ),
    Product(
      name: 'Gaming Headset',
      brand: 'HyperX',
      image: 'https://images.unsplash.com/photo-1660391532247-4a8ad1060817?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Z2FtaW5nJTIwaGVhZHNldCUyMGh5cGVyeHxlbnwwfHwwfHx8MA%3D%3D',
      price: 1200000,
    ),
  ];

  // DATA
  final quantity = [0, 0, 0];
  final likes = [0, 0, 0];
  final isLiked = [false, false, false];

  int? selectedProduct;

  // FORMAT HARGA
  String rupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
  }

  // TOTAL BARANG
  int get totalItems {
    return quantity.reduce((a, b) => a + b);
  }

  // TOTAL HARGA
  int get totalPrice {
    int total = 0;

    for (int i = 0; i < products.length; i++) {
      total += products[i].price * quantity[i];
    }

    return total;
  }

  // LIKE / UNLIKE
  void toggleLike(int index) {
    setState(() {
      isLiked[index] = !isLiked[index];

      if (isLiked[index]) {
        likes[index]++;
      } else {
        likes[index]--;
      }
    });
  }

  // INFORMASI PRODUK
  void showInfo(int index) {
    final product = products[index];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} - ${rupiah(product.price)}')),
    );
  }

  // PILIH PRODUK
  void selectProduct(int index) {
    setState(() {
      selectedProduct = index;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${products[index].name} dipilih'),
        duration: const Duration(milliseconds: 700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Shopping',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Belanja lebih mudah setiap hari',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),

      // PRODUK
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return productCard(index);
              },
            ),
          ),

          // TOTAL & CHECKOUT
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total ($totalItems produk)',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        rupiah(totalPrice),
                        style: const TextStyle(
                          color: Color(0xFF0D47A1),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          totalItems == 0
                              ? 'Belum ada produk yang dipilih'
                              : 'Checkout $totalItems produk - '
                                    '${rupiah(totalPrice)}',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0D47A1),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Kategori',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
      ),
    );
  }

  // PRODUCT CARD
  Widget productCard(int indeks) {
    final product = products[indeks];

    return GestureDetector(
      // ONE TAP
      onTap: () => selectProduct(indeks),

      // DOUBLE TAP
      onDoubleTap: () => toggleLike(indeks),

      // LONG PRESS
      onLongPress: () => showInfo(indeks),

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selectedProduct == indeks ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // GAMBAR
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    width: 80,
                    height: 80,
                    child: Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),

            const SizedBox(width: 10),

            // INFORMASI
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(
                    product.brand,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                  Text(
                    rupiah(product.price),
                    style: const TextStyle(
                      color: Color(0xFF0D47A1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      // LIKE
                      GestureDetector(
                        onTap: () => toggleLike(indeks),
                        child: Icon(
                          isLiked[indeks]
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isLiked[indeks] ? Colors.red : Colors.grey,
                          size: 19,
                        ),
                      ),

                      const SizedBox(width: 4),

                      Text(
                        '${likes[indeks]}',
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const Spacer(),

                      // MINUS
                      IconButton(
                        onPressed: quantity[indeks] > 0
                            ? () {
                                setState(() {
                                  quantity[indeks]--;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove),
                        iconSize: 18,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                      ),

                      Text(
                        '${quantity[indeks]}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      // PLUS
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity[indeks]++;
                          });
                        },
                        icon: const Icon(Icons.add),
                        iconSize: 18,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
