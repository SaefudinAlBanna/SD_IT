import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PemberianKelasSiswaController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingTambahKelas = false.obs;
  var argumentKelas = Get.arguments;

  // TextEditingController kelasSiswaC = TextEditingController();
  TextEditingController waliKelasSiswaC = TextEditingController();
  TextEditingController idPegawaiC = TextEditingController();
  TextEditingController namaSiswaC = TextEditingController();
  TextEditingController nisnSiswaC = TextEditingController();
  TextEditingController namaTahunAjaranTerakhirC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String idUser = FirebaseAuth.instance.currentUser!.uid;
  String idSekolah = 'UQjMpsKZKmWWbWVu4Uwb';
  String emailAdmin = FirebaseAuth.instance.currentUser!.email!;
  // late String tahunajaranya;
  // late String idTahunAjaran;

  late Stream<QuerySnapshot<Map<String, dynamic>>> tampilkanSiswa;

  @override
  void onInit() {
    super.onInit();

    tampilkanSiswa = FirebaseFirestore.instance
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('siswa')
        .where('status', isNotEqualTo: 'aktif')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> tampilSiswa() {
    return firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('siswa')
        .where('status', isNotEqualTo: 'aktif')
        .snapshots();
  }

  //ambil data walikelas
  Future<List<String>> getDataWaliKelas() async {
    List<String> walikelasList = [];
    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .get()
        .then((querySnapshot) {
      for (var docSnapshot
          in querySnapshot.docs.where((doc) => doc['role'] == 'admin')) {
        walikelasList.add(docSnapshot.data()['alias']);
        // walikelasList.add(docSnapshot.data()['nip']);
      }
    });
    return walikelasList;
  }

//pengambilan tahun ajaran terakhir
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

// delete siswa yang di klik
  Future<void> deleteSiswa(String idSiswa) async {
    // await firestore.collection('Sekolah').doc(idSekolah).collection('siswa').doc(idSiswa).delete();
    // print('ini id siswanya $idSiswa');
    // isLoadingTambahKelas.value = false;
  }

  Future<void> ubahStatusSiswa(String nisnSiSwa) async {
    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('siswa')
        .doc(nisnSiSwa)
        .update({
      'status': 'aktif',
    });
  }

  Future<void> buatIsiKelasTahunAjaran() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String kelasNya = argumentKelas.substring(0, 1);
    String faseNya = (kelasNya == '1' || kelasNya == '2')
        ? "Fase A"
        : (kelasNya == '3' || kelasNya == '4')
            ? "Fase B"
            : "Fase C";

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: waliKelasSiswaC.text)
        .get();
    String uidWaliKelasnya = querySnapshot.docs.first.data()['uid'];

    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('kelastahunajaran')
        .doc(argumentKelas)
        .set({
      'namakelas': argumentKelas,
      'fase': faseNya,
      'walikelas': waliKelasSiswaC.text,
      'idwalikelas': uidWaliKelasnya,
      'tahunajaran': tahunajaranya,
      'emailpenginput': emailAdmin,
      'idpenginput': idUser,
      'tanggalinput': DateTime.now().toIso8601String(),
    });
  }

  Future<void> buatIsiSemester1() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String kelasNya = argumentKelas.substring(0, 1);
    String faseNya = (kelasNya == '1' || kelasNya == '2')
        ? "Fase A"
        : (kelasNya == '3' || kelasNya == '4')
            ? "Fase B"
            : "Fase C";


    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: waliKelasSiswaC.text)
        .get();
    String uidWaliKelasnya = querySnapshot.docs.first.data()['uid'];

    //  QuerySnapshot<Map<String, dynamic>> querySnapshotSemester =
    //       await firestore
    //           .collection('Sekolah')
    //           .doc(idSekolah)
    //           .collection('tahunajaran')
    //           .doc(idTahunAjaran)
    //           .collection('kelastahunajaran')
    //           .doc(argumentKelas)
    //           .collection('semester')
    //           .get();
    //   if (querySnapshotSemester.docs.isNotEmpty) {
    //     Map<String, dynamic> dataSemester =
    //         querySnapshotSemester.docs.last.data();
    //     String semesterNya = dataSemester['namasemester'];

    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('kelastahunajaran')
        .doc(argumentKelas)
        .collection('semester')
        .doc('Semester I')
        .set({
      'namasemester': 'Semester I',
      'namakelas': argumentKelas,
      'fase': faseNya,
      'walikelas': waliKelasSiswaC.text,
      'idwalikelas': uidWaliKelasnya,
      'tahunajaran': tahunajaranya,
      'emailpenginput': emailAdmin,
      'idpenginput': idUser,
      'tanggalinput': DateTime.now().toIso8601String(),
    });
  }

  Future<void> tambahDaftarKelasGuruAjar() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String kelasNya = argumentKelas.substring(0, 1);
    String faseNya = (kelasNya == '1' || kelasNya == '2')
        ? "Fase A"
        : (kelasNya == '3' || kelasNya == '4')
            ? "Fase B"
            : "Fase C";

    //ambil data guru terpilih
    QuerySnapshot<Map<String, dynamic>> querySnapshotGuru = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: waliKelasSiswaC.text)
        .get();
    if (querySnapshotGuru.docs.isNotEmpty) {
      Map<String, dynamic> dataGuru = querySnapshotGuru.docs.first.data();
      String uidGuru = dataGuru['uid'];

      await firestore
          .collection('Sekolah')
          .doc(idSekolah)
          .collection('pegawai')
          .doc(uidGuru)
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
          .collection('pegawai')
          .doc(uidGuru)
          .collection('tahunajaran')
          .doc(idTahunAjaran)
          .collection('kelasnya')
          .doc(argumentKelas)
          .set({
        'namakelas': argumentKelas,
        'fase': faseNya,
        'tahunajaran': tahunajaranya,
        'emailpenginput': emailAdmin,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> tambahkanKelasSiswa(String namaSiswa, String nisnSiswa) async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String kelasNya = argumentKelas.substring(0, 1);
    String faseNya = (kelasNya == '1' || kelasNya == '2')
        ? "Fase A"
        : (kelasNya == '3' || kelasNya == '4')
            ? "Fase B"
            : "Fase C";

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: waliKelasSiswaC.text)
        .get();

    // Check if the query returned any documents
    // if (querySnapshot.docs.isEmpty) {
    //   Get.snackbar('Error',
    //       'Wali kelas tidak ditemukan. Pastikan alias wali kelas benar.');
    //   return; // Exit the function if no documents are found
    // }

    String uidWaliKelasnya = querySnapshot.docs.first.data()['uid'];

    CollectionReference<Map<String, dynamic>> colKelas = firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('kelastahunajaran');

    // try {
    DocumentSnapshot<Map<String, dynamic>> docIdKelas =
        await colKelas.doc(argumentKelas).get();

    if (docIdKelas.exists) {
      // Add the student to the existing class
      await firestore
          .collection('Sekolah')
          .doc(idSekolah)
          .collection('tahunajaran')
          .doc(idTahunAjaran)
          .collection('kelastahunajaran')
          .doc(argumentKelas)
          .collection('semester')
          .doc('semester I')
          .collection('daftarsiswa')
          .doc(nisnSiswa)
          .set({
        'namasiswa': namaSiswa,
        'nisn': nisnSiswa,
        'fase': faseNya,
        'namakelas': docIdKelas['namakelas'],
        'namasemester': 'Semester I',
        'walikelas': docIdKelas['walikelas'],
        'idwalikelas': docIdKelas['idwalikelas'],
        'emailpenginput': emailAdmin,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now().toIso8601String(),
        'status': 'aktif',
        'idsiswa': nisnSiswa,
        'statuskelompok': 'baru',
      });
      ubahStatusSiswa(nisnSiswa);
    } else {
      // Handle the case where the class does not exist
      Get.snackbar(
          'Error', 'Kelas tidak ditemukan. Pastikan data kelas benar.');
    }
    if (!docIdKelas.exists) {
      // Get.snackbar(
      //     'Error', 'Kelas tidak ditemukan. Pastikan data kelas benar.');
      if (argumentKelas.isNotEmpty &&
          tahunajaranya.isNotEmpty &&
          waliKelasSiswaC.text.isNotEmpty) {
        buatIsiKelasTahunAjaran();
        buatIsiSemester1();
        tambahDaftarKelasGuruAjar();

        await firestore
            .collection('Sekolah')
            .doc(idSekolah)
            .collection('tahunajaran')
            .doc(idTahunAjaran)
            .collection('kelastahunajaran')
            .doc(argumentKelas)
            .collection('semester')
            .doc('Semester I')
            .collection('daftarsiswa')
            .doc(nisnSiswa)
            .set({
          'namasiswa': namaSiswa,
          'nisn': nisnSiswa,
          'fase': faseNya,
          'namakelas': argumentKelas,
          'namasemester': 'Semester I',
          'walikelas': waliKelasSiswaC.text,
          'idwalikelas': uidWaliKelasnya,
          'emailpenginput': emailAdmin,
          'idpenginput': idUser,
          'tanggalinput': DateTime.now().toIso8601String(),
          'status': 'aktif',
          'idsiswa': nisnSiswa,
          'statuskelompok': 'baru',
        });

        ubahStatusSiswa(nisnSiswa);
      }
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDataWali() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    CollectionReference<Map<String, dynamic>> colKelas = firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('kelastahunajaran');

    try {
      // DocumentSnapshot<Map<String, dynamic>> docIdKelas =
      //     await colKelas.doc(argumentKelas).get();
      // Add your logic here if needed
      // if (docIdKelas.exists) {
      //   print('namakelas = ${docIdKelas['namakelas']}');
      //   print('walikelas = ${docIdKelas['walikelas']}');
      // } else {
      //   print('kelas tidak ada');
      // }
      return await colKelas.get();
      // Example return statement
    } catch (e) {
      // print('Error occurred: $e');
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<void> testinputkelas(String namaSiswa, String nisnSiswa) async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    String kelasNya = argumentKelas.substring(0, 1);
    String faseNya = (kelasNya == '1' || kelasNya == '2')
        ? "Fase A"
        : (kelasNya == '3' || kelasNya == '4')
            ? "Fase B"
            : "Fase C";

    CollectionReference<Map<String, dynamic>> colKelas = firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('kelastahunajaran');

    DocumentSnapshot<Map<String, dynamic>> docIdKelas =
        await colKelas.doc(argumentKelas).get();

    if (docIdKelas.exists) {
      // QuerySnapshot<Map<String, dynamic>> querySnapshotSemester =
      //     await firestore
      //         .collection('Sekolah')
      //         .doc(idSekolah)
      //         .collection('tahunajaran')
      //         .doc(idTahunAjaran)
      //         .collection('kelastahunajaran')
      //         .doc(argumentKelas)
      //         .collection('semester')
      //         .get();
      // if (querySnapshotSemester.docs.isNotEmpty) {
      //   Map<String, dynamic> dataSemester =
      //       querySnapshotSemester.docs.last.data();
      //   String semesterNya = dataSemester['namasemester'];

      print('kelas ada ${docIdKelas['namakelas']}');
      print('ini fasenya = $faseNya');
      print('nama Siswa = $namaSiswa');
      print('nisn Siswa = $nisnSiswa');

      await firestore
          .collection('Sekolah')
          .doc(idSekolah)
          .collection('tahunajaran')
          .doc(idTahunAjaran)
          .collection('kelastahunajaran')
          .doc(argumentKelas)
          .collection('semester')
          .doc('Semester I')
          .collection('daftarsiswa')
          .doc(nisnSiswa)
          .set({
        'namasiswa': namaSiswa,
        'nisn': nisnSiswa,
        'fase': faseNya,
        'namakelas': docIdKelas['namakelas'],
        'namasemester': 'Semester I',
        'walikelas': docIdKelas['walikelas'],
        'idwalikelas': docIdKelas['idwalikelas'],
        'emailpenginput': emailAdmin,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now().toIso8601String(),
        'status': 'aktif',
        'idsiswa': nisnSiswa,
        'statuskelompok': 'baru',
      });
      ubahStatusSiswa(nisnSiswa);
    }
    else if (!docIdKelas.exists) {
      try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('Sekolah')
          .doc(idSekolah)
          .collection('pegawai')
          .where('alias', isEqualTo: waliKelasSiswaC.text)
          .get();

      String uidWaliKelasnya = querySnapshot.docs.first.data()['uid'];

      print('kelas tidak ada');
      print('waliKelasSiswaC.text = ${waliKelasSiswaC.text}');
      print("===============================");
      print('nama Siswa = $namaSiswa');
      print('nisn Siswa = $nisnSiswa');
      print("===============================");
      // print('uidWaliKelasnya = $uidWaliKelasnya');
      if (uidWaliKelasnya.isEmpty) {
        Get.snackbar('Peringatan', 'Wali kelas tidak oleh kosong');
      } 
      else {
        buatIsiKelasTahunAjaran();
        buatIsiSemester1();
        tambahDaftarKelasGuruAjar();

        await firestore
            .collection('Sekolah')
            .doc(idSekolah)
            .collection('tahunajaran')
            .doc(idTahunAjaran)
            .collection('kelastahunajaran')
            .doc(argumentKelas)
            .collection('semester')
            .doc('Semester I')
            .collection('daftarsiswa')
            .doc(nisnSiswa)
            .set({
          'namasiswa': namaSiswa,
          'nisn': nisnSiswa,
          'fase': faseNya,
          'namakelas': argumentKelas,
          'namasemester': 'Semester I',
          'walikelas': waliKelasSiswaC.text,
          'idwalikelas': uidWaliKelasnya,
          'emailpenginput': emailAdmin,
          'idpenginput': idUser,
          'tanggalinput': DateTime.now().toIso8601String(),
          'status': 'aktif',
          'idsiswa': nisnSiswa,
          'statuskelompok': 'baru',
        });

        ubahStatusSiswa(nisnSiswa);
      }
      } catch (e) {
        Get.snackbar('Error', 'periksa.. !! apakah wali kelas belum terisi..');
      }
    }
  }

  void test() async {
    print('argumentKelas = $argumentKelas');
  }
}
