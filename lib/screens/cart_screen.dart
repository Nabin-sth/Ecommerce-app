import 'package:ecommerce_app/screens/checkout_screen.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';

class CartScreen extends StatefulWidget {
  final List<dynamic> cart;
  final List<dynamic> productsId;

  CartScreen({required this.cart, required this.productsId});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void increaseQuantity(int index) {
    setState(() {
      widget.cart[index]['quantity']++;
    });
  }

  void decreaseQuantity(int index) {
    if (widget.cart[index]['quantity'] > 1) {
      setState(() {
        widget.cart[index]['quantity']--;
      });
    }
  }

  void removeFromCart(int index) {
    setState(() {
      widget.cart.removeAt(index);
      widget.productsId.removeAt(index); // Remove the productId as well
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: widget.cart.length,
        itemBuilder: (context, index) {
          final product = widget.cart[index];
          return ListTile(
            leading: AvifImage.network(
              product['productImage'],
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            title: Text(product['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('\$${product['price'].toString()}'),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => decreaseQuantity(index),
                    ),
                    Text('${product['quantity']}'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => increaseQuantity(index),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () => removeFromCart(index),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            final cartData = {
              "productId": widget.productsId,
            };
            ApiService().placeCart(cartData);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutScreen(
                    cart: widget.cart, productsId: widget.productsId),
              ),
            );
          },
          child: Text('Proceed to Checkout'),
        ),
      ),
    );
  }
}
