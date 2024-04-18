import 'package:echoes/src/api/pocketbase.dart';
import 'package:echoes/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final authStore = AsyncAuthStore(
    save: (String data) async => prefs.setString('pb_auth', data),
    initial: prefs.getString('pb_auth'),
  );
  // final pocketBaseClient = PocketBase("http://127.0.0.1:8090", authStore: authStore);
  final pocketBaseClient = PocketBase("https://nathan-poncet.pockethost.io/", authStore: authStore);

  final container = ProviderContainer(overrides: [
    pocketBaseProvider.overrideWithValue(pocketBaseClient),
  ]);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}
