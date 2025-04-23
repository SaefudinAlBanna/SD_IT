import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PemberianKelasSiswaController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingTambahKelas = false.obs;

  TextEditingController kelasSiswaC = TextEditingController();
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

  // ambil data namakelas
  Future<List<String>> getDataKelas() async {
    List<String> kelasList = [];
    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('kelas')
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        kelasList.add(docSnapshot.id);
      }
    });
    return kelasList;
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
    String kelasNya = kelasSiswaC.text.substring(0, 1);
    String faseNya = (kelasNya == '1' || kelasNya == '2')
        ? "FaseA"
        : (kelasNya == '3' || kelasNya == '4')
            ? "FaseB"
            : "FaseC";

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
        .doc(kelasSiswaC.text)
        .set({
      'namakelas': kelasSiswaC.text,
      'fase': faseNya,
      'walikelas': waliKelasSiswaC.text,
      'idwalikelas': uidWaliKelasnya,
      'tahunajaran': tahunajaranya,
      'emailpenginput': emailAdmin,
      'idpenginput': idUser,
      'tanggalinput': DateTime.now(),
    });
  }

  Future<void> buatIsiSemester1() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String kelasNya = kelasSiswaC.text.substring(0, 1);
    String faseNya = (kelasNya == '1' || kelasNya == '2')
        ? "FaseA"
        : (kelasNya == '3' || kelasNya == '4')
            ? "FaseB"
            : "FaseC";

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
        .doc(kelasSiswaC.text)
        .collection('semester')
        .doc('semester1')
        .set({
      'namasemester': 'semester I',
      'namakelas': kelasSiswaC.text,
      'fase': faseNya,
      'walikelas': waliKelasSiswaC.text,
      'idwalikelas': uidWaliKelasnya,
      'tahunajaran': tahunajaranya,
      'emailpenginput': emailAdmin,
      'idpenginput': idUser,
      'tanggalinput': DateTime.now(),
    });
  }

  Future<void> tambahDaftarKelasGuruAjar() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String kelasNya = kelasSiswaC.text.substring(0, 1);
    String faseNya = (kelasNya == '1' || kelasNya == '2')
        ? "FaseA"
        : (kelasNya == '3' || kelasNya == '4')
            ? "FaseB"
            : "FaseC";

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
        'tanggalinput': DateTime.now(),
      });

      await firestore
          .collection('Sekolah')
          .doc(idSekolah)
          .collection('pegawai')
          .doc(uidGuru)
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
        'tanggalinput': DateTime.now(),
      });
    }
  }

  Future<void> tambahkanKelasSiswa(String namaSiswa, String nisnSiswa) async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String kelasNya = kelasSiswaC.text.substring(0, 1);
    String faseNya = (kelasNya == '1' || kelasNya == '2')
        ? "FaseA"
        : (kelasNya == '3' || kelasNya == '4')
            ? "FaseB"
            : "FaseC";

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: waliKelasSiswaC.text)
        .get();
    String uidWaliKelasnya = querySnapshot.docs.first.data()['uid'];

    if (kelasSiswaC.text.isNotEmpty && tahunajaranya.isNotEmpty && waliKelasSiswaC.text.isNotEmpty) {
      try {
        buatIsiKelasTahunAjaran();
        buatIsiSemester1();
        tambahDaftarKelasGuruAjar();

        await firestore
            .collection('Sekolah')
            .doc(idSekolah)
            .collection('tahunajaran')
            .doc(idTahunAjaran)
            .collection('kelastahunajaran')
            .doc(kelasSiswaC.text)
            .collection('semester')
            .doc('semester1')
            .collection('daftarsiswasemester1')
            .doc(nisnSiswa)
            .set({
          'namasiswa': namaSiswa,
          'nisn': nisnSiswa,
          'fase': faseNya,
          'kelas': kelasSiswaC.text,
          'semester': 'semester I',
          'walikelas': waliKelasSiswaC.text,
          'idwalikelas': uidWaliKelasnya,
          'emailpenginput': emailAdmin,
          'idpenginput': idUser,
          'tanggalinput': DateTime.now(),
          'status': 'aktif',
          'idsiswa': nisnSiswa,
          'statuskelompok' : 'baru',
        });

        ubahStatusSiswa(nisnSiswa);
      } catch (e) {
        Get.snackbar('Error', e.toString());
      }
    } else {
      Get.snackbar('Error', 'Kelas dan Wali kelas tidak boleh kosong');
    }
  }
}
