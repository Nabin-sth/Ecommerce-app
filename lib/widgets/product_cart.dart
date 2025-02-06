import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';

class ProductCard extends StatelessWidget {
  final dynamic product;
  final VoidCallback onTap;

  ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.network(
            // product['productImage'],
            //   "https://res.cloudinary.com/dvop7f7rj/image/upload/v1738337795/d9baficdpv95cpa1lke7.jpg",
            //   height: 120,
            //   width: double.infinity,
            //   fit: BoxFit.cover,
            // ),
            AvifImage.network(
              product['productImage'],
              height: 120,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('\$${product['price'].toString()}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
