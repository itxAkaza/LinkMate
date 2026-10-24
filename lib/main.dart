import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:linkvault/resources/route/routes.dart';
import 'package:linkvault/resources/route/routes_names.dart';
import 'package:linkvault/services/hive/hive_registrar.g.dart';
import 'package:linkvault/services/notification/notification_service.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'model/link_model.dart';

final notificationService = NotificationServices();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();
  await Hive.initFlutter();

  Hive.registerAdapters();

  await Hive.openBox<LinkItem>('links_box');
  await Hive.openBox<List<String>>('categories_box');
  final settingsBox = await Hive.openBox('settings_box');

  // 1. Check Notification Setting
  final bool isNotifEnabled =
  settingsBox.get('notifications_enabled', defaultValue: true) as bool;
  await notificationService.initNotification(isNotifEnabled);

  // 2. Check Onboarding Completed Flag
  final bool isOnboardingDone =
  settingsBox.get('onboarding_completed', defaultValue: false) as bool;

  runApp(
    LiquidGlassWidgets.wrap(
      child: MyApp(isOnboardingDone: isOnboardingDone),
      brightnessResolver: Theme.maybeBrightnessOf,
      theme: const GlassThemeData(
        light: GlassThemeVariant(
          glowColors: GlassGlowColors(
            primary: Colors.blueAccent,
            glowOpacity: 0.6,
          ),
        ),
        dark: GlassThemeVariant(
          glowColors: GlassGlowColors(
            primary: Colors.blueAccent,
            glowOpacity: 0.6,
          ),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isOnboardingDone;

  const MyApp({super.key, required this.isOnboardingDone});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LinkMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      // 3. Dynamically route to MainHome or Onboarding on boot!
      initialRoute: isOnboardingDone
          ? RoutesNames.mainHome
          : RoutesNames.onboarding,
      getPages: AppRoutes.appRoutes(),
    );
  }
}