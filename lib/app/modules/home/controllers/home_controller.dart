import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:guru_project/app/routes/app_pages.dart';
// import '../widgets/home_widget.dart';
import '../widgets/contoh.dart';
import '../widgets/profile_widget.dart';

class HomeController extends GetxController {
  RxInt indexWidget = 0.obs;
  RxBool isLoading = false.obs;

  TextEditingController nipC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController noHpC = TextEditingController();
  TextEditingController alamatC = TextEditingController();
  TextEditingController jabatanC = TextEditingController();

  //=======================================================
  TextEditingController tempatC = TextEditingController();
  TextEditingController semesterC = TextEditingController();
  TextEditingController pengampuC = TextEditingController();
  TextEditingController kelasBaruC = TextEditingController();
  TextEditingController tahunAjaranBaruC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String idUser = FirebaseAuth.instance.currentUser!.uid;
  String idSekolah = 'UQjMpsKZKmWWbWVu4Uwb';
  String emailAdmin = FirebaseAuth.instance.currentUser!.email!;

  // REGION LAMA

  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection('Pegawai').doc(uid).snapshots();
  }

  //percobaan menampilkan contoh collection
  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfile() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection('Pegawai').doc(uid).snapshots();
  }

  void changeIndex(int index) {
    indexWidget.value = index;
  }

  void signOut() async {
    isLoading.value = true;
    await auth.signOut();
    isLoading.value = false;
    Get.offAllNamed('/login');
  }

  // ini adalah list widget yang akan di tampilkan pada halaman home
  final List<Widget> myWidgets = [
    Contoh(),
    // HomeWidget(),
    Center(
      child: Text(
        'PROSES PENGEMBANGAN',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
        ),
      ),
    ),
    ProfileWidget(),
  ];

  // void updateProfile() async {
  Future<void> updateProfile() async {
    isLoading.value = true;
    String uid = auth.currentUser!.uid;

    await firestore.collection('Sekolah').doc(idSekolah).collection('pegawai').doc(uid).update({
      'nip': nipC.text,
      'nama': namaC.text,
      'email': emailC.text,
      'noHp': noHpC.text,
      // 'alamat': alamatC.text,
      // 'jabatan': jabatanC.text,
    });

    isLoading.value = false;
    Get.snackbar(
      'Berhasil',
      'Data berhasil diupdate',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  

  // END REGION LAMA

  //============================

  // REGION BARU

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

  Stream<DocumentSnapshot<Map<String, dynamic>>> userStreamBaru() async* {
    // String tahunajaranya = await getTahunAjaranTerakhir();
    // String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    yield* firestore
        .collection('Sekolah')
        .doc(idSekolah)
        // .collection('tahunajaran')
        // .doc(idTahunAjaran)
        .collection('pegawai')
        .doc(idUser)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfileBaru() async* {
    yield* firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .doc(idUser)
        .snapshots();
  }

  Future<List<String>> getDataKelasYangDiajar() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    List<String> kelasList = [];
    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .doc(idUser)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('kelasnya')
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        kelasList.add(docSnapshot.id);
      }
    });
    return kelasList;
  }

  Future<List<String>> getDataFase() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String idSemester = 'Semester I';  // nanti ini diambil dari database

    List<String> faseList = [];
    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('semester')
        .doc(idSemester)
        .collection('kelompokmengaji')
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        faseList.add(docSnapshot.id);
      }
    });
    return faseList;
  }

  Future<List<String>> getDataKelompok() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String idSemester = 'Semester I';

    List<String> kelasList = [];
    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .doc(idUser)
        .collection('tahunajarankelompok')
        .doc(idTahunAjaran)
        .collection('semester')
        .doc(idSemester)
        .collection('kelompokmengaji')
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        kelasList.add(docSnapshot.id);
      }
    });
    // print('ini kelasList : $kelasList');
    return kelasList;
    // }
    // return [];
  }

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

  Future<List<String>> getDataSemuaKelas() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    List<String> kelasList = [];
    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('kelastahunajaran')
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        kelasList.add(docSnapshot.id);
      }
    });
    return kelasList;
  }

//===========================================================
//**
// ini untuk tambah kelompok
// */

  Future<List<String>> getDataPengampu() async {
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
      }
    });
    return walikelasList;
  }

  List<String> getDataTempat() {
    List<String> temaptList = [
      'masjid',
      'aula',
      'kelas',
      'lab',
      'dll',
    ];
    return temaptList;
  }

  List<String> getDataSemester() {
    List<String> temaptList = [
      'semester1',
      'semester2',
    ];
    return temaptList;
  }

  Future<void> isiTahunAjaranKelompokPadaPegawai() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String semesterNya =
        (semesterC.text == 'semester1') ? "Semester I" : "Semester II";
    QuerySnapshot<Map<String, dynamic>> querySnapshotGuru = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: pengampuC.text)
        .get();
    if (querySnapshotGuru.docs.isNotEmpty) {
      Map<String, dynamic> dataGuru = querySnapshotGuru.docs.first.data();
      String idPengampu = dataGuru['uid'];

      await firestore
          .collection('Sekolah')
          .doc(idSekolah)
          .collection('pegawai')
          .doc(idPengampu)
          .collection('tahunajarankelompok')
          .doc(idTahunAjaran)
          .set({'namatahunajaran': tahunajaranya});

      await firestore
          .collection('Sekolah')
          .doc(idSekolah)
          .collection('pegawai')
          .doc(idPengampu)
          .collection('tahunajarankelompok')
          .doc(idTahunAjaran)
          .collection('semester')
          .doc(semesterNya)
          .set({
        'namasemester': semesterNya,
        'tahunajaran': tahunajaranya,
        'emailpenginput': emailAdmin,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now(),
      });
    }
  }

  Future<void> isiFieldPengampuKelompok() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String idKelompokmengaji = "${pengampuC.text} ${tempatC.text}";

    String semesterNya =
        (semesterC.text == 'semester1') ? "Semester I" : "Semester II";

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: pengampuC.text)
        .get();
    String idPengampu = querySnapshot.docs.first.data()['uid'];

    isiTahunAjaranKelompokPadaPegawai();

    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('semester')
        .doc(semesterNya)
        .collection('kelompokmengaji')
        .doc(idKelompokmengaji)
        .set({
      'namasemester': semesterNya,
      'kelompokmengaji': idKelompokmengaji,
      'idpengampu': idPengampu,
      'namapengampu': pengampuC.text,
      'tempatmengaji': tempatC.text,
      'tahunajaran': tahunajaranya,
      'emailpenginput': emailAdmin,
      'idpenginput': idUser,
      'tanggalinput': DateTime.now(),
    });
  }

  Future<void> buatIsiSemester1() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    String semesterNya =
        (semesterC.text == 'semester1') ? "Semester I" : "Semester II";

    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('semester')
        .doc(semesterNya)
        .set({
      'namasemester': semesterNya,
      'tahunajaran': tahunajaranya,
      'emailpenginput': emailAdmin,
      'idpenginput': idUser,
      'tanggalinput': DateTime.now(),
    });
  }

  Future<void> tambahDaftarKelompokPengampuAjar() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String idKelompokmengaji = "${pengampuC.text} ${tempatC.text}";

    String semesterNya =
        (semesterC.text == 'semester1') ? "Semester I" : "Semester II";

    //ambil data guru terpilih .. ini nggak perlu dirubah
    QuerySnapshot<Map<String, dynamic>> querySnapshotGuru = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: pengampuC.text)
        .get();
    if (querySnapshotGuru.docs.isNotEmpty) {
      Map<String, dynamic> dataGuru = querySnapshotGuru.docs.first.data();
      String idPengampu = dataGuru['uid'];

      await firestore
          .collection('Sekolah')
          .doc(idSekolah)
          .collection('pegawai')
          .doc(idPengampu)
          .collection('tahunajarankelompok')
          .doc(idTahunAjaran)
          .collection('semester')
          .doc(semesterNya)
          .collection('kelompokmengaji')
          .doc(idKelompokmengaji)
          .set({
        'tahunajaran': tahunajaranya,
        'kelompokmengaji': idKelompokmengaji,
        'namasemester': semesterNya,
        'namapengampu': pengampuC.text,
        'idpengampu': idPengampu,
        'emailpenginput': emailAdmin,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now(),
        'tempatmengaji': tempatC.text,
      });
    }
  }

  Future<void> tambahkanKelompokSiswa() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    // String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    // String idKelompokmengaji = "${pengampuC.text} ${tempatC.text}";
    String semesterNya =
        (semesterC.text == 'semester1') ? "Semester I" : "Semester II";

    // QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
    //     .collection('Sekolah')
    //     .doc(idSekolah)
    //     .collection('pegawai')
    //     .where('alias', isEqualTo: pengampuC.text)
    //     .get();
    // String idPengampu = querySnapshot.docs.first.data()['uid'];

    if (tahunajaranya.isNotEmpty &&
        semesterNya.isNotEmpty &&
        pengampuC.text.isNotEmpty) {
      try {
        isiFieldPengampuKelompok();
        buatIsiSemester1();
        tambahDaftarKelompokPengampuAjar();
      } catch (e) {
        Get.snackbar('Error', e.toString());
      }
    } else {
      Get.snackbar('Error', 'pengampu dan tempat tidak boleh kosong');
    }
  }

  Future<void> buatKelompokMengaji() async {
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Buat Kelompok Mengaji'),
        ),
        body: Center(child: Text('data')),
      ),
    );
    
  }

  Future<void> simpanKelasBaru() async {
    String idSekolah = 'UQjMpsKZKmWWbWVu4Uwb';
    //ambil uid penginput
    String uid = auth.currentUser!.uid;
    String emailPenginput = auth.currentUser!.email!;

    CollectionReference<Map<String, dynamic>> colKelas = firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('kelas');
    QuerySnapshot<Map<String, dynamic>> snapshotKelas =
        await colKelas.get();
    List<Map<String, dynamic>> listKelas =
        snapshotKelas.docs.map((e) => e.data()).toList();

    // buat documen id buat tahun kelas
    String idKelas = kelasBaruC.text;

    if (listKelas.elementAt(0)['namakelas'] != kelasBaruC.text) {
      if (!listKelas
          .any((element) => element['namakelas'] == kelasBaruC.text)) {
        //belum input tahun kelas yang baru, maka bikin tahun kelas baru
        colKelas.doc(idKelas).set({
          'namakelas': kelasBaruC.text,
          'idpenginput': uid,
          'emailpenginput' : emailPenginput,
          'tanggalinput': DateTime.now().toString(),
          'idkelas' : idKelas,
        }).then(
          (value) {
              Get.snackbar('Berhasil', 'Kelas Baru Berhasil Dibuat');
              kelasBaruC.text = "";
          }
        );
      } else {
        Get.snackbar('Gagal', 'Kelas Sudah Ada');
      } 
    }
  }

  Future<void> simpanTahunAjaran() async {
    String idSekolah = 'UQjMpsKZKmWWbWVu4Uwb';
    String uid = auth.currentUser!.uid;
    String emailPenginput = auth.currentUser!.email!;

    DocumentReference<Map<String, dynamic>> ambilDataPenginput = firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .doc(uid);

    DocumentSnapshot<Map<String, dynamic>> snapDataPenginput =
        await ambilDataPenginput.get();

    CollectionReference<Map<String, dynamic>> colTahunAjaran = firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran');
    QuerySnapshot<Map<String, dynamic>> snapshotTahunAjaran =
        await colTahunAjaran.get();
    List<Map<String, dynamic>> listTahunAjaran =
        snapshotTahunAjaran.docs.map((e) => e.data()).toList();

    //ambil namatahunajaranya
    listTahunAjaran.map((e) => e['namatahunajaran']).toList();

    // buat documen id buat tahun ajaran
    String idTahunAjaran = tahunAjaranBaruC.text.replaceAll("/", "-");

    if (listTahunAjaran.elementAt(0)['namatahunajaran'] != tahunAjaranBaruC.text) {
      if (!listTahunAjaran
          .any((element) => element['namatahunajaran'] == tahunAjaranBaruC.text)) {
        //belum input tahun ajaran yang baru, maka bikin tahun ajaran baru
        colTahunAjaran.doc(idTahunAjaran).set({
          'namatahunajaran': tahunAjaranBaruC.text,
          'idpenginput': uid,
          'emailpenginput': emailPenginput,
          'namapenginput': snapDataPenginput.data()?['nama'],
          'tanggalinput': DateTime.now().toString(),
          'idtahunajaran': idTahunAjaran,
        }).then(
          (value) => {
              Get.snackbar('Berhasil', 'Tahun ajaran sudah berhasil dibuat'),
              tahunAjaranBaruC.text = ""
          }
        );
      } else {
        Get.snackbar('Gagal', 'Tahun ajaran sudah ada');
      }
      // Get.back();
    }
    // Get.back();
  }
}


