import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../Utiles/app_haptic.dart';
import '../../controllers/home/homeController.dart';
import '../../data/repositories/link_repository.dart';
import '../../model/link_model.dart';
import '../../resources/colors/app_colors.dart';
import '../home/detail/linkDetail_screen.dart';
import '../home/widgets/linkBottomSheet.dart';
import '../home/widgets/linkCard.dart';

class PrivateVaultController extends GetxController {
  final LinkRepository _repository = LinkRepository();
  final RxBool isGridView = false.obs;

  @override
  void onInit() {
    super.onInit();
    isGridView.value = _repository.getGridViewState('private_vault');
  }

  void toggleViewMode() {
    AppHaptics.lightTap();
    isGridView.value = !isGridView.value;
    _repository.saveGridViewState('private_vault', isGridView.value);
  }
}

class PrivateVaultScreen extends StatelessWidget {
  const PrivateVaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vaultController = Get.isRegistered<PrivateVaultController>()
        ? Get.find<PrivateVaultController>()
        : Get.put(PrivateVaultController(), permanent: true);

    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController(), permanent: true);

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppColors.readOnlyBg,
      appBar: AppBar(
        backgroundColor: AppColors.readOnlyBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textColorBlack),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Private Vault",
              style: GoogleFonts.manrope(
                color: AppColors.textColorBlack,
                fontWeight: FontWeight.w800,
                fontSize: 19,
              ),
            ),
            Text(
              "Secured with 4-digit PIN lock",
              style: GoogleFonts.manrope(
                color: AppColors.subTitleColorGary,
                fontWeight: FontWeight.w500,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
        actions: [
          Obx(
                () => IconButton(
              icon: Icon(
                vaultController.isGridView.value
                    ? LucideIcons.layoutList
                    : LucideIcons.layoutGrid,
                color: AppColors.iconBlue,
                size: 20,
              ),
              onPressed: vaultController.toggleViewMode,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ValueListenableBuilder<Box<LinkItem>>(
        valueListenable: homeController.listenableBox,
        builder: (context, box, _) {
          final privateLinks = box.values
              .where((item) => item.isPrivate)
              .toList()
              .reversed
              .toList();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Top Status Row: Protected Pill + Link Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.iconBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.iconBlue.withOpacity(0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.lock, size: 13, color: AppColors.iconBlue),
                          const SizedBox(width: 6),
                          Text(
                            "PIN Protected Vault",
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.iconBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "${privateLinks.length} ${privateLinks.length == 1 ? 'link' : 'links'}",
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.subTitleColorGary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Expanded(
                  child: privateLinks.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.iconBlue.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.shieldCheck,
                            size: 36,
                            color: AppColors.iconBlue,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          "Your Private Vault is empty",
                          style: GoogleFonts.manrope(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textColorBlack,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Toggle 'Save to Private Vault' when adding a link.",
                          style: GoogleFonts.manrope(
                            fontSize: 13.5,
                            color: AppColors.subTitleColorGary,
                          ),
                        ),
                      ],
                    ),
                  )
                      : Obx(() {
                    if (vaultController.isGridView.value) {
                      return MasonryGridView.count(
                        crossAxisCount: isLandscape ? 3 : 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        padding: const EdgeInsets.only(bottom: 40),
                        physics: const BouncingScrollPhysics(),
                        itemCount: privateLinks.length,
                        itemBuilder: (context, index) {
                          final link = privateLinks[index];
                          return LinkCardWidget(
                            link: link,
                            isGridMode: true,
                            onTap: () => Get.to(() => LinkDetailScreen(link: link)),
                            onMoreTap: () => LinkActionsBottomSheet.show(
                              context,
                              link,
                              homeController,
                            ),
                            onFavouriteTap: () => homeController.toggleFavourite(link),
                          );
                        },
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 40),
                      physics: const BouncingScrollPhysics(),
                      itemCount: privateLinks.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final link = privateLinks[index];
                        return LinkCardWidget(
                          link: link,
                          isGridMode: false,
                          onTap: () => Get.to(() => LinkDetailScreen(link: link)),
                          onMoreTap: () => LinkActionsBottomSheet.show(
                            context,
                            link,
                            homeController,
                          ),
                          onFavouriteTap: () => homeController.toggleFavourite(link),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}