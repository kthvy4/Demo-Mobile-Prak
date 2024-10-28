import 'package:demo_mobile/app/modules/notifikasi/notification_handler.dart';
import 'package:demo_mobile/app/routes/app_pages.dart';
import 'package:demo_mobile/app/routes/app_routes.dart';
import 'package:demo_mobile/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/notifikasi/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi notifikasi service
  NotificationService();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CatCare App',
      initialRoute: AppRoutes.LOGIN,
      getPages: AppPages.pages,
    );
  }
}
