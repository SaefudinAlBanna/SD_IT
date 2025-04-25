import 'package:get/get.dart';

import '../controllers/pilih_siswa_halaqoh_controller.dart';

class PilihSiswaHalaqohBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PilihSiswaHalaqohController>(
      () => PilihSiswaHalaqohController(),
    );
  }
}
