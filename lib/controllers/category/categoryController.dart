import 'package:get/get.dart';
import '../../Utiles/app_haptic.dart';
import '../../data/repositories/link_repository.dart';

class CategoryController extends GetxController {
  final LinkRepository _repository = LinkRepository();

  final RxBool isCategoryGrid = false.obs;
  final RxBool isCategoryLinksGrid = false.obs;

  @override
  void onInit() {
    super.onInit();
    isCategoryGrid.value = _repository.getGridViewState('categories_page');
    isCategoryLinksGrid.value = _repository.getGridViewState('category_links_page');
  }

  void toggleCategoryGrid() {
    AppHaptics.lightTap();
    isCategoryGrid.value = !isCategoryGrid.value;
    _repository.saveGridViewState('categories_page', isCategoryGrid.value);
  }

  void toggleCategoryLinksGrid() {
    AppHaptics.lightTap();
    isCategoryLinksGrid.value = !isCategoryLinksGrid.value;
    _repository.saveGridViewState('category_links_page', isCategoryLinksGrid.value);
  }
}