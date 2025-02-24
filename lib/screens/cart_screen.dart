import 'package:ecommerce_app/screens/checkout_screen.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';

class CartScreen extends StatefulWidget {
  final List<dynamic> cart;
  final List<dynamic> productsId;
  final String userId;
  final int quantity;

  const CartScreen(
      {super.key,
      required this.cart,
      required this.productsId,
      required this.userId,
      required this.quantity});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late int changedQuantity;
  void initializeQuantity() {
    changedQuantity = widget.quantity;
  }

  void increaseQuantity(int index) {
    setState(() {
      changedQuantity++;

      widget.cart[index]['quantity']++;
    });
  }

  void decreaseQuantity(int index) {
    if (widget.cart[index]['quantity'] > 1) {
      setState(() {
        changedQuantity--;
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
  void initState() {
    // TODO: implement initState
    initializeQuantity();
    super.initState();
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
                    Text('$changedQuantity'),
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
          onPressed: () async {
            final cartData = {
              "userId": widget.userId,
              "products": {
                "productId": widget.productsId,
                "quantity": changedQuantity
              },
            };
            print("QUANTITY: $changedQuantity");
            print("CARTDATA: $cartData");
            await ApiService().placeCart(cartData);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutScreen(
                  cart: widget.cart,
                  productsId: widget.productsId,
                  userName: "John Doe",
                  // userAddress: "123 Main St, New York, NY",
                ),
              ),
            );
          },
          child: Text('Proceed to Checkout'),
        ),
      ),
    );
  }
}
// import 'package:ecommerce_app/screens/checkout_screen.dart';
// import 'package:ecommerce_app/services/api_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_avif/flutter_avif.dart';

// class CartScreen extends StatelessWidget {
//   final List<dynamic> cart;
//   final List<dynamic> productsId;
//   // final cartData={
//   //   "userId":"679e36f2cb81bae5f1eb5309",
//   //   "productId":productsId;
//   // };

//   CartScreen({required this.cart, required this.productsId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cart'),
//       ),
//       body: ListView.builder(
//         itemCount: cart.length,
//         itemBuilder: (context, index) {
//           final product = cart[index];
//           return ListTile(
//             // leading:
//             // Image.network(
//             //   product['image'],
//             //   width: 50,
//             //   height: 50,
//             //   fit: BoxFit.cover,
//             // ),
//             leading: AvifImage.network(
//               product['productImage'],
//               height: 50,
//               width: 50,
//               fit: BoxFit.cover,
//             ),
//             title: Text(product['name']),
//             subtitle: Text('\$${product['price'].toString()}'),
//             trailing: IconButton(
//               icon: Icon(Icons.remove_circle),
//               onPressed: () {
//                 // Remove from cart logic
//               },
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ElevatedButton(
//           onPressed: () {
//             final cartData = {
//               // "userId": "679e36f2cb81bae5f1eb5309",
//               "productId": productsId,
//             };
//             ApiService().placeCart(cartData);

//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     CheckoutScreen(cart: cart, productsId: productsId),
//               ),
//             );
//           },
//           child: Text('Proceed to Checkout'),
//         ),
//       ),
//     );
//   }
// }
