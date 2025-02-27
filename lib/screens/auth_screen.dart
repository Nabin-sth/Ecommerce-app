// import 'package:ecommerce_app/screens/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class AuthScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login / Register'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             LoginForm(),
//             SizedBox(height: 20),
//             RegisterForm(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class LoginForm extends StatefulWidget {
//   @override
//   _LoginFormState createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       final response = await http.post(
//         Uri.parse('http://192.168.1.8:8000/api/v1/user/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'email': _emailController.text,
//           'password': _passwordController.text,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final userId = data["message"]["userID"];
//         print(userId);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Login successful!')),
//         );
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomeScreen(),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Login failed!')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Text(
//                 'Login',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your password';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: _login,
//                 child: Text('Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class RegisterForm extends StatefulWidget {
//   @override
//   _RegisterFormState createState() => _RegisterFormState();
// }

// class _RegisterFormState extends State<RegisterForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   String _selectedRole = 'USER'; // Default role

//   Future<void> _register() async {
//     if (_formKey.currentState!.validate()) {
//       final response = await http.post(
//         Uri.parse('http://192.168.1.8:8000/api/v1/user/register'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'fullName': _fullNameController.text,
//           'email': _emailController.text,
//           'username': _usernameController.text,
//           'password': _passwordController.text,
//           'role': _selectedRole,
//         }),
//       );

//       if (response.statusCode == 201) {
//         final data = json.decode(response.body);
//         final token = data['token']; // Assuming your API returns a JWT token
//         print('Registration successful! Token: $token');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Registration successful!')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Registration failed!')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Text(
//                 'Register',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               // Full Name Field
//               TextFormField(
//                 controller: _fullNameController,
//                 decoration: InputDecoration(labelText: 'Full Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your full name';
//                   }
//                   return null;
//                 },
//               ),
//               // Email Field
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   if (!value.contains('@')) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               // Username Field
//               TextFormField(
//                 controller: _usernameController,
//                 decoration: InputDecoration(labelText: 'Username'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a username';
//                   }
//                   return null;
//                 },
//               ),
//               // Password Field
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a password';
//                   }
//                   if (value.length < 6) {
//                     return 'Password must be at least 6 characters';
//                   }
//                   return null;
//                 },
//               ),
//               // Role Dropdown
//               DropdownButtonFormField<String>(
//                 value: _selectedRole,
//                 decoration: InputDecoration(labelText: 'Role'),
//                 items: ['USER', 'ADMIN', 'VENDOR']
//                     .map((role) => DropdownMenuItem(
//                           value: role,
//                           child: Text(role),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedRole = value!;
//                   });
//                 },
//               ),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: _register,
//                 child: Text('Register'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
