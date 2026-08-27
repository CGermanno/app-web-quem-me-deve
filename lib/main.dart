import 'package:conta_facil/features/expenses/data/db.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/ads.dart';
import 'core/notifications.dart';
import 'package:intl/date_symbol_data_local.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.init();
  await initAds();
  await initNotifications();
  await initializeDateFormatting('pt_BR', null);
  runApp(const MyApp());
}