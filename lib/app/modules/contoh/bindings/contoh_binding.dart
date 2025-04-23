import 'package:get/get.dart';

import '../controllers/contoh_controller.dart';

class ContohBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContohController>(
      () => ContohController(),
    );
  }
}
