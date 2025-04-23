import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TambahSiswaController extends GetxController {

  RxBool isLoading = false.obs;
  RxBool isLoadingTambahSiswa = false.obs;

  TextEditingController tahunAjaran = TextEditingController();
  TextEditingController nisnSiswaController = TextEditingController();
  TextEditingController namaSiswaController = TextEditingController();
  // TextEditingController kelasSiswaController = TextEditingController();
  TextEditingController jenisKelaminSiswaController = TextEditingController();
  TextEditingController agamaSiswaController = TextEditingController();
  TextEditingController tempatLahirSiswaController = TextEditingController();
  TextEditingController tanggalLahirSiswaController = TextEditingController();
  TextEditingController alamatSiswaController = TextEditingController();
  // TextEditingController waliKelasSiswaController = TextEditingController();
  TextEditingController namaAyahController = TextEditingController();
  TextEditingController namaIbuController = TextEditingController();
  TextEditingController emailOrangTuaController = TextEditingController();
  TextEditingController noHpOrangTuaController = TextEditingController();
  TextEditingController alamatOrangTuaController = TextEditingController();
  TextEditingController pekerjaanAyahController = TextEditingController();
  TextEditingController pekerjaanIbuController = TextEditingController();
  TextEditingController pendidikanAyahController = TextEditingController();
  TextEditingController pendidikanIbuController = TextEditingController();
  TextEditingController noHpWaliController = TextEditingController();
  TextEditingController alamatWaliController = TextEditingController();
  TextEditingController pekerjaanWaliController = TextEditingController();
  TextEditingController pendidikanWaliController = TextEditingController();
  TextEditingController biayaSppController = TextEditingController();
  TextEditingController biayaUangPangkalController = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //ambil tahun ajaran terakhir
  Future<String> getTahunAjaranTerakhir() async {
    String idSekolah = 'UQjMpsKZKmWWbWVu4Uwb';
    CollectionReference<Map<String, dynamic>> colTahunAjaran = firestore
        .collection('Sekolah')
        .doc(idSekolah)
        .collection('tahunajaran');
    QuerySnapshot<Map<String, dynamic>> snapshotTahunAjaran =
        await colTahunAjaran.get();
    List<Map<String, dynamic>> listTahunAjaran =
        snapshotTahunAjaran.docs.map((e) => e.data()).toList();
    String tahunAjaranTerakhir = listTahunAjaran
        .map((e) => e['namatahunajaran'])
        .toList()
        .last;
    // print(tahunAjaranTerakhir);
    return tahunAjaranTerakhir;
  }

  Future<void> siswaDitambahkan() async {
    if (passAdminC.text.isNotEmpty) {
      isLoadingTambahSiswa.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        UserCredential siswaCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailOrangTuaController.text,
          password: 'password',
        );
        

        //======================================================

        if (siswaCredential.user != null) {
          // String uid = siswaCredential.user!.uid;
          String idSekolah = 'UQjMpsKZKmWWbWVu4Uwb';

          // await firestore.collection("Siswa").doc(nisnSiswaController.text).set({
          await firestore.collection("Sekolah").doc(idSekolah).collection('siswa').doc(nisnSiswaController.text).set({
            "nisn": nisnSiswaController.text,
            "nama": namaSiswaController.text,
            // "kelas": kelasSiswaController.text,
            "jenisKelamin": jenisKelaminSiswaController.text,
            "agama": agamaSiswaController.text,
            "tempatLahir": tempatLahirSiswaController.text,
            "tanggalLahir": tanggalLahirSiswaController.text,
            "alamat": alamatSiswaController.text,
            // "waliKelas": waliKelasSiswaController.text,
            "namaAyah": namaAyahController.text,
            "namaIbu": namaIbuController.text,
            "emailOrangTua": emailOrangTuaController.text,
            "noHpOrangTua": noHpOrangTuaController.text,
            "alamatOrangTua": alamatOrangTuaController.text,
            "pekerjaanAyah": pekerjaanAyahController.text,
            "pekerjaanIbu": pekerjaanIbuController.text,
            "pendidikanAyah": pendidikanAyahController.text,
            "pendidikanIbu": pendidikanIbuController.text,
            "noHpWali": noHpWaliController.text,
            "alamatWali": alamatWaliController.text,
            "pekerjaanWali": pekerjaanWaliController.text,
            "pendidikanWali": pendidikanWaliController.text,
            "biayaSpp": biayaSppController.text,
            "biayaUangPangkal": biayaUangPangkalController.text,
            "uid": nisnSiswaController.text,
            "createdAt": DateTime.now().toIso8601String(),
            "createdByEmail": emailAdmin,
            "createdById": auth.currentUser!.uid,
            // "createdByName" : auth.currentUser!.
            "status": "Siswa",
          });

          await siswaCredential.user!.sendEmailVerification();

          // await auth.signOut();

          // UserCredential userCredentialAdmin =
          //     await auth.signInWithEmailAndPassword(
          //   email: emailAdmin,
          //   password: passAdminC.text,
          // );

          Get.back();
          Get.back();

          Get.snackbar(
            'Berhasil',
            'Siswa berhasil ditambahkan',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          
          resetForm();
        }
        isLoadingTambahSiswa.value = false;
      } on FirebaseAuthException catch (e) {
        isLoadingTambahSiswa.value = false;
        if(e.code == 'email-already-in-use') {
          Get.snackbar(
            'Gagal',
            e.message!,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (e.code == 'weak-password') {
          Get.snackbar(
            'Gagal',
            e.message!,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (e.code == 'invalid-credential') {
          Get.snackbar(
            'Gagal',
            e.message!,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Gagal',
            e.message!,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
        Get.snackbar(
          'Gagal',
          e.message!,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } catch (e) {
        isLoadingTambahSiswa.value = false;
        Get.snackbar(
          'Gagal',
          'Tidak dapat menambahkan siswa, harap dicoba lagi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );        
      }
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Password Admin wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }




  Future<void> tambahSiswa() async {
    if (namaSiswaController.text.isNotEmpty &&
        // kelasSiswaController.text.isNotEmpty &&
        jenisKelaminSiswaController.text.isNotEmpty &&
        agamaSiswaController.text.isNotEmpty &&
        tempatLahirSiswaController.text.isNotEmpty &&
        tanggalLahirSiswaController.text.isNotEmpty &&
        alamatSiswaController.text.isNotEmpty &&
        // waliKelasSiswaController.text.isNotEmpty &&
        namaAyahController.text.isNotEmpty &&
        namaIbuController.text.isNotEmpty &&
        emailOrangTuaController.text.isNotEmpty &&
        noHpOrangTuaController.text.isNotEmpty &&
        alamatOrangTuaController.text.isNotEmpty &&
        pekerjaanAyahController.text.isNotEmpty &&
        pekerjaanIbuController.text.isNotEmpty &&
        pendidikanAyahController.text.isNotEmpty &&
        pendidikanIbuController.text.isNotEmpty &&
        noHpWaliController.text.isNotEmpty &&
        alamatWaliController.text.isNotEmpty &&
        pekerjaanWaliController.text.isNotEmpty &&
        pendidikanWaliController.text.isNotEmpty &&
        biayaSppController.text.isNotEmpty &&
        biayaUangPangkalController.text.isNotEmpty) {
          isLoading.value = true;
          Get.defaultDialog(
            title: 'Verifikasi Email',
            content: Column(
              children: [
                TextFormField(
                  controller: passAdminC,
                  decoration: const InputDecoration(
                    labelText: 'Password Admin'),
                ),
              ],
            ),
            actions: [
              OutlinedButton(
                onPressed: () {
                  isLoading.value = false;
                  Get.back();
                },
                child: Text('CANCEL'),
              ),
              Obx(
                () => ElevatedButton(
                  onPressed: () async {
                    if (isLoadingTambahSiswa.isFalse) {
                      await siswaDitambahkan();
                    }
                    isLoading.value = false;
                  },
                  child: Text(isLoadingTambahSiswa.isFalse
                      ? 'Tambah Siswa'
                      : 'LOADING...'),
                ),
              ),
            ],
          );
    } else {
      Get.snackbar(
        'Gagal',
        'Semua data harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      } 
    }

  void resetForm() {
    namaSiswaController.clear();
    // kelasSiswaController.clear();
    // kelasSiswaController.text == "";
    jenisKelaminSiswaController.clear();
    jenisKelaminSiswaController.text == "";
    agamaSiswaController.clear();
    agamaSiswaController.text == "";
    tempatLahirSiswaController.clear();
    tanggalLahirSiswaController.clear();
    alamatSiswaController.clear();
    // waliKelasSiswaController.clear();
    namaAyahController.clear();
    namaIbuController.clear();
    emailOrangTuaController.clear();
    noHpOrangTuaController.clear();
    alamatOrangTuaController.clear();
    pekerjaanAyahController.clear();
    pekerjaanIbuController.clear();
    pendidikanAyahController.clear();
    pendidikanIbuController.clear();
    noHpWaliController.clear();
    alamatWaliController.clear();
    pekerjaanWaliController.clear();
    pendidikanWaliController.clear();
    biayaSppController.clear();
    biayaUangPangkalController.clear();
  }

  @override
  void onClose() {
    namaSiswaController.dispose();
    // kelasSiswaController.dispose();
    jenisKelaminSiswaController.dispose();
    agamaSiswaController.dispose();
    tempatLahirSiswaController.dispose();
    tanggalLahirSiswaController.dispose();
    alamatSiswaController.dispose();
    // waliKelasSiswaController.dispose();
    namaAyahController.dispose();
    namaIbuController.dispose();
    emailOrangTuaController.dispose();
    noHpOrangTuaController.dispose();
    alamatOrangTuaController.dispose();
    pekerjaanAyahController.dispose();
    pekerjaanIbuController.dispose();
    pendidikanAyahController.dispose();
    pendidikanIbuController.dispose();
    noHpWaliController.dispose();
    alamatWaliController.dispose();
    pekerjaanWaliController.dispose();
    pendidikanWaliController.dispose();
    biayaSppController.dispose();
    biayaUangPangkalController.dispose();
  }
  
}
