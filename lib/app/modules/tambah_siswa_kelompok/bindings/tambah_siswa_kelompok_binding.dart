import 'package:get/get.dart';

import '../controllers/tambah_siswa_kelompok_controller.dart';

class TambahSiswaKelompokBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahSiswaKelompokController>(
      () => TambahSiswaKelompokController(),
    );
  }
}
