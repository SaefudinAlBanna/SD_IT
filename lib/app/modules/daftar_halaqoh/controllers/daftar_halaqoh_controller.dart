import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DaftarHalaqohController extends GetxController {
  var dataFase = Get.arguments;

  TextEditingController pengampuC = TextEditingController();
  TextEditingController kelasSiswaC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String idUser = FirebaseAuth.instance.currentUser!.uid;
  String idSekolah = 'UQjMpsKZKmWWbWVu4Uwb';
  String emailAdmin = FirebaseAuth.instance.currentUser!.email!;

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

  Stream<QuerySnapshot<Map<String, dynamic>>> getDaftarHalaqoh() async* {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    yield* firestore
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
        .snapshots();
  }

  Future<void> ubahStatusSiswa(String nisnSiSwa) async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('kelastahunajaran')
        .doc(kelasSiswaC.text)
        .collection('semester')
        // .doc(semesterNya)
        .doc('semester1')
        .collection('daftarsiswasemester1')
        .doc(nisnSiSwa)
        .update({
      'statuskelompok': 'aktif',
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

  Future<List<String>> getDataPengampu() async {
    List<String> pengampuList = [];
    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .get()
        .then((querySnapshot) {
      for (var docSnapshot
          in querySnapshot.docs.where((doc) => doc['role'] == 'admin')) {
        pengampuList.add(docSnapshot.data()['alias']);
      }
    });
    return pengampuList;
  }

 Stream<QuerySnapshot<Map<String, dynamic>>> getDataSiswaStream() async* {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    // String idSemester = await getDataSemester();
    yield* firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('kelastahunajaran')
        .doc(kelasSiswaC.text)
        .collection('semester')
        .doc(
            'semester1') // ini nanti diganti otomatis // sudah di pasang -->> kalo sudah dihapus comment
        .collection('daftarsiswasemester1')
        .where('statuskelompok', isEqualTo: 'baru')
        .snapshots();

    // print('ini kelasnya : ${kelasSiswaC.text}');
  }


  Future<void> simpanSiswaKelompok(String namaSiswa, String nisnSiswa) async {

    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    QuerySnapshot<Map<String, dynamic>> querySnapshotKelompok = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: dataFase['namapengampu'])
        .get();
    if (querySnapshotKelompok.docs.isNotEmpty) {
      Map<String, dynamic> dataGuru = querySnapshotKelompok.docs.first.data();
      String idPengampu = dataGuru['uid'];
      // String namaPengampu = dataGuru['alias'];




            //buat pada tahunpelajaran sekolah
            await firestore
                .collection('Sekolah')
                .doc(idSekolah)
                .collection('tahunajaran')
                .doc(idTahunAjaran)
                .collection('semester')
                .doc(dataFase['namasemester'])
                .collection('kelompokmengaji')
                .doc(dataFase['fase'])
                .collection('pengampu')
                .doc(dataFase['namapengampu'])
                .collection('tempat')
                .doc(dataFase['tempatmengaji'])
                .collection('daftarsiswa')
                .doc(nisnSiswa)
                .set({
              'namasiswa': namaSiswa,
              'nisn': nisnSiswa,
              'kelas': kelasSiswaC.text,
              'fase': dataFase['fase'],
              'tempatmengaji': dataFase['tempatmengaji'],
              'tahunajaran': dataFase['tahunajaran'],
              'kelompokmengaji': dataFase['namapengampu'],
              'namasemester': dataFase['namasemester'],
              'namapengampu': dataFase['namapengampu'],
              'idpengampu': dataFase['idpengampu'],
              'emailpenginput': emailAdmin,
              'idpenginput': idUser,
              'tanggalinput': DateTime.now().toIso8601String(),
              'idsiswa': nisnSiswa,
            });



            await firestore
                .collection('Sekolah')
                .doc(idSekolah)
                .collection('pegawai')
                .doc(idPengampu)
                .collection('tahunajarankelompok')
                .doc(idTahunAjaran)
                .collection('semester')
                .doc(dataFase['namasemester'])
                .collection('kelompokmengaji')
                .doc(dataFase['fase'])
                .collection('tempat')
                .doc(dataFase['tempatmengaji'])
                .collection('daftarsiswa')
                .doc(nisnSiswa)
                .set({
              'namasiswa': namaSiswa,
              'nisn': nisnSiswa,
              'kelas': kelasSiswaC.text,
              'fase': dataFase['fase'],
              'tempatmengaji': dataFase['tempatmengaji'],
              'tahunajaran': dataFase['tahunajaran'],
              'kelompokmengaji': dataFase['namapengampu'],
              'namasemester': dataFase['namasemester'],
              'namapengampu': dataFase['namapengampu'],
              'idpengampu': idPengampu,
              'emailpenginput': emailAdmin,
              'idpenginput': idUser,
              'tanggalinput': DateTime.now().toIso8601String(),
              'idsiswa': nisnSiswa,
            });
            ubahStatusSiswa(nisnSiswa);
      
    }
  }

  Future<List<String>> getDataKelasYangAda() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    print('ini data fase dari controller = ${dataFase['fase']}');

          List<String> kelasList = [];
          await firestore
              .collection('Sekolah')
              .doc(idSekolah)
              .collection('tahunajaran')
              .doc(idTahunAjaran)
              .collection('kelastahunajaran')
              .where('fase', isEqualTo: dataFase['fase'])
              .get()
              .then((querySnapshot) {
            for (var docSnapshot in querySnapshot.docs) {
              kelasList.add(docSnapshot.id);
            }
          });
          return kelasList;
        }

}
