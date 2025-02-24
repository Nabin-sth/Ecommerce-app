import 'package:ecommerce_app/screens/home_screen.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
// import "login_screen.dart"

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51QnY5tIpASCS1r2QsKCUjbgvysLKfif9aViNjfFoCo9nlcPGMaKjWhHvdqEgel0oOi9rjgWSjSNZbxHkf7LXWnT500OCKGJuxo';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECommerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(
        // userId: '679e36f2cb81bae5f1eb5309',
        // 679e36f2cb81bae5f1eb5309
      ),
    );
  }
}
