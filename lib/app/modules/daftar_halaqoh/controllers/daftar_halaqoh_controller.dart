import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DaftarHalaqohController extends GetxController {
  var dataFase = Get.arguments;

  RxBool isLoading = false.obs;

  TextEditingController pengampuC = TextEditingController();
  TextEditingController kelasSiswaC = TextEditingController();
  TextEditingController alasanC = TextEditingController();

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
        .doc('Semester I')
        .collection('daftarsiswa')
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
        .delete();
        // .then((value) =>
        //     Get.snackbar('Berhasil', 'Siswa sudah dihapus dari kelompok'))
        // .catchError((error) => Get.snackbar('Gagal', '$error'));
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

  Future<List<String>> getDataPengampuFase() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    List<String> pengampuList = [];
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
        .where('namapengampu', isNotEqualTo: dataFase['namapengampu'])
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs
          .where((doc) => doc['fase'] == dataFase['fase'])) {
        pengampuList.add(docSnapshot.data()['namapengampu']);
      }
    });
    return pengampuList;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> dataPengampuPindah() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    DocumentSnapshot<Map<String, dynamic>> getPengampuNya = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('semester')
        .doc(dataFase['namasemester'])
        .collection('kelompokmengaji')
        .doc(dataFase['fase'])
        .collection('pengampu')
        // .where('namapengampu', isNotEqualTo: dataFase['namapengampu'])
        .doc(pengampuC.text)
        .get();

    // print('ini get pentampunya = ${getPengampuNya.docs.first.data()['test']}');
    return getPengampuNya;
  }

  // Future<void> pindahkan() async {
  //   if (pengampuC.text.isEmpty || pengampuC.text == "") {
  //     // print('PENGAMPU BELUM DIISI');
  //     isLoading.value = false;
  //     Get.snackbar('Peringatan', 'Pengampu baru kosong');
  //   } else if (alasanC.text.isEmpty) {
  //     isLoading.value = false;
  //     Get.snackbar('Peringatan', 'Alasan pindah kosong, silahkan diisi dahulu');
  //   } else {
  //     isLoading.value = true;
  //     try {
  //       DocumentSnapshot<Map<String, dynamic>> pengampuSnapshot =
  //           await dataPengampuPindah();
  //       Map<String, dynamic> pengampuData = pengampuSnapshot.data()!;

  //       String tahunajaran = pengampuData['tahunajaran'];
  //       String tahunAjaranPengampu = tahunajaran.replaceAll('/', '-');
  //       // String tempatPengampuPindah = pengampuData['tempatmengaji'];

  //       DateTime now = DateTime.now();
  //       String docIdPindah = DateFormat.yMd().format(now).replaceAll('/', '-');

  //       QuerySnapshot<Map<String, dynamic>> snapDaftarHalaqoh =
  //           await getDaftarHalaqoh().first;
  //       Map<String, dynamic> siswaData = snapDaftarHalaqoh.docs.first.data();

  //       QuerySnapshot<Map<String, dynamic>> getNilainya = await firestore
  //           .collection('Sekolah')
  //           .doc(idSekolah)
  //           .collection('tahunajaran')
  //           .doc(tahunAjaranPengampu)
  //           .collection('semester')
  //           .doc(pengampuData['namasemester'])
  //           .collection('kelompokmengaji')
  //           .doc(pengampuData['fase'])
  //           .collection('pengampu')
  //           .doc(dataFase['namapengampu'])
  //           .collection('tempat')
  //           .doc(dataFase['tempatmengaji'])
  //           .collection('daftarsiswa')
  //           .doc(siswaData['nisn'])
  //           .collection('nilai')
  //           .get();

  //       // if (getNilainya.docs.isEmpty) {
  //       //   Get.snackbar(
  //       //      "Informasi", "No data available");
  //       //   return;
  //       // }

  //       // ambil semua data doc nilai
  //       // Map<String, dynamic> allNilaiNya = {};
  //       // for (var element in getNilainya.docs) {
  //       //   allNilaiNya[element.id] = element.data();
  //       // }

  //       //ambil semua doc id
  //       Map<String, dynamic> allDocId = {};
  //       for (var element in getNilainya.docs) {
  //         allDocId[element.id] = element.data()[element.id];

  //         // print('allNilaiNya = $allNilaiNya');
  //         // print('===============================');
  //         // print('allDocId = $allDocId');

  //         Map<String, dynamic> allDocNilai = {};
  //         for (var element in getNilainya.docs) {
  //           allDocNilai[element.id] = element.data();

  //           // print("allDocNilai[element.id]['tanggalinput'] = ${allDocNilai[element.id]['tanggalinput']}");
  //           // print('===============================');
  //           // print("allDocNilai[element.id]['ummijilidatausurat'] = ${allDocNilai[element.id]['ummijilidatausurat']}");

  //           // BUAT DOC PINDAH PADA PENGAMPU LAMA
  //           // await firestore
  //           //     .collection('Sekolah')
  //           //     .doc(idSekolah)
  //           //     .collection('tahunajaran')
  //           //     .doc(tahunAjaranPengampu)
  //           //     .collection('semester')
  //           //     .doc(pengampuData['namasemester'])
  //           //     .collection('kelompokmengaji')
  //           //     .doc(pengampuData['fase'])
  //           //     .collection('pengampu')
  //           //     .doc(dataFase['namapengampu'])
  //           //     .collection('tempat')
  //           //     .doc(dataFase['tempatmengaji'])
  //           //     .collection('daftarsiswa')
  //           //     .doc(siswaData['nisn'])
  //           //     .collection('pindahhalaqoh')
  //           //     .doc(docIdPindah)
  //           //     .set({
  //           //   'emailpenginput': emailAdmin,
  //           //   'idpenginput': idUser,
  //           //   'tanggalpindah': DateTime.now().toIso8601String(),
  //           //   'halaqohlama': dataFase['namapengampu'],
  //           //   'tempathalaqohlama': dataFase['tempatmengaji'],
  //           //   'halaqohbaru': pengampuData['namapengampu'],
  //           //   'tempathalaqohbaru': pengampuData['tempatmengaji'],
  //           //   'alasanpindah': alasanC.text,
  //           // });

  //           //  SIMPAN DATA SISWA PADA TAHUN AJARAN SEKOLAH (PENGAMPU BARU)
  //           await firestore
  //               .collection('Sekolah')
  //               .doc(idSekolah)
  //               .collection('tahunajaran')
  //               .doc(tahunAjaranPengampu)
  //               .collection('semester')
  //               .doc(pengampuData['namasemester'])
  //               .collection('kelompokmengaji')
  //               .doc(pengampuData['fase'])
  //               .collection('pengampu')
  //               .doc(pengampuData['namapengampu'])
  //               .collection('tempat')
  //               .doc(pengampuData['tempatmengaji'])
  //               .collection('daftarsiswa')
  //               .doc(siswaData['nisn'])
  //               .set({
  //             'namasiswa': siswaData['namasiswa'],
  //             'nisn': siswaData['nisn'],
  //             'kelas': siswaData['kelas'],
  //             'fase': pengampuData['fase'],
  //             'tempatmengaji': pengampuData['tempatmengaji'],
  //             'tahunajaran': pengampuData['tahunajaran'],
  //             'kelompokmengaji': pengampuData['namapengampu'],
  //             'namasemester': pengampuData['namasemester'],
  //             'namapengampu': pengampuData['namapengampu'],
  //             'idpengampu': pengampuData['idpengampu'],
  //             'emailpenginput': emailAdmin,
  //             'idpenginput': idUser,
  //             'tanggalinput': DateTime.now().toIso8601String(),
  //             'idsiswa': siswaData['idsiswa'],
  //           });

  //           // SIMPAN NILAI DATA SISWA PADA TAHUN AJARAN SEKOLAH (PENGAMPU BARU)
  //           // Jika nilai pada halaqoh sebelumnya tidak ada maka step ini d lewati
  //           // ignore: prefer_is_empty
  //           if (element.id.isNotEmpty || element.id.length != 0) {
  //             await firestore
  //                 .collection('Sekolah')
  //                 .doc(idSekolah)
  //                 .collection('tahunajaran')
  //                 .doc(tahunAjaranPengampu)
  //                 .collection('semester')
  //                 .doc(pengampuData['namasemester'])
  //                 .collection('kelompokmengaji')
  //                 .doc(pengampuData['fase'])
  //                 .collection('pengampu')
  //                 .doc(pengampuData['namapengampu'])
  //                 .collection('tempat')
  //                 .doc(pengampuData['tempatmengaji'])
  //                 .collection('daftarsiswa')
  //                 .doc(siswaData['nisn'])
  //                 .collection('nilai')
  //                 .doc(element.id)
  //                 .set({
  //               'tanggalinput': allDocNilai[element.id]['tanggalinput'],
  //               //=========================================
  //               "emailpenginput": emailAdmin,
  //               "fase": allDocNilai[element.id]['fase'],
  //               "idpengampu": allDocNilai[element.id]['idpengampu'],
  //               "idsiswa": allDocNilai[element.id]['idsiswa'],
  //               "kelas": allDocNilai[element.id]['kelas'],
  //               "kelompokmengaji": allDocNilai[element.id]['kelompokmengaji'],
  //               "namapengampu": allDocNilai[element.id]['namapengampu'],
  //               "namasemester": allDocNilai[element.id]['namasemester'],
  //               "namasiswa": allDocNilai[element.id]['namasiswa'],
  //               "tahunajaran": allDocNilai[element.id]['tahunajaran'],
  //               "tempatmengaji": allDocNilai[element.id]['tempatmengaji'],
  //               "hafalansurat": allDocNilai[element.id]['hafalansurat'],
  //               "ayathafalansurat": allDocNilai[element.id]['ayathafalansurat'],
  //               "ummijilidatausurat": allDocNilai[element.id]
  //                   ['ummijilidatausurat'],
  //               "ummihalatauayat": allDocNilai[element.id]['ummihalatauayat'],
  //               "materi": allDocNilai[element.id]['materi'],
  //               "nilai": allDocNilai[element.id]['nilai'],
  //               "keteranganpengampu": allDocNilai[element.id]
  //                   ['keteranganpengampu'],
  //               "keteranganorangtua": allDocNilai[element.id]
  //                   ['keteranganorangtua']
  //             });
  //           }

  //           // SIMPAN DATA SISWA PADA (PENGAMPU BARU)
  //           await firestore
  //               .collection('Sekolah')
  //               .doc(idSekolah)
  //               .collection('pegawai')
  //               .doc(pengampuData['idpengampu'])
  //               .collection('tahunajarankelompok')
  //               .doc(tahunAjaranPengampu)
  //               .collection('semester')
  //               .doc(pengampuData['namasemester'])
  //               .collection('kelompokmengaji')
  //               .doc(pengampuData['fase'])
  //               .collection('tempat')
  //               .doc(pengampuData['tempatmengaji'])
  //               .collection('daftarsiswa')
  //               .doc(siswaData['nisn'])
  //               .set({
  //             'namasiswa': siswaData['namasiswa'],
  //             'nisn': siswaData['nisn'],
  //             'kelas': siswaData['kelas'],
  //             'fase': pengampuData['fase'],
  //             'tempatmengaji': pengampuData['tempatmengaji'],
  //             'tahunajaran': pengampuData['tahunajaran'],
  //             'kelompokmengaji': pengampuData['namapengampu'],
  //             'namasemester': pengampuData['namasemester'],
  //             'namapengampu': pengampuData['namapengampu'],
  //             'idpengampu': pengampuData['idpengampu'],
  //             'emailpenginput': emailAdmin,
  //             'idpenginput': idUser,
  //             'tanggalinput': DateTime.now().toIso8601String(),
  //             'idsiswa': siswaData['idsiswa'],
  //           });

  //           // BUAT TEMPAT di firebase MURID PINDAHAN HALAQOH PADA DATABASE
  //           await firestore
  //               .collection('Sekolah')
  //               .doc(idSekolah)
  //               .collection('tahunajaran')
  //               .doc(tahunAjaranPengampu)
  //               .collection('semester')
  //               .doc(pengampuData['namasemester'])
  //               .collection('pindahan')
  //               .doc(docIdPindah)
  //               .set({
  //             'namasiswa': siswaData['namasiswa'],
  //             'kelas': siswaData['kelas'],
  //             'fase': pengampuData['fase'],
  //             'namasemester': pengampuData['namasemester'],
  //             'tahunajaran': pengampuData['tahunajaran'],
  //             'emailpenginput': emailAdmin,
  //             'idpenginput': idUser,
  //             'tanggalpindah': DateTime.now().toIso8601String(),
  //             'halaqohlama': dataFase['namapengampu'],
  //             'tempathalaqohlama': dataFase['tempatmengaji'],
  //             'halaqohbaru': pengampuData['namapengampu'],
  //             'tempathalaqohbaru': pengampuData['tempatmengaji'],
  //             'alasanpindah': alasanC.text,
  //           });

  //           // BUAT TEMPAT di firebase MURID PINDAHAN HALAQOH PADA DATABASE
  //           // await firestore
  //           //     .collection('Sekolah')
  //           //     .doc(idSekolah)
  //           //     .collection('tahunajaran')
  //           //     .doc(tahunAjaranPengampu)
  //           //     .collection('semester')
  //           //     .doc(pengampuData['namasemester'])
  //           //     .collection('pindahan')
  //           //     .doc(docIdPindah)
  //           //     .collection('daftarsiswa')
  //           //     .doc(siswaData['nisn'])
  //           //     .set({
  //           //   'namasiswa': siswaData['namasiswa'],
  //           //   'nisn': siswaData['nisn'],
  //           //   'kelas': siswaData['kelas'],
  //           //   'fase': pengampuData['fase'],
  //           //   'emailpenginput': emailAdmin,
  //           //   'idpenginput': idUser,
  //           //   'tanggalpindah': DateTime.now().toIso8601String(),
  //           //   'halaqohlama': dataFase['namapengampu'],
  //           //   'tempathalaqohlama': dataFase['tempatmengaji'],
  //           //   'halaqohbaru': pengampuData['namapengampu'],
  //           //   'tempathalaqohbaru': pengampuData['tempatmengaji'],
  //           //   'alasanpindah': alasanC.text,
  //           //   'idsiswa': siswaData['idsiswa'],
  //           // });

  //           //DELETE SISWA DARI HALAQOH LAMA (TAHUN AJARAN SEKOLAH)
  //           await firestore
  //               .collection('Sekolah')
  //               .doc(idSekolah)
  //               .collection('tahunajaran')
  //               .doc(pengampuData['tahunajaran'])
  //               .collection('semester')
  //               .doc(pengampuData['namasemester'])
  //               .collection('kelompokmengaji')
  //               .doc(pengampuData['fase']) // ini nanti diganti otomatis
  //               .collection('pengampu')
  //               .doc(pengampuData['namapengampu'])
  //               .collection('tempat')
  //               .doc(pengampuData['tempatmengaji'])
  //               .collection('daftarsiswa')
  //               .doc(siswaData['nisn'])
  //               .delete();
            
  //           //DELETE SISWA DARI HALAQOH LAMA (PEGAWAI PENGAMPU LAMA)
  //           // await firestore
  //           //     .collection('Sekolah')
  //           //     .doc(idSekolah)
  //           //     .collection('pegawai')
  //           //     .doc(dataFase['idpengampu'])
  //           //     .collection('tahunajarankelompok')
  //           //     .doc(pengampuData['tahunajaran'])
  //           //     .collection('semester')
  //           //     .doc(pengampuData['namasemester']) // ini nanti diganti otomatis
  //           //     .collection('kelompokmengaji')
  //           //     .doc(dataFase['fase'])
  //           //     .collection('tempat')
  //           //     .doc(pengampuData['tempatmengaji'])
  //           //     .collection('daftarsiswa')
  //           //     .doc(siswaData['nisn'])
  //           //     .delete();
  //         }
  //       }

  //       // print('berhasil================');
  //       Get.back();
  //       Get.snackbar('Berhasil', 'Siswa sudah pindah halaqoh');
  //       isLoading.value = false;
  //     } catch (e) {
  //       isLoading.value = false;
  //       Get.snackbar('Error', '$e');
  //       print('pesan error : $e');
  //     }
  //   }
  // }

  Future<void> pindahkan() async {
    if (pengampuC.text.isEmpty || pengampuC.text == "") {
      // print('PENGAMPU BELUM DIISI');
      isLoading.value = false;
      Get.snackbar('Peringatan', 'Pengampu baru kosong');
    } else if (alasanC.text.isEmpty) {
      isLoading.value = false;
      Get.snackbar('Peringatan', 'Alasan pindah kosong, silahkan diisi dahulu');
    } else {
      isLoading.value = true;
      try {
        DocumentSnapshot<Map<String, dynamic>> pengampuSnapshot =
            await dataPengampuPindah();
        Map<String, dynamic> pengampuData = pengampuSnapshot.data()!;

        String tahunajaran = pengampuData['tahunajaran'];
        String tahunAjaranPengampu = tahunajaran.replaceAll('/', '-');
        // String tempatPengampuPindah = pengampuData['tempatmengaji'];

        DateTime now = DateTime.now();
        String docIdPindah = DateFormat.yMd().format(now).replaceAll('/', '-');

        QuerySnapshot<Map<String, dynamic>> snapDaftarHalaqoh =
            await getDaftarHalaqoh().first;
        Map<String, dynamic> siswaData = snapDaftarHalaqoh.docs.first.data();

        QuerySnapshot<Map<String, dynamic>> getNilainya = await firestore
            .collection('Sekolah')
            .doc(idSekolah)
            .collection('tahunajaran')
            .doc(tahunAjaranPengampu)
            .collection('semester')
            .doc(pengampuData['namasemester'])
            .collection('kelompokmengaji')
            .doc(pengampuData['fase'])
            .collection('pengampu')
            .doc(dataFase['namapengampu'])
            .collection('tempat')
            .doc(dataFase['tempatmengaji'])
            .collection('daftarsiswa')
            .doc(siswaData['nisn'])
            .collection('nilai')
            .get();

        // if (getNilainya.docs.isEmpty) {
        //   Get.snackbar(
        //      "Informasi", "No data available");
        //   return;
        // }

        // ambil semua data doc nilai
        // Map<String, dynamic> allNilaiNya = {};
        // for (var element in getNilainya.docs) {
        //   allNilaiNya[element.id] = element.data();
        // }

        //ambil semua doc id
        Map<String, dynamic> allDocId = {};
        for (var element in getNilainya.docs) {
          allDocId[element.id] = element.data()[element.id];

          // print('allNilaiNya = $allNilaiNya');
          // print('===============================');
          // print('allDocId = $allDocId');

          Map<String, dynamic> allDocNilai = {};
          for (var element in getNilainya.docs) {
            allDocNilai[element.id] = element.data();

            // print("allDocNilai[element.id]['tanggalinput'] = ${allDocNilai[element.id]['tanggalinput']}");
            // print('===============================');
            // print("allDocNilai[element.id]['ummijilidatausurat'] = ${allDocNilai[element.id]['ummijilidatausurat']}");

            // BUAT DOC PINDAH PADA PENGAMPU LAMA
            await firestore
                .collection('Sekolah')
                .doc(idSekolah)
                .collection('tahunajaran')
                .doc(tahunAjaranPengampu)
                .collection('semester')
                .doc(pengampuData['namasemester'])
                .collection('kelompokmengaji')
                .doc(pengampuData['fase'])
                .collection('pengampu')
                .doc(dataFase['namapengampu'])
                .collection('tempat')
                .doc(dataFase['tempatmengaji'])
                .collection('daftarsiswa')
                .doc(siswaData['nisn'])
                .collection('pindahhalaqoh')
                .doc(docIdPindah)
                .set({
              'emailpenginput': emailAdmin,
              'idpenginput': idUser,
              'tanggalpindah': DateTime.now().toIso8601String(),
              'halaqohlama': dataFase['namapengampu'],
              'tempathalaqohlama': dataFase['tempatmengaji'],
              'halaqohbaru': pengampuData['namapengampu'],
              'tempathalaqohbaru': pengampuData['tempatmengaji'],
              'alasanpindah': alasanC.text,
            });
            print('BUAT DOC PINDAH PADA PENGAMPU LAMA');

            //  SIMPAN DATA SISWA PADA TAHUN AJARAN SEKOLAH (PENGAMPU BARU)
            await firestore
                .collection('Sekolah')
                .doc(idSekolah)
                .collection('tahunajaran')
                .doc(tahunAjaranPengampu)
                .collection('semester')
                .doc(pengampuData['namasemester'])
                .collection('kelompokmengaji')
                .doc(pengampuData['fase'])
                .collection('pengampu')
                .doc(pengampuData['namapengampu'])
                .collection('tempat')
                .doc(pengampuData['tempatmengaji'])
                .collection('daftarsiswa')
                .doc(siswaData['nisn'])
                .set({
              'namasiswa': siswaData['namasiswa'],
              'nisn': siswaData['nisn'],
              'kelas': siswaData['kelas'],
              'fase': pengampuData['fase'],
              'tempatmengaji': pengampuData['tempatmengaji'],
              'tahunajaran': pengampuData['tahunajaran'],
              'kelompokmengaji': pengampuData['namapengampu'],
              'namasemester': pengampuData['namasemester'],
              'namapengampu': pengampuData['namapengampu'],
              'idpengampu': pengampuData['idpengampu'],
              'emailpenginput': emailAdmin,
              'idpenginput': idUser,
              'tanggalinput': DateTime.now().toIso8601String(),
              'idsiswa': siswaData['idsiswa'],
            });
              print('SIMPAN DATA SISWA PADA TAHUN AJARAN SEKOLAH (PENGAMPU BARU)');

            // SIMPAN NILAI DATA SISWA PADA TAHUN AJARAN SEKOLAH (PENGAMPU BARU)
            // Jika nilai pada halaqoh sebelumnya tidak ada maka step ini d lewati
            // ignore: prefer_is_empty
            if (element.id.isNotEmpty || element.id.length != 0) {
              await firestore
                  .collection('Sekolah')
                  .doc(idSekolah)
                  .collection('tahunajaran')
                  .doc(tahunAjaranPengampu)
                  .collection('semester')
                  .doc(pengampuData['namasemester'])
                  .collection('kelompokmengaji')
                  .doc(pengampuData['fase'])
                  .collection('pengampu')
                  .doc(pengampuData['namapengampu'])
                  .collection('tempat')
                  .doc(pengampuData['tempatmengaji'])
                  .collection('daftarsiswa')
                  .doc(siswaData['nisn'])
                  .collection('nilai')
                  .doc(element.id)
                  .set({
                'tanggalinput': allDocNilai[element.id]['tanggalinput'],
                //=========================================
                "emailpenginput": emailAdmin,
                "fase": allDocNilai[element.id]['fase'],
                "idpengampu": allDocNilai[element.id]['idpengampu'],
                "idsiswa": allDocNilai[element.id]['idsiswa'],
                "kelas": allDocNilai[element.id]['kelas'],
                "kelompokmengaji": allDocNilai[element.id]['kelompokmengaji'],
                "namapengampu": allDocNilai[element.id]['namapengampu'],
                "namasemester": allDocNilai[element.id]['namasemester'],
                "namasiswa": allDocNilai[element.id]['namasiswa'],
                "tahunajaran": allDocNilai[element.id]['tahunajaran'],
                "tempatmengaji": allDocNilai[element.id]['tempatmengaji'],
                "hafalansurat": allDocNilai[element.id]['hafalansurat'],
                "ayathafalansurat": allDocNilai[element.id]['ayathafalansurat'],
                "ummijilidatausurat": allDocNilai[element.id]
                    ['ummijilidatausurat'],
                "ummihalatauayat": allDocNilai[element.id]['ummihalatauayat'],
                "materi": allDocNilai[element.id]['materi'],
                "nilai": allDocNilai[element.id]['nilai'],
                "keteranganpengampu": allDocNilai[element.id]
                    ['keteranganpengampu'],
                "keteranganorangtua": allDocNilai[element.id]
                    ['keteranganorangtua']
              });
              print('SIMPAN NILAI DATA SISWA PADA TAHUN AJARAN SEKOLAH (PENGAMPU BARU)');
            }

            // SIMPAN DATA SISWA PADA (PENGAMPU BARU)
            await firestore
                .collection('Sekolah')
                .doc(idSekolah)
                .collection('pegawai')
                .doc(pengampuData['idpengampu'])
                .collection('tahunajarankelompok')
                .doc(tahunAjaranPengampu)
                .collection('semester')
                .doc(pengampuData['namasemester'])
                .collection('kelompokmengaji')
                .doc(pengampuData['fase'])
                .collection('tempat')
                .doc(pengampuData['tempatmengaji'])
                .collection('daftarsiswa')
                .doc(siswaData['nisn'])
                .set({
              'namasiswa': siswaData['namasiswa'],
              'nisn': siswaData['nisn'],
              'kelas': siswaData['kelas'],
              'fase': pengampuData['fase'],
              'tempatmengaji': pengampuData['tempatmengaji'],
              'tahunajaran': pengampuData['tahunajaran'],
              'kelompokmengaji': pengampuData['namapengampu'],
              'namasemester': pengampuData['namasemester'],
              'namapengampu': pengampuData['namapengampu'],
              'idpengampu': pengampuData['idpengampu'],
              'emailpenginput': emailAdmin,
              'idpenginput': idUser,
              'tanggalinput': DateTime.now().toIso8601String(),
              'idsiswa': siswaData['idsiswa'],
            });
            print('SIMPAN DATA SISWA PADA (PENGAMPU BARU)');

            // BUAT TEMPAT di firebase MURID PINDAHAN HALAQOH PADA DATABASE
            await firestore
                .collection('Sekolah')
                .doc(idSekolah)
                .collection('tahunajaran')
                .doc(tahunAjaranPengampu)
                .collection('semester')
                .doc(pengampuData['namasemester'])
                .collection('pindahan')
                .doc(docIdPindah)
                // .doc(uid)
                .set({
              'namasiswa': siswaData['namasiswa'],
              'nisn': siswaData['nisn'],
              'kelas': siswaData['kelas'],
              'fase': pengampuData['fase'],
              'emailpenginput': emailAdmin,
              'idpenginput': idUser,
              'tanggalpindah': DateTime.now().toIso8601String(),
              'halaqohlama': dataFase['namapengampu'],
              'tempathalaqohlama': dataFase['tempatmengaji'],
              'halaqohbaru': pengampuData['namapengampu'],
              'tempathalaqohbaru': pengampuData['tempatmengaji'],
              'alasanpindah': alasanC.text,
              'idsiswa': siswaData['idsiswa'],
            });
            print('BUAT TEMPAT di firebase MURID PINDAHAN HALAQOH PADA DATABASE');

            // BUAT TEMPAT di firebase MURID PINDAHAN HALAQOH PADA DATABASE
            // await firestore
            //     .collection('Sekolah')
            //     .doc(idSekolah)
            //     .collection('tahunajaran')
            //     .doc(tahunAjaranPengampu)
            //     .collection('semester')
            //     .doc(pengampuData['namasemester'])
            //     .collection('pindahan')
            //     .doc(docIdPindah)
            //     .collection('daftarsiswa')
            //     .doc(siswaData['nisn'])
            //     .set({
            //   'namasiswa': siswaData['namasiswa'],
            //   'nisn': siswaData['nisn'],
            //   'kelas': siswaData['kelas'],
            //   'fase': pengampuData['fase'],
            //   'emailpenginput': emailAdmin,
            //   'idpenginput': idUser,
            //   'tanggalpindah': DateTime.now().toIso8601String(),
            //   'halaqohlama': dataFase['namapengampu'],
            //   'tempathalaqohlama': dataFase['tempatmengaji'],
            //   'halaqohbaru': pengampuData['namapengampu'],
            //   'tempathalaqohbaru': pengampuData['tempatmengaji'],
            //   'alasanpindah': alasanC.text,
            //   'idsiswa': siswaData['idsiswa'],
            // });
          }
        }

        // print('berhasil================');
        Get.back();
        Get.snackbar('Alhamdulillah', 'berhasil memindahkan siswa');
      } catch (e) {
        Get.snackbar('Errpr', '$e');
      }
    }
  }

  void test() async {
     DocumentSnapshot<Map<String, dynamic>> pengampuSnapshot =
            await dataPengampuPindah();
        Map<String, dynamic> pengampuData = pengampuSnapshot.data()!;

        // String tahunajaran = pengampuData['tahunajaran'];
        // String tahunAjaranPengampu = tahunajaran.replaceAll('/', '-');
    // print('tempatmengaji ${dataFase['tempatmengaji']}');


    // DateTime now = DateTime.now();
    // String docIdPindah = DateFormat.Hms().format(now).replaceAll(":", "-");
    // print('docIdPindah = $docIdPindah');

    // print('pengampu lama = ${dataFase['namapengampu']}');
    // print('pengampu baru = ${pengampuData['namapengampu']}');
    // print('tempatmengaji baru = ${pengampuData['tempatmengaji']}');
    // print('fase baru = ${pengampuData['fase']}');
    
        DateTime now = DateTime.now();
        String docIdPindah = DateFormat.yMEd().add_jms().format(now).replaceAllMapped(RegExp(r'[ :,/AMPM]+'), (match) => '-');

        print('docIdPindah = $docIdPindah');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDataSiswaStreamBaru() async* {
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
            'Semester I') // ini nanti diganti otomatis // sudah di pasang -->> kalo sudah dihapus comment
        .collection('daftarsiswa')
        .where('statuskelompok', isEqualTo: 'baru')
        .snapshots();

    // print('ini kelasnya : ${kelasSiswaC.text}');
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

  Future<void> halaqohUntukSiswaNext(String nisnSiswa) async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String kelasNya = kelasSiswaC.text.substring(0, 1);
    String faseNya = (kelasNya == '1' || kelasNya == '2')
        ? "Fase A"
        : (kelasNya == '3' || kelasNya == '4')
            ? "Fase B"
            : "Fase C";

    // QuerySnapshot<Map<String, dynamic>> querySnapshotSiswa = await firestore
    //     .collection('Sekolah')
    //     .doc(idSekolah)
    //     .collection('siswa')
    //     .where('nisn', isEqualTo: nisnSiswa)
    //     .get();
    // if (querySnapshotSiswa.docs.isNotEmpty) {
    //   Map<String, dynamic> dataSiswa = querySnapshotSiswa.docs.first.data();
    //   String uidSiswa = dataSiswa['uid'];

    QuerySnapshot<Map<String, dynamic>> querySnapshotKelompok = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: dataFase['namapengampu'])
        .get();
    if (querySnapshotKelompok.docs.isNotEmpty) {
      Map<String, dynamic> dataGuru = querySnapshotKelompok.docs.first.data();
      String idPengampu = dataGuru['uid'];

      await firestore
          .collection('Sekolah')
          .doc(idSekolah)
          .collection('siswa')
          .doc(nisnSiswa)
          .collection('tahunajarankelompok')
          .doc(idTahunAjaran)
          .set({
        'namatahunajaran': tahunajaranya,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now().toIso8601String(),
      });

      await firestore
          .collection('Sekolah')
          .doc(idSekolah)
          .collection('siswa')
          .doc(nisnSiswa)
          .collection('tahunajarankelompok')
          .doc(idTahunAjaran)
          .collection('semester')
          .doc(dataFase['namasemester'])
          .set({
        'namasemester': dataFase['namasemester'],
        'tahunajaran': tahunajaranya,
        'emailpenginput': emailAdmin,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now().toIso8601String(),
      });

      await firestore
          .collection('Sekolah')
          .doc(idSekolah)
          .collection('siswa')
          .doc(nisnSiswa)
          .collection('tahunajarankelompok')
          .doc(idTahunAjaran)
          .collection('semester')
          .doc(dataFase['namasemester'])
          .collection('kelompokmengaji')
          .doc(dataFase['fase'])
          .set({
        'fase': dataFase['fase'],
        'tempatmengaji': dataFase['tempatmengaji'],
        'namapengampu': dataFase['namapengampu'],
        'kelompokmengaji': dataFase['namapengampu'],
        'idpengampu': idPengampu,
        'namasemester': dataFase['namasemester'],
        'tahunajaran': tahunajaranya,
        'emailpenginput': emailAdmin,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now().toIso8601String(),
      });

      await firestore
          .collection('Sekolah')
          .doc(idSekolah)
          .collection('siswa')
          .doc(nisnSiswa)
          .collection('tahunajarankelompok')
          .doc(idTahunAjaran)
          .collection('semester')
          .doc(dataFase['namasemester'])
          .collection('kelompokmengaji')
          .doc(dataFase['fase'])
          .collection('tempat')
          .doc(dataFase['tempatmengaji'])
          .set({
        'nisn' : nisnSiswa,
        'tempatmengaji': dataFase['tempatmengaji'],
        'fase': dataFase['fase'],
        'tahunajaran': dataFase['tahunajaran'],
        'kelompokmengaji': dataFase['namapengampu'],
        'namasemester': dataFase['namasemester'],
        'namapengampu': dataFase['namapengampu'],
        'idpengampu': idPengampu,
        'emailpenginput': emailAdmin,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> kelasUntukSiswa(String nisnSiswa) async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String kelasNya = kelasSiswaC.text.substring(0, 1);
    String faseNya = (kelasNya == '1' || kelasNya == '2')
        ? "Fase A"
        : (kelasNya == '3' || kelasNya == '4')
            ? "Fase B"
            : "Fase C";

    QuerySnapshot<Map<String, dynamic>> querySnapshotSiswa = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('siswa')
        .where('nisn', isEqualTo: nisnSiswa)
        .get();
    if (querySnapshotSiswa.docs.isNotEmpty) {
      Map<String, dynamic> dataSiswa = querySnapshotSiswa.docs.first.data();
      String uidSiswa = dataSiswa['uid'];

      await firestore
          .collection('Sekolah')
          .doc(idSekolah)
          .collection('siswa')
          .doc(uidSiswa)
          .collection('tahunajaran')
          .doc(idTahunAjaran)
          .set({
        'namatahunajaran': tahunajaranya,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now().toIso8601String(),
      });

      await firestore
          .collection('Sekolah')
          .doc(idSekolah)
          .collection('siswa')
          .doc(uidSiswa)
          .collection('tahunajaran')
          .doc(idTahunAjaran)
          .collection('kelasnya')
          .doc(kelasSiswaC.text)
          .set({
        'namakelas': kelasSiswaC.text,
        'fase': faseNya,
        'tahunajaran': tahunajaranya,
        'emailpenginput': emailAdmin,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now().toIso8601String(),
      });
    }
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

      halaqohUntukSiswaNext(nisnSiswa);
      ubahStatusSiswa(nisnSiswa);
    }
  }

  Future<List<String>> getDataKelasYangAda() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

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
