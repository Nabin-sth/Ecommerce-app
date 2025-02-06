import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CheckoutScreen extends StatelessWidget {
  final List<dynamic> cart;
  final List<dynamic> productsId;

  CheckoutScreen({required this.cart,required this.productsId});

  Future<void> _makePayment(BuildContext context) async {
    try {
      final totalAmount =
          (cart.fold<num>(0, (sum, item) => sum + (item['price'] as num)) * 100)
              .toInt();
      print(totalAmount);

      // Step 1: Fetch payment intent from your backend
      final response = await ApiService().createPaymentIntent({
        'amount': totalAmount, // Amount in cents
        'currency': 'usd',
      });
      print("Stripe Response: $response");

      if (!response.containsKey('clientSecret')) {
        throw Exception('Invalid Stripe response: missing clientSecret');
      }
      print("step1");
      // print(cart);
      // print(cart[0]["_id"]);

      // Step 2: Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: response['clientSecret'],
          merchantDisplayName: 'ECommerce App',
          billingDetails: BillingDetails(
            email: 'customer@example.com', // Optional but recommended
          ),
        ),
      );
      print("step 2");

      // Step 3: Display payment sheet
      await Stripe.instance.presentPaymentSheet();
      print("step3");

      // Step 4: Place order
      // final cartData = {
      //   "userId": "679e36f2cb81bae5f1eb5309",
      //   'orderItems': productsId,
      //   'orderPrice': totalAmount,
      // };
      // print(cartData);
      // await ApiService().placeOrder(cartData);
      print("step4");

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment successful!')),
      );
    } catch (e) {
      print('Payment failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final total =
        cart.fold<num>(0, (sum, item) => sum + (item['price'] as num)).toInt();

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final product = cart[index];
          return ListTile(
            // leading: Image.network(
            //   product['image'],
            //   width: 50,
            //   height: 50,
            //   fit: BoxFit.cover,
            // ),
            leading: AvifImage.network(
              product['productImage'],
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            title: Text(product['name']),
            subtitle: Text('\$${product['price'].toString()}'),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _makePayment(context), // Pass context here
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
