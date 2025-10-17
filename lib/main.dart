import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t_store_admin_panel/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:t_store_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:t_store_admin_panel/firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//Flutter App Entry Point
Future<void> main() async {
  //Ensure the widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  //.env file
  await dotenv.load(fileName: ".env");

  //initialize GetX Local Storage
  await GetStorage.init();

  //Remove # sign from url
  setPathUrlStrategy();

  //Initialize Firebase & Authentication Repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((_) {
    if (kIsWeb) {
      FirebaseFirestore.instance.enableNetwork();
    }
    Get.put(AuthenticationRepository());
  });

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      headers: {'Authorization': 'Bearer ${dotenv.env['SUPABASE_SERVICE_KEY']}'},
      storageOptions: const StorageClientOptions(retryAttempts: 3),
    );
  } catch (e, st) {
    debugPrint("🔥 Supabase init failed: $e\n$st");
  }

  //Main App starts here...
  runApp(const MyApp());
}
