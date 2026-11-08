import 'package:app_settings/app_settings.dart';
import 'package:get/get.dart';

import '../../Utiles/app_haptic.dart';
import '../../Utiles/utiles.dart';
import '../../data/repositories/link_repository.dart';
import '../../main.dart';
import '../../screens/privateVault/forgot_pin_warning_screen.dart';
import '../../screens/privateVault/vault_pin_screen.dart';


class SettingsController extends GetxController {
  final LinkRepository _repository = LinkRepository();

  final RxBool notificationsEnabled = true.obs;
  final RxBool hasPinConfigured = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshState();
  }

  void refreshState() {
    notificationsEnabled.value = _repository.areNotificationsEnabled();
    hasPinConfigured.value = _repository.hasVaultPin();
  }

  Future<void> toggleNotifications(bool value) async {
    AppHaptics.lightTap();

    if (value) {
      final granted = await notificationService.requestAndCheckPermissions();
      if (!granted) {
        notificationsEnabled.value = false;
        await _repository.setNotificationsEnabled(false);
        Utils.showErrorToast("Please allow notifications in device settings.");
        await AppSettings.openAppSettings(type: AppSettingsType.notification);
        return;
      }

      notificationsEnabled.value = true;
      await _repository.setNotificationsEnabled(true);
      await notificationService.handleSettingsToggle(true);

    } else {
      notificationsEnabled.value = false;
      await _repository.setNotificationsEnabled(false);
      await notificationService.handleSettingsToggle(false);

    }
  }

  Future<void> manageVaultPin() async {
    AppHaptics.lightTap();
    if (hasPinConfigured.value) {
      await Get.to(() => const VaultPinScreen(mode: PinScreenMode.change));
    } else {
      await Get.to(() => const VaultPinScreen(mode: PinScreenMode.setup));
    }
    refreshState();
  }

  Future<void> openResetPinFlow() async {
    AppHaptics.lightTap();
    await Get.to(() => const ForgotPinWarningScreen());
    refreshState();
  }
}