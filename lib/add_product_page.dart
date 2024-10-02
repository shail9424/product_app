import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String selectedImage = '';

  final List<String> imageAssets = [
    'assets/banana.jpg',
    'assets/chiku.jpg',
    'assets/jugs.jpg',
    'assets/watch.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            // drop button
            DropdownButton<String>(
              hint: Text("Select Image"),
              value: selectedImage,
              items: imageAssets.map((String image) {
                return DropdownMenuItem<String>(
                  value: image,
                  child: Row(
                    children: [
                      Image.asset(image, width: 50, height: 50),
                      SizedBox(width: 10),
                      Text(image.split('/').last), // here image dispay
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedImage = newValue!;
                });
              },
            ),
            if (selectedImage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  selectedImage,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addProduct,
              child: Text("Add Product"),
            ),
          ],
        ),
      ),
    );
  }

  void addProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedImage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Name, Price, and Image are required.")));
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> products = prefs.getStringList('products') ?? [];

    // string of product
    String product =
        '${nameController.text},${priceController.text},$selectedImage';
    if (!products.contains(product)) {
      products.add(product);
      await prefs.setStringList('products', products);
      Navigator.pop(context); // here retun to privious screen
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Product already exists.")));
    }
  }
}
