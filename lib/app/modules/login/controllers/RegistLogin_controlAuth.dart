import 'package:demo_mobile/app/modules/login/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  // Fungsi untuk registrasi pengguna
  Future<void> registerUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar(
        'Success',
        'Registration successful',
        backgroundColor: Colors.green,
      );
      Get.off(LoginView()); // Beralih ke halaman Login setelah registrasi berhasil
    } catch (error) {
      Get.snackbar(
        'Error',
        'Registration failed: $error',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk login pengguna
  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar(
        'Success',
        'Login successful',
        backgroundColor: Colors.green,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Login failed: $error',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk logout pengguna
  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      Get.snackbar(
        'Success',
        'Logout successful',
        backgroundColor: Colors.green,
      );
      Get.offAll(LoginView()); // Beralih ke halaman Login setelah logout
    } catch (error) {
      Get.snackbar(
        'Error',
        'Logout failed: $error',
        backgroundColor: Colors.red,
      );
    }
  }
}
