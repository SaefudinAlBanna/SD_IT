import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahSiswaKelompokController extends GetxController {
  var argumenPengampu = Get.arguments;
  TextEditingController kelasSiswaC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String idUser = FirebaseAuth.instance.currentUser!.uid;
  String idSekolah = 'UQjMpsKZKmWWbWVu4Uwb';
  String emailAdmin = FirebaseAuth.instance.currentUser!.email!;

  String namaAdmin = FirebaseAuth.instance.currentUser!.displayName!;

  // Removed duplicate declaration of getTahunAjaranTerakhir

  Stream<DocumentSnapshot<Map<String, dynamic>>> getIsiBaru() async* {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    QuerySnapshot<Map<String, dynamic>> querySnapshotKelompok = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: argumenPengampu)
        .get();
    if (querySnapshotKelompok.docs.isNotEmpty) {
      Map<String, dynamic> dataGuru = querySnapshotKelompok.docs.first.data();
      String idPengampu = dataGuru['uid'];

      QuerySnapshot<Map<String, dynamic>> querySnapshotSemester =
          await firestore
              .collection('Sekolah')
              .doc(idSekolah)
              .collection('pegawai')
              .doc(idPengampu)
              .collection('tahunajarankelompok')
              .doc(idTahunAjaran)
              .collection('semester')
              .get();
      if (querySnapshotSemester.docs.isNotEmpty) {
        Map<String, dynamic> dataSemester =
            querySnapshotSemester.docs.last.data();
        String semesterNya = dataSemester['namasemester'];

        QuerySnapshot<Map<String, dynamic>> querySnapshotFase = await firestore
            .collection('Sekolah')
            .doc(idSekolah)
            .collection('pegawai')
            .doc(idPengampu)
            .collection('tahunajarankelompok')
            .doc(idTahunAjaran)
            .collection('semester')
            .doc(semesterNya)
            .collection('kelompokmengaji')
            .get();
        if (querySnapshotFase.docs.isNotEmpty) {
          Map<String, dynamic> dataFase = querySnapshotFase.docs.last.data();
          String faseNya = dataFase['fase'];

          QuerySnapshot<Map<String, dynamic>> querySnapshotTempat =
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
                  .doc(faseNya)
                  .collection('tempat')
                  .orderBy('tanggalinput')
                  .get();
          if (querySnapshotTempat.docs.isNotEmpty) {
            Map<String, dynamic> dataTempat =
                querySnapshotTempat.docs.last.data();
            String tempatNya = dataTempat['tempatmengaji'];

            yield* firestore
                .collection('Sekolah')
                .doc(idSekolah)
                .collection('tahunajaran')
                .doc(idTahunAjaran)
                .collection('semester')
                .doc(semesterNya)
                .collection('kelompokmengaji')
                .doc(faseNya)
                .collection('pengampu')
                .doc(argumenPengampu)
                .collection('tempat')
                .doc(tempatNya)
                .snapshots();

            refresh();
          }
        }
      }
    }
  }

  Future<String> getDataTempat() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    QuerySnapshot<Map<String, dynamic>> querySnapshotKelompok = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: argumenPengampu)
        .get();
    if (querySnapshotKelompok.docs.isNotEmpty) {
      Map<String, dynamic> dataGuru = querySnapshotKelompok.docs.first.data();
      String idPengampu = dataGuru['uid'];

      QuerySnapshot<Map<String, dynamic>> querySnapshotSemester =
          await firestore
              .collection('Sekolah')
              .doc(idSekolah)
              .collection('pegawai')
              .doc(idPengampu)
              .collection('tahunajarankelompok')
              .doc(idTahunAjaran)
              .collection('semester')
              .get();
      if (querySnapshotSemester.docs.isNotEmpty) {
        Map<String, dynamic> dataSemester =
            querySnapshotSemester.docs.last.data();
        String semesterNya = dataSemester['namasemester'];

        QuerySnapshot<Map<String, dynamic>> querySnapshotFase = await firestore
            .collection('Sekolah')
            .doc(idSekolah)
            .collection('pegawai')
            .doc(idPengampu)
            .collection('tahunajarankelompok')
            .doc(idTahunAjaran)
            .collection('semester')
            .doc(semesterNya)
            .collection('kelompokmengaji')
            .get();
        if (querySnapshotFase.docs.isNotEmpty) {
          Map<String, dynamic> dataFase = querySnapshotFase.docs.last.data();
          String faseNya = dataFase['fase'];

          QuerySnapshot<Map<String, dynamic>> querySnapshotTempat =
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
                  .doc(faseNya)
                  .collection('tempat')
                  .orderBy('tanggalinput')
                  .get();
          if (querySnapshotTempat.docs.isNotEmpty) {
            Map<String, dynamic> dataTempat =
                querySnapshotTempat.docs.last.data();
            String tempatNya = dataTempat['tempatmengaji'];

            return tempatNya;
          }
        }
      }
    }
    throw Exception('No data found for testAmbilTempat');
  }

  

  Future<String> getPengampu() {
    String pengampuNya = argumenPengampu.toString();
    // print('ini pengampunya dari get : $pengampuNya');
    return Future.value(pengampuNya.isNotEmpty
        ? pengampuNya
        : throw Exception('Pengampu is empty'));
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

  Future<String> getDataSemester() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    CollectionReference<Map<String, dynamic>> colSemester = firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(idTahunAjaran)
        .collection('semester');
    QuerySnapshot<Map<String, dynamic>> snapshotSemester =
        await colSemester.get();
    List<Map<String, dynamic>> listSemester =
        snapshotSemester.docs.map((e) => e.data()).toList();
    String semesterNya =
        listSemester.map((e) => e['namasemester'] as String).toList().last;
    return semesterNya;
  }

  Future<List<String>> getDataKelompokYangDiajar() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: argumenPengampu)
        .get();
    String idPengampu = querySnapshot.docs.first.data()['uid'];

    List<String> kelasList = [];
    await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .doc(idPengampu)
        .collection('tahunajarankelompok')
        .doc(idTahunAjaran)
        .collection('semester')
        .doc('Semester I') // nanti ini dicari getNya
        .collection('kelompokmengaji')
        .doc(argumenPengampu)
        .collection('tempat')
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        kelasList.add(docSnapshot.id);
      }
    });
    return kelasList;
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

  Future<void> isiTahunAjaranKelompokPadaPegawai() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    String semesterNya = await getDataSemester();
    // String tempatNya = await getDataTempat();
    QuerySnapshot<Map<String, dynamic>> querySnapshotGuru = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: argumenPengampu)
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
    // String idKelompokmengaji = "${pengampuC.text} ${tempatC.text}";

    String semesterNya = await getDataSemester();
    String tempatNya = await getDataTempat();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: argumenPengampu)
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
        .doc(argumenPengampu)
        .collection('tempat')
        .doc(tempatNya)
        .set({
      'tempatmengaji': tempatNya,
      'tahunajaran': tahunajaranya,
      'kelompokmengaji': argumenPengampu,
      'namasemester': semesterNya,
      'namapengampu': argumenPengampu,
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
        .doc(argumenPengampu)
        .set({
      'namasemester': semesterNya,
      'kelompokmengaji': argumenPengampu,
      'idpengampu': idPengampu,
      'namapengampu': argumenPengampu,
      'tempatmengaji': tempatNya,
      'tahunajaran': tahunajaranya,
      'emailpenginput': emailAdmin,
      'idpenginput': idUser,
      'tanggalinput': DateTime.now(),
    });
  }

  Future<void> buatIsiSemester1() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    String semesterNya = await getDataSemester();

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

  Future<void> tambahDaftarKelompokPengampuAjar(
      String nisnSiswa, String namaSiswa) async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    String semesterNya = await getDataSemester();
    String tempatNya = await getDataTempat();

    //ambil data guru terpilih .. ini nggak perlu dirubah
    QuerySnapshot<Map<String, dynamic>> querySnapshotGuru = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: argumenPengampu)
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
          .doc(argumenPengampu)
          .set({
        'tahunajaran': tahunajaranya,
        'kelompokmengaji': argumenPengampu,
        'namasemester': semesterNya,
        'namapengampu': argumenPengampu,
        'idpengampu': idPengampu,
        'emailpenginput': emailAdmin,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now(),
        'tempatmengaji': tempatNya,
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
          .doc(argumenPengampu)
          .collection('tempat')
          .doc(tempatNya)
          .set({
        'tahunajaran': tahunajaranya,
        'kelompokmengaji': argumenPengampu,
        'namasemester': semesterNya,
        'namapengampu': argumenPengampu,
        'idpengampu': idPengampu,
        'emailpenginput': emailAdmin,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now(),
        'tempatmengaji': tempatNya,
      });
    }
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

  Future<void> refreshTampilan() async {
    tampilSiswaKelompok();
  }

  Future<void> simpanSiswaKelompok(String namaSiswa, String nisnSiswa) async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    QuerySnapshot<Map<String, dynamic>> querySnapshotKelompok = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: argumenPengampu)
        .get();
    if (querySnapshotKelompok.docs.isNotEmpty) {
      Map<String, dynamic> dataGuru = querySnapshotKelompok.docs.first.data();
      String idPengampu = dataGuru['uid'];
      String namaPengampu = dataGuru['alias'];

      QuerySnapshot<Map<String, dynamic>> querySnapshotSemester =
          await firestore
              .collection('Sekolah')
              .doc(idSekolah)
              .collection('pegawai')
              .doc(idPengampu)
              .collection('tahunajarankelompok')
              .doc(idTahunAjaran)
              .collection('semester')
              .get();
      if (querySnapshotSemester.docs.isNotEmpty) {
        Map<String, dynamic> dataSemester =
            querySnapshotSemester.docs.last.data();
        String semesterNya = dataSemester['namasemester'];

        QuerySnapshot<Map<String, dynamic>> querySnapshotFase = await firestore
            .collection('Sekolah')
            .doc(idSekolah)
            .collection('pegawai')
            .doc(idPengampu)
            .collection('tahunajarankelompok')
            .doc(idTahunAjaran)
            .collection('semester')
            .doc(semesterNya)
            .collection('kelompokmengaji')
            .get();
        if (querySnapshotFase.docs.isNotEmpty) {
          Map<String, dynamic> dataFase = querySnapshotFase.docs.last.data();
          String faseNya = dataFase['fase'];

          QuerySnapshot<Map<String, dynamic>> querySnapshotTempat =
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
                  .doc(faseNya)
                  .collection('tempat')
                  .orderBy('tanggalinput')
                  .get();
          if (querySnapshotTempat.docs.isNotEmpty) {
            Map<String, dynamic> dataTempat =
                querySnapshotTempat.docs.last.data();
            String tempatNya = dataTempat['tempatmengaji'];

            //buat pada tahunpelajaran sekolah
            await firestore
                .collection('Sekolah')
                .doc(idSekolah)
                .collection('tahunajaran')
                .doc(idTahunAjaran)
                .collection('semester')
                .doc(semesterNya)
                .collection('kelompokmengaji')
                .doc(faseNya)
                .collection('pengampu')
                .doc(namaPengampu)
                .collection('tempat')
                .doc(tempatNya)
                .collection('daftarsiswa')
                .doc(nisnSiswa)
                .set({
              'namasiswa': namaSiswa,
              'nisn': nisnSiswa,
              'kelas': kelasSiswaC.text,
              'fase': faseNya,
              'tempatmengaji': tempatNya,
              'tahunajaran': tahunajaranya,
              'kelompokmengaji': namaPengampu,
              'namasemester': semesterNya,
              'namapengampu': namaPengampu,
              'idpengampu': idPengampu,
              'emailpenginput': emailAdmin,
              'idpenginput': idUser,
              'tanggalinput': DateTime.now(),
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
                .doc(semesterNya)
                .collection('kelompokmengaji')
                .doc(faseNya)
                .collection('tempat')
                .doc(tempatNya)
                .collection('daftarsiswa')
                .doc(nisnSiswa)
                .set({
              'namasiswa': namaSiswa,
              'nisn': nisnSiswa,
              'kelas': kelasSiswaC.text,
              'fase': faseNya,
              'tempatmengaji': tempatNya,
              'tahunajaran': tahunajaranya,
              'kelompokmengaji': namaPengampu,
              'namasemester': semesterNya,
              'namapengampu': namaPengampu,
              'idpengampu': idPengampu,
              'emailpenginput': emailAdmin,
              'idpenginput': idUser,
              'tanggalinput': DateTime.now(),
              'idsiswa': nisnSiswa,
            });
            ubahStatusSiswa(nisnSiswa);
          }
        }
      }
    }
    // print('sudah d klik');
  }

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
    String semesterNya = await getDataSemester();
    String tempatNya = await getDataTempat();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: argumenPengampu)
        .get();
    String idPengampu = querySnapshot.docs.first.data()['uid'];

    if (kelasSiswaC.text.isNotEmpty &&
        tahunajaranya.isNotEmpty &&
        semesterNya.isNotEmpty &&
        argumenPengampu.isNotEmpty) {
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
            .doc(argumenPengampu)
            .collection('tempat')
            .doc(tempatNya)
            .set({
          'tempatmengaji': tempatNya,
          'tahunajaran': tahunajaranya,
          'kelompokmengaji': argumenPengampu,
          'namasemester': semesterNya,
          'namapengampu': argumenPengampu,
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
            .doc(argumenPengampu)
            .collection('tempat')
            .doc(tempatNya)
            .collection('daftarsiswakelompok')
            .doc(nisnSiswa)
            .set({
          'namasiswa': namaSiswa,
          'nisn': nisnSiswa,
          'kelas': kelasSiswaC.text,
          'fase': faseNya,
          'tahunajaran': tahunajaranya,
          'kelompoksiswa': argumenPengampu,
          'semester': semesterNya,
          'pengampu': argumenPengampu,
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

  Future<List<String>> getDataKelasYangAda() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    QuerySnapshot<Map<String, dynamic>> querySnapshotKelompok = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: argumenPengampu)
        .get();
    if (querySnapshotKelompok.docs.isNotEmpty) {
      Map<String, dynamic> dataGuru = querySnapshotKelompok.docs.first.data();
      String idPengampu = dataGuru['uid'];

      QuerySnapshot<Map<String, dynamic>> querySnapshotSemester =
          await firestore
              .collection('Sekolah')
              .doc(idSekolah)
              .collection('pegawai')
              .doc(idPengampu)
              .collection('tahunajarankelompok')
              .doc(idTahunAjaran)
              .collection('semester')
              .get();
      if (querySnapshotSemester.docs.isNotEmpty) {
        Map<String, dynamic> dataSemester =
            querySnapshotSemester.docs.last.data();
        String semesterNya = dataSemester['namasemester'];

        QuerySnapshot<Map<String, dynamic>> querySnapshotFase = await firestore
            .collection('Sekolah')
            .doc(idSekolah)
            .collection('pegawai')
            .doc(idPengampu)
            .collection('tahunajarankelompok')
            .doc(idTahunAjaran)
            .collection('semester')
            .doc(semesterNya)
            .collection('kelompokmengaji')
            .get();
        if (querySnapshotFase.docs.isNotEmpty) {
          Map<String, dynamic> dataFase = querySnapshotFase.docs.last.data();
          String faseNya = dataFase['fase'];

          List<String> kelasList = [];
          await firestore
              .collection('Sekolah')
              .doc(idSekolah)
              .collection('tahunajaran')
              .doc(idTahunAjaran)
              .collection('kelastahunajaran')
              .where('fase', isEqualTo: faseNya)
              .get()
              .then((querySnapshot) {
            for (var docSnapshot in querySnapshot.docs) {
              kelasList.add(docSnapshot.id);
            }
          });
          return kelasList;
        }
      }
    }
    throw Exception('No data found for getDataKelasYangAda');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> tampilSiswaKelompok() async* {
    // String tahunajaranya = await getTahunAjaranTerakhir();
    // String idTahunAjaran = tahunajaranya.replaceAll("/", "-");
    // String idTempatnya = await getDataTempat();
    // String idSemester = await getDataSemester();

    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    QuerySnapshot<Map<String, dynamic>> querySnapshotKelompok = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: argumenPengampu)
        .get();
    if (querySnapshotKelompok.docs.isNotEmpty) {
      Map<String, dynamic> dataGuru = querySnapshotKelompok.docs.first.data();
      String idPengampu = dataGuru['uid'];
      String namaPengampu = dataGuru['alias'];

      QuerySnapshot<Map<String, dynamic>> querySnapshotSemester =
          await firestore
              .collection('Sekolah')
              .doc(idSekolah)
              .collection('pegawai')
              .doc(idPengampu)
              .collection('tahunajarankelompok')
              .doc(idTahunAjaran)
              .collection('semester')
              .get();
      if (querySnapshotSemester.docs.isNotEmpty) {
        Map<String, dynamic> dataSemester =
            querySnapshotSemester.docs.last.data();
        String semesterNya = dataSemester['namasemester'];

        QuerySnapshot<Map<String, dynamic>> querySnapshotFase = await firestore
            .collection('Sekolah')
            .doc(idSekolah)
            .collection('pegawai')
            .doc(idPengampu)
            .collection('tahunajarankelompok')
            .doc(idTahunAjaran)
            .collection('semester')
            .doc(semesterNya)
            .collection('kelompokmengaji')
            .get();
        if (querySnapshotFase.docs.isNotEmpty) {
          Map<String, dynamic> dataFase = querySnapshotFase.docs.last.data();
          String faseNya = dataFase['fase'];

          QuerySnapshot<Map<String, dynamic>> querySnapshotTempat =
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
                  .doc(faseNya)
                  .collection('tempat')
                  .orderBy('tanggalinput')
                  .get();
          if (querySnapshotTempat.docs.isNotEmpty) {
            Map<String, dynamic> dataTempat =
                querySnapshotTempat.docs.last.data();
            String tempatNya = dataTempat['tempatmengaji'];

            yield* firestore
                .collection('Sekolah')
                .doc(idSekolah)
                .collection('tahunajaran')
                .doc(idTahunAjaran)
                .collection('semester')
                .doc(semesterNya)
                .collection('kelompokmengaji')
                .doc(faseNya)
                .collection('pengampu')
                .doc(namaPengampu)
                .collection('tempat')
                .doc(tempatNya)
                .collection('daftarsiswa')
                .orderBy('tanggalinput', descending: true)
                .snapshots();
          }
        }
      }
    }
  }
}
