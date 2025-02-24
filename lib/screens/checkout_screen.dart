import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CheckoutScreen extends StatefulWidget {
  final List<dynamic> cart;
  final List<dynamic> productsId;
  final String userName;

  const CheckoutScreen({
    super.key,
    required this.cart,
    required this.productsId,
    required this.userName,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Mapping of cities to areas
  final Map<String, List<String>> cityAreas = {
    "Kathmandu": ["Thamel", "Baneshwor", "Pulchowk", "Maharajgunj", "Kalanki"],
    "Pokhara": ["Lakeside", "New Road", "Mahendrapul", "Chipledhunga"],
    "Chitwan": ["Bharatpur", "Narayangarh", "Ratnanagar", "Tandi"],
    "Biratnagar": ["Main Road", "Birat Chowk", "Shankharpur", "Jatuwa"],
  };

  // Default selections
  String selectedCity = "Kathmandu";
  String selectedArea = "Thamel";

  @override
  void initState() {
    super.initState();
    selectedArea = cityAreas[selectedCity]![0]; // Default area based on city
  }

  Future<void> _makePayment(BuildContext context) async {
    try {
      final totalAmount = (widget.cart.fold<num>(
                  0,
                  (sum, item) =>
                      sum +
                      ((item['price'] as num) * (item['quantity'] as int))) *
              100)
          .toInt(); // Convert to cents

      final response = await ApiService().createPaymentIntent({
        'amount': totalAmount,
        'currency': 'usd',
      });

      if (!response.containsKey('clientSecret')) {
        throw Exception('Invalid Stripe response: missing clientSecret');
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: response['clientSecret'],
          merchantDisplayName: 'ECommerce App',
          billingDetails: BillingDetails(
            email: 'customer@example.com',
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      // Final full address
      String fullAddress = "$selectedArea, $selectedCity";

      // Include user details and selected address in the order
      final orderData = {
        "phone": "9844782893",
        "customer": widget.userName,
        "userAddress": fullAddress,
        "orderItems": widget.productsId,
        "totalPrice": totalAmount,
      };
      // await ApiService().placeOrder(orderData);

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
    final total = widget.cart
        .fold<num>(
          0,
          (sum, item) =>
              sum + ((item['price'] as num) * (item['quantity'] as int)),
        )
        .toInt(); // Total price considering quantity

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${widget.userName}',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),

                // City Dropdown
                Text('Select City:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectedCity,
                  isExpanded: true,
                  items: cityAreas.keys.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (String? newCity) {
                    if (newCity != null) {
                      setState(() {
                        selectedCity = newCity;
                        selectedArea = cityAreas[newCity]![0]; // Reset area
                      });
                    }
                  },
                ),

                SizedBox(height: 8),

                // Area Dropdown
                Text('Select Area:',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectedArea,
                  isExpanded: true,
                  items: cityAreas[selectedCity]!.map((String area) {
                    return DropdownMenuItem<String>(
                      value: area,
                      child: Text(area),
                    );
                  }).toList(),
                  onChanged: (String? newArea) {
                    if (newArea != null) {
                      setState(() {
                        selectedArea = newArea;
                      });
                    }
                  },
                ),

                SizedBox(height: 16),
                Text("Selected Address: $selectedArea, $selectedCity",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                      Text('Quantity: ${product['quantity']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
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
              onPressed: () => _makePayment(context),
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
