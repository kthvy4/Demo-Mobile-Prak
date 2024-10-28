import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Request permission untuk iOS (jika diperlukan)
    await _firebaseMessaging.requestPermission();

    // Inisialisasi pengaturan notifikasi lokal
    const androidInitialization = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: androidInitialization,
    );

    // Inisialisasi plugin notifikasi lokal dengan callback saat notifikasi diklik
    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Handle notifikasi saat aplikasi berada di Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    // Set background message handler untuk kondisi Background dan Terminated
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Fungsi untuk menampilkan notifikasi lokal
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id', 'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: 'navigate_to_notification',  // Menambahkan payload untuk navigasi
    );
  }

  // Fungsi untuk menangani klik notifikasi
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    // Cek payload untuk navigasi ke halaman yang sesuai
    if (response.payload == 'navigate_to_notification') {
      Get.toNamed('/notification');  // Arahkan ke halaman notification.dart
    }
  }
}

// Fungsi untuk menangani notifikasi yang diterima di Background dan Terminated
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
