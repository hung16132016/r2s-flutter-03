import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r2s_dart_project/product_widget.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _buildHomePage(),
    );
  }

  Widget _buildHomePage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: const Column(
        children: [
          ProductWidget(
            imagePath: 'images/products/iphone.jpeg',
            name: 'iPhone',
            description: 'iPhone 2024',
            price: 2000,
          ),
          ProductWidget(
            imagePath: 'images/products/samsung.jpg',
            name: 'Samsung',
            description: 'Samsung Galaxy',
            price: 5000,
          ),
          ProductWidget(
            imagePath: 'images/products/tablet.jpeg',
            name: 'iPad',
            description: 'iPad 2024',
            price: 1000,
          ),
        ],
      ),
    );
  }
}
