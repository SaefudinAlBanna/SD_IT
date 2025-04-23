import 'package:get/get.dart';

import '../controllers/daftar_kelas_semua_siswa_controller.dart';

class DaftarKelasSemuaSiswaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DaftarKelasSemuaSiswaController>(
      () => DaftarKelasSemuaSiswaController(),
    );
  }
}
