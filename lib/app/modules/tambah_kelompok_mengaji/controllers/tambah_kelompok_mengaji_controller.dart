import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guru_project/app/routes/app_pages.dart';

class TambahKelompokMengajiController extends GetxController {
  TextEditingController idPegawaiC = TextEditingController();
  TextEditingController kelasSiswaC = TextEditingController();
  TextEditingController tempatC = TextEditingController();
  TextEditingController semesterC = TextEditingController();
  TextEditingController pengampuC = TextEditingController();
  TextEditingController faseC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String idUser = FirebaseAuth.instance.currentUser!.uid;
  String idSekolah = 'UQjMpsKZKmWWbWVu4Uwb';
  String emailAdmin = FirebaseAuth.instance.currentUser!.email!;
  // late String idKelompokmengaji;

  // @override
  // void onInit() {
  //   super.onInit();
  //   idKelompokmengaji = "${pengampuC.text} ${tempatC.text}";
  // }

  //**
  // ini yang dipake dalam page tambah
  // database masuk pada tahun ajaran
  // */

  //pengambilan tahun ajaran terakhir

  // --> C1
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

  // --> C2
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

  // --> C3
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

  // --> C4
  List<String> getDataSemester() {
    List<String> temaptList = [
      'semester1',
      'semester2',
    ];
    return temaptList;
  }

  List<String> getDataFase() {
    List<String> faseList = [
      'Fase A',
      'Fase B',
      'Fase C',
    ];
    return faseList;
  }

  // --> C5 --> muncul di Get.bottomSheet
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
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        kelasList.add(docSnapshot.id);
      }
    });
    return kelasList;
  }

  // --> C6 --> di dalam Get.bottomSheet
  Future<QuerySnapshot<Map<String, dynamic>>> getDataSiswa() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    return await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('kelastahunajaran')
        .doc(kelasSiswaC.text)
        .collection('semester')
        .doc(semesterC
            .text) // ini nanti diganti otomatis // sudah di pasang -->> kalo sudah dihapus comment
        .collection('daftarsiswasemester1')
        .where('statuskelompok', isEqualTo: 'baru')
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDataSiswaStream() async* {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    yield* firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('kelastahunajaran')
        .doc(kelasSiswaC.text)
        .collection('semester')
        .doc(semesterC
            .text) // ini nanti diganti otomatis // sudah di pasang -->> kalo sudah dihapus comment
        .collection('daftarsiswasemester1')
        .where('statuskelompok', isEqualTo: 'baru')
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

  Future<void> buatKelompok() async {

    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String semesterNya = 
    (semesterC.text == 'semester1') ? "Semester I" : "Semester II";
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: pengampuC.text)
        .get();
    String idPengampu = querySnapshot.docs.first.data()['uid'];

    
    if (faseC.text.isNotEmpty &&
        tahunajaranya.isNotEmpty &&
        pengampuC.text.isNotEmpty &&
        tempatC.text.isNotEmpty && 
        semesterNya.isNotEmpty 
        ) {
         
      try {
        // buatIsiKelompokMengajiTahunAjaran();
        isiFieldPengampuKelompok();
        buatIsiSemester1();
        

        await firestore
            .collection('Sekolah')
            .doc(idSekolah)
            .collection('tahunajaran')
            .doc(idTahunAjaran)
            .collection('semester')
            .doc(semesterNya)
            .collection('kelompokmengaji')
            .doc(faseC.text)
            .set({
          'fase': faseC.text,
          'tahunajaran': tahunajaranya,
          'semester': semesterNya,
          'emailpenginput': emailAdmin,
          'idpenginput': idUser,
          'tanggalinput': DateTime.now(),
        });

        await firestore
            .collection('Sekolah')
            .doc(idSekolah)
            .collection('tahunajaran')
            .doc(idTahunAjaran)
            .collection('semester')
            .doc(semesterNya)
            .collection('kelompokmengaji')
            .doc(faseC.text)
            .collection('pengampu')
            .doc(pengampuC.text)
            .collection('tempat')
            .doc(tempatC.text)
            .set({
          'fase' : faseC.text,
          'tempatmengaji': tempatC.text,
          'tahunajaran': tahunajaranya,
          'kelompokmengaji': pengampuC.text,
          'namasemester': semesterNya,
          'namapengampu': pengampuC.text,
          'idpengampu': idPengampu,
          'emailpenginput': emailAdmin,
          'idpenginput': idUser,
          'tanggalinput': DateTime.now(),
        });

        Get.snackbar('Sukses', 'Kelompok mengaji berhasil dibuat');

        Get.offAllNamed(Routes.TAMBAH_SISWA_KELOMPOK,
                        arguments: pengampuC.text);

        refresh();

       
      } catch (e) {
        Get.snackbar('Error', e.toString());
      }
    } else {
      Get.snackbar('Error', 'tidak boleh kosong');
    }
        refresh();
    
  }

  // --> C7 --> di dalam Get.bottomSheet --> simpan siswa kelompok yang dipilih
  Future<void> tambahkanKelompokSiswa(
      String namaSiswa, String nisnSiswa) async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String kelasNya = kelasSiswaC.text.substring(0, 1);
    // String idKelompokmengaji = "${pengampuC.text} ${tempatC.text}";
    String faseNya = (kelasNya == '1' || kelasNya == '2')
        ? "FaseA"
        : (kelasNya == '3' || kelasNya == '4')
            ? "FaseB"
            : "FaseC";
    String semesterNya =
        (semesterC.text == 'semester1') ? "Semester I" : "Semester II";

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: pengampuC.text)
        .get();
    String idPengampu = querySnapshot.docs.first.data()['uid'];

    if (kelasSiswaC.text.isNotEmpty &&
        tahunajaranya.isNotEmpty &&
        semesterNya.isNotEmpty &&
        pengampuC.text.isNotEmpty) {
      try {
        // buatIsiKelompokMengajiTahunAjaran();
        isiFieldPengampuKelompok();
        buatIsiSemester1();
        tambahDaftarKelompokPengampuAjar(nisnSiswa, namaSiswa);

        await firestore
            .collection('Sekolah')
            .doc(idSekolah)
            .collection('tahunajaran')
            .doc(idTahunAjaran)
            .collection('semester')
            .doc(semesterNya)
            .collection('kelompokmengaji')
            .doc(pengampuC.text)
            .collection('tempat')
            .doc(tempatC.text)
            .set({
          'tempatmengaji': tempatC.text,
          'tahunajaran': tahunajaranya,
          'kelompokmengaji': pengampuC.text,
          'namasemester': semesterNya,
          'namapengampu': pengampuC.text,
          'idpengampu': idPengampu,
          'emailpenginput': emailAdmin,
          'idpenginput': idUser,
          'tanggalinput': DateTime.now(),
        });

        await firestore
            .collection('Sekolah')
            .doc(idSekolah)
            .collection('tahunajaran')
            .doc(idTahunAjaran)
            .collection('semester')
            .doc(semesterNya)
            .collection('kelompokmengaji')
            .doc(pengampuC.text)
            .collection('tempat')
            .doc(tempatC.text)
            .collection('daftarsiswakelompok')
            .doc(nisnSiswa)
            .set({
          'namasiswa': namaSiswa,
          'nisn': nisnSiswa,
          'kelas': kelasSiswaC.text,
          'fase': faseNya,
          'tahunajaran': tahunajaranya,
          'kelompoksiswa': pengampuC.text,
          'semester': semesterNya,
          'pengampu': pengampuC.text,
          'idpengampu': idPengampu,
          'emailpenginput': emailAdmin,
          'idpenginput': idUser,
          'tanggalinput': DateTime.now(),
          'idsiswa': nisnSiswa,
        });

        ubahStatusSiswa(nisnSiswa);
      } catch (e) {
        Get.snackbar('Error', e.toString());
      }
    } else {
      Get.snackbar('Error', 'pengampu dan tempat tidak boleh kosong');
    }
  }

  // --> C7 --> di dalam Get.bottomSheet --> tampilkan siswa kelompok yang terpilih
  Stream<QuerySnapshot<Map<String, dynamic>>> tampilSiswaKelompok() async* {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    // String idKelompokmengaji = "${pengampuC.text} ${tempatC.text}";
    String semesterNya =
        (semesterC.text == 'semester1') ? "Semester I" : "Semester II";

    yield* firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('semester')
        .doc(semesterNya)
        .collection('kelompokmengaji')
        .doc(pengampuC.text)
        .collection('tempat')
        .doc(tempatC.text)
        .collection('daftarsiswakelompok')
        .snapshots();
  }

  //**
  // ini yang di inputkan kedalam database guru
  //
  // */

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

  // input ke database kelompok mengaji
  //==================================================
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

  // ini gak dipake karena di db tahun ajaran ada double
  Future<void> buatIsiKelompokMengajiTahunAjaran() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    String semesterNya =
        (semesterC.text == 'semester1') ? "Semester I" : "Semester II";

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: pengampuC.text)
        .get();
    String idPengampu = querySnapshot.docs.first.data()['uid'];

    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('semester')
        .doc(semesterC.text)
        .collection('kelompokmengaji')
        .doc(pengampuC.text)
        .set({
      'namasemester': semesterNya,
      'pengampu': pengampuC.text,
      'idpengampu': idPengampu,
      'tahunajaran': tahunajaranya,
      'emailpenginput': emailAdmin,
      'idpenginput': idUser,
      'tanggalinput': DateTime.now(),
    });
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
          .doc(faseC.text)
          .set({
        'fase' : faseC.text,
        'tempatmengaji': tempatC.text,
        'namapengampu': pengampuC.text,
        'idpengampu': idPengampu,
        'namasemester': semesterNya,
        'tahunajaran': tahunajaranya,
        'emailpenginput': emailAdmin,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now(),
      });

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
          .doc(faseC.text)
          .collection('tempat')
          .doc(tempatC.text)
          .set({
        'fase' : faseC.text,
        'tempatmengaji': tempatC.text,
        'namapengampu': pengampuC.text,
        'idpengampu': idPengampu,
        'namasemester': semesterNya,
        'tahunajaran': tahunajaranya,
        'emailpenginput': emailAdmin,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now(),
      });
    }
  }

  // buat isian field untuk pengampu di db kelompok yg di tahun ajaran
  Future<void> isiFieldPengampuKelompok() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    // String idKelompokmengaji = "${pengampuC.text} ${tempatC.text}";

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
        .doc(faseC.text)
        .collection('pengampu')
        .doc(pengampuC.text)
        .collection('tempat')
        .doc(tempatC.text)
        .set({
      'fase' : faseC.text,
      'tempatmengaji': tempatC.text,
      'tahunajaran': tahunajaranya,
      'kelompokmengaji': pengampuC.text,
      'namasemester': semesterNya,
      'namapengampu': pengampuC.text,
      'idpengampu': idPengampu,
      'emailpenginput': emailAdmin,
      'idpenginput': idUser,
      'tanggalinput': DateTime.now(),
    });

    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('semester')
        .doc(semesterNya)
        .collection('kelompokmengaji')
        .doc(faseC.text)
        .collection('pengampu')
        .doc(pengampuC.text)
        .set({
      'fase' : faseC.text,
      'namasemester': semesterNya,
      'kelompokmengaji': pengampuC.text,
      'idpengampu': idPengampu,
      'namapengampu': pengampuC.text,
      'tempatmengaji': tempatC.text,
      'tahunajaran': tahunajaranya,
      'emailpenginput': emailAdmin,
      'idpenginput': idUser,
      'tanggalinput': DateTime.now(),
    });
  }

  // tambah daftar kelas guru ajar -->> nanti disesuaikan daftar kelompok pengampu  >> kalo sudah komen dihapus
  Future<void> tambahDaftarKelompokPengampuAjar(
      String nisnSiswa, String namaSiswa) async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    // String idKelompokmengaji = "${pengampuC.text} ${tempatC.text}";

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
          .doc(faseC.text)
          .collection('pengampu')
          .doc(pengampuC.text)
          .set({
        'fase' : faseC.text,
        'tahunajaran': tahunajaranya,
        'kelompokmengaji': pengampuC.text,
        'namasemester': semesterNya,
        'namapengampu': pengampuC.text,
        'idpengampu': idPengampu,
        'emailpenginput': emailAdmin,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now(),
        'tempatmengaji': tempatC.text,
      });

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
          .doc(faseC.text)
          .collection('pengampu')
          .doc(pengampuC.text)
          .collection('tempat')
          .doc(tempatC.text)
          .set({
        'fase' : faseC.text,
        'tahunajaran': tahunajaranya,
        'kelompokmengaji': pengampuC.text,
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

  //tambah atau buat kelompok mengaji pada database
  Future<void> buatKelompokMengaji() async {
    Get.defaultDialog(
        title: 'Konfirmasi',
        middleText: 'Silahkan di isi',
        actions: [
          Column(
            children: [
              SizedBox(
                height: 50,
                width: Get.width,
                child: DropdownSearch<String>(
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      labelText: 'Pengampu',
                    ),
                  ),
                  selectedItem:
                      pengampuC.text.isNotEmpty ? pengampuC.text : null,
                  items: (f, cs) => getDataPengampu(),
                  onChanged: (String? value) {
                    if (value != null) {
                      pengampuC.text = value;
                      // print('ini onchange : ${pengampuC.text}');
                    }
                  },
                  popupProps: PopupProps.menu(fit: FlexFit.tight),
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                height: 50,
                width: Get.width,
                child: DropdownSearch<String>(
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      labelText: 'Tempat',
                    ),
                  ),
                  selectedItem: tempatC.text.isNotEmpty ? tempatC.text : null,
                  items: (f, cs) => getDataTempat(),
                  onChanged: (String? value) {
                    if (value != null) {
                      tempatC.text = value;
                      // print('ini onchange : ${tempatC.text}');
                    }
                  },
                  popupProps: PopupProps.menu(fit: FlexFit.tight),
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                height: 50,
                width: Get.width,
                child: DropdownSearch<String>(
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      labelText: 'Semester',
                    ),
                  ),
                  selectedItem:
                      semesterC.text.isNotEmpty ? semesterC.text : null,
                  items: (f, cs) => getDataSemester(),
                  onChanged: (String? value) {
                    if (value != null) {
                      semesterC.text = value;
                      // print('ini onchange : ${semesterC.text}');
                    }
                  },
                  popupProps: PopupProps.menu(fit: FlexFit.tight),
                ),
              ),
            ],
          ),
          OutlinedButton(
              onPressed: () {
                // isLoading.value = false;
                Get.back();
              },
              child: Text('CANCEL')),
          ElevatedButton(
              onPressed: () {
                // Get.offAllNamed(Routes.TAMBAH_SISWA_KELOMPOK);
              },
              child: Text('Buat'))
        ]);
    // }
  }

  // ubah / update siswa sudah punya kelompok  >> kalo sudah komen dihapus
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
        .doc(semesterC.text)
        .collection('daftarsiswasemester1')
        .doc(nisnSiSwa)
        .update({
      'statuskelompok': 'aktif',
    });
  }
}
