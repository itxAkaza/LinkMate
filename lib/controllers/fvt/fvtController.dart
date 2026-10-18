import 'package:get/get.dart';
import '../../Utiles/app_haptic.dart';
import '../../data/repositories/link_repository.dart';

class FavouriteController extends GetxController {
  final LinkRepository _repository = LinkRepository();
  final RxBool isGridView = false.obs;

  @override
  void onInit() {
    super.onInit();
    isGridView.value = _repository.getGridViewState('favorites');
  }

  void toggleViewMode() {
    AppHaptics.lightTap();
    isGridView.value = !isGridView.value;
    _repository.saveGridViewState('favorites', isGridView.value);
  }
}