import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.8:8000/api/v1';

  Future<Map<String, dynamic>> createPaymentIntent(
      Map<String, dynamic> data) async {
    print(data);
    final response = await http.post(
      // Uri.parse('$baseUrl/create-payment-intent'),
      Uri.parse('http://192.168.1.8:5000/create-payment-intent'),

      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create PaymentIntent');
    }
  }

  // Fetch all products
  Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/user/products'));
    if (response.statusCode == 200) {
      print(response.body);

      final Map<String, dynamic> responseBody = json.decode(response.body);
      // Assuming the list of products is under the 'data' key
      return responseBody['message'];
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch product details
  Future<dynamic> getProductDetails(String productId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/user/products/$productId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<dynamic> placeCart(Map<String, dynamic> cartData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/cart'),
      // Uri.parse('http://192.168.1.8:5000/orders'),

      headers: {'Content-Type': 'application/json'},
      body: json.encode(cartData),
    );
    print(response.body);

    if (response.statusCode == 201) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to place cart');
    }
  }

  // Place an order
  Future<dynamic> placeOrder(Map<String, dynamic> orderData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/order'),
      // Uri.parse('http://192.168.1.8:5000/orders'),

      headers: {'Content-Type': 'application/json'},
      body: json.encode(orderData),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to place order');
    }
  }

  // Fetch order history
  Future<List<dynamic>> getOrderHistory() async {
    final response = await http.get(Uri.parse('$baseUrl/user/order'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load order history');
    }
  }
}
