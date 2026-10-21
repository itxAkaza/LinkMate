import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:linkvault/resources/route/routes.dart';
import 'package:linkvault/resources/route/routes_names.dart';
import 'package:linkvault/services/hive/hive_registrar.g.dart';
import 'package:linkvault/services/notification/notification_service.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'model/link_model.dart';

// ... your other imports ...

final notificationService = NotificationServices();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();
  await Hive.initFlutter();

  Hive.registerAdapters();

  await Hive.openBox<LinkItem>('links_box');
  await Hive.openBox<List<String>>('categories_box');
  final settingsBox = await Hive.openBox('settings_box');
  final bool isNotifEnabled = settingsBox.get('notifications_enabled', defaultValue: true) as bool;
  await notificationService.initNotification(isNotifEnabled);


  runApp(
    LiquidGlassWidgets.wrap(
      child: const MyApp(),
      brightnessResolver: Theme.maybeBrightnessOf,

      // Define your custom glow colors globally here
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

// ... rest of your MyApp class ...

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Liquid Glass Navigation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark), // Or Light, based on your app
      initialRoute: RoutesNames.mainHome, // Sets the initial route
      getPages: AppRoutes.appRoutes(),    // Loads the routes
    );
  }
}