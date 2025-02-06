import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic product;
  final Function(dynamic) addToCart;

  ProductDetailsScreen({required this.product, required this.addToCart});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1; // Default quantity

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvifImage.network(
              widget.product['productImage'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16),
            Text(
              widget.product['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '\$${widget.product['price'].toString()}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 16),
            Text(
              widget.product['description'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Quantity Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: decreaseQuantity,
                  icon: Icon(Icons.remove),
                ),
                Text(
                  quantity.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: increaseQuantity,
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                widget.addToCart({...widget.product, 'quantity': quantity});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added $quantity to cart!')),
                );
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
