// home_screen.dart
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/screens/product_details_screen.dart';
import 'package:ecommerce_app/widgets/product_cart.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> products = [];
  List<dynamic> cart = [];
  List<dynamic> productsId = [];
  bool isLoading = true;
  late int quantity;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final data = await ApiService().getProducts();
      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void addToCart(dynamic product, int cartQuantity) {
    productsId.add(product["_id"]);
    setState(() {
      cart.add(product);
      quantity = cartQuantity;
    });
    print("home screen quantity: $quantity");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ECommerce App',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
        backgroundColor: Colors.deepPurple,
        actions: [
          Badge(
            label: Text(cart.length.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                      cart: cart,
                      productsId: productsId,
                      userId: widget.userId,
                      quantity: quantity,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
                strokeWidth: 3,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: products[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            product: products[index],
                            addToCart: addToCart,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}

// import 'package:ecommerce_app/screens/cart_screen.dart';
// import 'package:ecommerce_app/screens/product_details_screen.dart';
// import 'package:ecommerce_app/widgets/product_cart.dart';
// import 'package:flutter/material.dart';
// import 'package:ecommerce_app/services/api_service.dart';

// class HomeScreen extends StatefulWidget {
//   final String userId;

//   const HomeScreen({super.key, required this.userId});
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<dynamic> products = [];
//   List<dynamic> cart = []; // Cart list
//   List<dynamic> productsId = [];
//   bool isLoading = true;
//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//   }

//   Future<void> fetchProducts() async {
//     try {
//       final data = await ApiService().getProducts();
//       setState(() {
//         products = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching products: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void addToCart(dynamic product) {
//     // print(product);

//     // print(product["_id"]);
//     productsId.add(product["_id"]);

//     setState(() {
//       cart.add(product);
//     });
//     print("Cart data: $cart");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ECommerce App'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.shopping_cart),
//             onPressed: () {
//               print(productsId);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CartScreen(
//                       cart: cart,
//                       productsId: productsId,
//                       userId: widget.userId),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.7,
//               ),
//               itemCount: products.length,
//               itemBuilder: (context, index) {
//                 return ProductCard(
//                   product: products[index],
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ProductDetailsScreen(
//                           product: products[index],
//                           addToCart: addToCart,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }
