// register_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String address,
    required BuildContext context,
  }) async {
    try {
      // Firebase registration using email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user details to Firestore
      await _firestore.collection('Profile').doc(userCredential.user?.uid).set({
        'Email': email,
        'Nama': name,
        'No telepon': phone,
        'alamat': address,
        'password': password,
      });

      // Navigate to Login page after successful registration
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
