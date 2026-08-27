import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

final _plugin = FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  tz.initializeTimeZones();
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  await _plugin.initialize(const InitializationSettings(android: android));
}

Future<void> checkMonthlyLimitAndNotify(double totalBRL) async {
  final prefs = await SharedPreferences.getInstance();
  final limitCents = prefs.getInt('limit_cents') ?? 0;
  if (limitCents == 0) return;
  if ((totalBRL * 100).round() >= limitCents) {
    await _plugin.show(
      1,
      'Atenção ao limite',
      'Você atingiu o limite mensal de gastos.',
      const NotificationDetails(
        android: AndroidNotificationDetails('limit','Limite'),
      ),
    );
  }
}

Future<void> scheduleDailyLimitCheck() async {
  await _plugin.zonedSchedule(
    2,
    'Resumo diário',
    'Veja como estão seus gastos do mês.',
    tz.TZDateTime.now(tz.local).add(const Duration(hours: 24)),
    const NotificationDetails(
      android: AndroidNotificationDetails('daily','Diário'),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}
