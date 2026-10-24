import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  // 1. Run LiquidGlass shader init and Hive storage init in PARALLEL
  await Future.wait([
    LiquidGlassWidgets.initialize(),
    Hive.initFlutter(),
  ]);

  Hive.registerAdapters();

  // 2. Open all 3 Hive boxes in PARALLEL (1 disk wait instead of 3)
  final results = await Future.wait([
    Hive.openBox<LinkItem>('links_box'),
    Hive.openBox<List<String>>('categories_box'),
    Hive.openBox('settings_box'),
  ]);

  final Box settingsBox = results[2];

  // 3. Read flags synchronously (0ms)
  final bool isNotifEnabled =
  settingsBox.get('notifications_enabled', defaultValue: true) as bool;
  final bool isOnboardingDone =
  settingsBox.get('onboarding_completed', defaultValue: false) as bool;

  // 4. Render the UI immediately!
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

  // 5. Initialize Timezones & Notifications AFTER the first frame renders
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(notificationService.initNotification(isNotifEnabled));
  });
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
      initialRoute: isOnboardingDone
          ? RoutesNames.mainHome
          : RoutesNames.onboarding,
      getPages: AppRoutes.appRoutes(),
    );
  }
}