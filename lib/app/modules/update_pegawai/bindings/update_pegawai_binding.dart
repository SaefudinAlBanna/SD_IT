import 'package:get/get.dart';

import '../controllers/update_pegawai_controller.dart';

class UpdatePegawaiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdatePegawaiController>(
      () => UpdatePegawaiController(),
    );
  }
}
