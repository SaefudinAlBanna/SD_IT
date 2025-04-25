import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PilihSiswaHalaqohController extends GetxController {
 var argumenData = Get.arguments;
  TextEditingController kelasSiswaC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String idUser = FirebaseAuth.instance.currentUser!.uid;
  String idSekolah = 'UQjMpsKZKmWWbWVu4Uwb';
  String emailAdmin = FirebaseAuth.instance.currentUser!.email!;

  String namaAdmin = FirebaseAuth.instance.currentUser!.displayName!;


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
        .where('fase', isEqualTo: argumenData[0]['fase'])
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

  Future<void> simpanSiswaKelompok(String namaSiswa, String nisnSiswa) async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    QuerySnapshot<Map<String, dynamic>> querySnapshotKelompok = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: argumenData[0]['namapengampu'])
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
          .doc(argumenData[0]['namasemester'])
          .collection('kelompokmengaji')
          .doc(argumenData[0]['fase'])
          .collection('pengampu')
          .doc(argumenData[0]['namapengampu'])
          .collection('tempat')
          .doc(argumenData[0]['tempatmengaji'])
          .collection('daftarsiswa')
          .doc(nisnSiswa)
          .set({
        'namasiswa': namaSiswa,
        'nisn': nisnSiswa,
        'kelas': kelasSiswaC.text,
        'fase': argumenData[0]['fase'],
        'tempatmengaji': argumenData[0]['tempatmengaji'],
        'tahunajaran': argumenData[0]['tahunajaran'],
        'kelompokmengaji': argumenData[0]['namapengampu'],
        'namasemester': argumenData[0]['namasemester'],
        'namapengampu': argumenData[0]['namapengampu'],
        'idpengampu': argumenData[0]['idpengampu'],
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
          .doc(argumenData[0]['namasemester'])
          .collection('kelompokmengaji')
          .doc(argumenData[0]['fase'])
          .collection('tempat')
          .doc(argumenData[0]['tempatmengaji'])
          .collection('daftarsiswa')
          .doc(nisnSiswa)
          .set({
        'namasiswa': namaSiswa,
        'nisn': nisnSiswa,
        'kelas': kelasSiswaC.text,
        'fase': argumenData[0]['fase'],
        'tempatmengaji': argumenData[0]['tempatmengaji'],
        'tahunajaran': argumenData[0]['tahunajaran'],
        'kelompokmengaji': argumenData[0]['namapengampu'],
        'namasemester': argumenData[0]['namasemester'],
        'namapengampu': argumenData[0]['namapengampu'],
        'idpengampu': idPengampu,
        'emailpenginput': emailAdmin,
        'idpenginput': idUser,
        'tanggalinput': DateTime.now().toIso8601String(),
        'idsiswa': nisnSiswa,
      });
      ubahStatusSiswa(nisnSiswa);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> tampilkan() async* {
    String tahunAjaranX = argumenData[0]['tahunajaran'];
    String tahunAjaranya = tahunAjaranX.replaceAll("/", "-");
    yield* firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran')
        .doc(tahunAjaranya)
        .collection('semester')
        .doc(argumenData[0]['namasemester'])
        .collection('kelompokmengaji')
        .doc(argumenData[0]['fase'])
        .collection('pengampu')
        .doc(argumenData[0]['namapengampu'])
        .collection('tempat')
        .doc(argumenData[0]['tempatmengaji'])
        .collection('daftarsiswa')
        .orderBy('tanggalinput', descending: true)
        .snapshots();
  }

  Future<void> refreshTampilan() async {
    tampilkan();
  }

  Future<List<String>> getDataKelompokYangDiajar() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('pegawai')
        .where('alias', isEqualTo: argumenData[0]['namapengampu'])
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
        .doc(argumenData[0]['namapengampu'])
        .collection('tempat')
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        kelasList.add(docSnapshot.id);
      }
    });
    return kelasList;
  }
}
