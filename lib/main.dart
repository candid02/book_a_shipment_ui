// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipping_app/app/routes/app_pages.dart';
import 'services/api_service.dart';

void main() {
  // Initialize dependencies
  initServices();
  runApp(const MyApp());
}

// Initialize services
Future<void> initServices() async {
  // Register the API service
  Get.put(ApiService(), permanent: true);
  
  // Print success message
  debugPrint('All services initialized.');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shipping App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
       initialRoute: AppPages.initial, // Use AppPages.initial
      getPages: AppPages.routes, // Use AppPages.routes
    );
  }
}