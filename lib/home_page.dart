import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_product_page.dart';
import 'login_page.dart';

class Product {
  final String name;
  final double price;

  Product(this.name, this.price);

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
      };

  static Product fromJson(Map<String, dynamic> json) {
    return Product(json['name'], json['price']);
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _products = [];
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    setState(() => _isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? productList = prefs.getStringList('products');

    if (productList != null) {
      _products = productList.map((item) {
        final parts = item.split(',');
        return Product(parts[0], double.tryParse(parts[1]) ?? 0);
      }).toList();
    }
    setState(() => _isLoading = false);
  }

  void _deleteProduct(int index) async {
    _products.removeAt(index);
    await _saveProducts();
  }

  void _searchProducts(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  Future<void> _saveProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productList = _products.map((product) {
      return '${product.name},${product.price}';
    }).toList();
    await prefs.setStringList('products', productList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TextField(
                  onChanged: _searchProducts,
                  decoration: InputDecoration(
                    labelText: 'Search Products',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                Expanded(
                  child: _products.isEmpty
                      ? Center(child: Text('No Products Found'))
                      : ListView.builder(
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            if (_products[index]
                                .name
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase())) {
                              return ListTile(
                                title: Text(_products[index].name),
                                subtitle: Text('\$${_products[index].price}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _deleteProduct(index),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddProductPage(
              onProductAdded: () {
                _loadProducts();
              },
            ),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddProductPage extends StatefulWidget {
  final Function onProductAdded;

  AddProductPage({required this.onProductAdded});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _addProduct() {
    final String name = _nameController.text;
    final String priceText = _priceController.text;
    if (name.isNotEmpty && priceText.isNotEmpty) {
      final double? price = double.tryParse(priceText);
      if (price != null) {
        final product = Product(name, price);
        // Save product logic here
        widget.onProductAdded();
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
