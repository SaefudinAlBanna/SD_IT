import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DaftarHalaqohController extends GetxController {
  var dataFase = Get.arguments;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String idSekolah = 'UQjMpsKZKmWWbWVu4Uwb';

  Future<String> getTahunAjaranTerakhir() async {
    CollectionReference<Map<String, dynamic>> colTahunAjaran = firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran');
    QuerySnapshot<Map<String, dynamic>> snapshotTahunAjaran =
        await colTahunAjaran.get();
    List<Map<String, dynamic>> listTahunAjaran =
        snapshotTahunAjaran.docs.map((e) => e.data()).toList();
    String tahunAjaranTerakhir =
        listTahunAjaran.map((e) => e['namatahunajaran']).toList().last;
    return tahunAjaranTerakhir;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDaftarHalaqoh() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    return await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('semester')
        .doc(dataFase['namasemester'])
        .collection('kelompokmengaji')
        .doc(dataFase['fase']) // ini nanti diganti otomatis
        .collection('pengampu')
        .doc(dataFase['namapengampu'])
        .collection('tempat')
        .doc(dataFase['tempatmengaji'])
        .collection('daftarsiswa')
        .get();
  }

  Future<void> ubahStatusSiswa(String nisnSiSwa, String kelasSiswa) async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('kelastahunajaran')
        .doc(kelasSiswa)
        .collection('semester')
        // .doc(semesterNya)
        .doc('semester1')
        .collection('daftarsiswasemester1')
        .doc(nisnSiSwa)
        .update({
      'statuskelompok': 'baru',
    });
  }

  Future<void> deleteUser(String nisnSiSwa) async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('semester')
        .doc(dataFase['namasemester'])
        .collection('kelompokmengaji')
        .doc(dataFase['fase']) // ini nanti diganti otomatis
        .collection('pengampu')
        .doc(dataFase['namapengampu'])
        .collection('tempat')
        .doc(dataFase['tempatmengaji'])
        .collection('daftarsiswa')
        .doc(nisnSiSwa)
        .delete()
        .then((value) =>
            Get.snackbar('Berhasil', 'Siswa sudah dihapus dari kelompok'))
        .catchError((error) => Get.snackbar('Gagal', '$error'));
      
  }

}
