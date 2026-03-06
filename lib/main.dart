import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiffinmate/app/app.dart';
import 'package:tiffinmate/core/services/hive/hive_service.dart';
import 'package:tiffinmate/core/services/storage/user_session.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure Hive is initialized and boxes are open before starting the app to avoid races
  await HiveService().init();

  final sharedPrefs = await SharedPreferences.getInstance();

  
  runApp(ProviderScope(overrides:[
    sharedPreferencesProvider.overrideWithValue(sharedPrefs)
  ],child: App()));
}

