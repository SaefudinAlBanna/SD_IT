import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TambahPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingTambahPegawai = false.obs;
  TextEditingController nipC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController noHpC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String idSekolah = 'UQjMpsKZKmWWbWVu4Uwb';

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

  Future<void> pegawaiDitambahkan() async {
    String tahunajaranya = await getTahunAjaranTerakhir();
    String idTahunAjaran = tahunajaranya.replaceAll("/", "-");

    if (passAdminC.text.isNotEmpty) {
      isLoadingTambahPegawai.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        // (jangan dihapus)
        // ignore: unused_local_variable
        UserCredential userCredentialAdmin  = await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passAdminC.text,
        );

        UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: 'password',
        );
        // print(pegawaiCredential);

        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;

          await firestore
              .collection("Sekolah")
              .doc(idSekolah)
              .collection('tahunajaran')
              .doc(idTahunAjaran)
              .collection('pegawai')
              .doc(uid)
              .set({
            "nip": nipC.text,
            "nama": namaC.text,
            "email": emailC.text,
            "noHp": noHpC.text,
            "uid": uid,
            "createdAt": DateTime.now().toIso8601String(),
            "emailpenginput" : emailAdmin
          });

          await pegawaiCredential.user!.sendEmailVerification();

          await auth.signOut();

          //disini login ulang admin penginput (jangan dihapus)
          // ignore: unused_local_variable
          UserCredential userCredentialAdmin  = await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passAdminC.text,
        );

          Get.back(); // tutup dialog
          Get.back(); // back to home

          Get.snackbar(
              snackPosition: SnackPosition.BOTTOM,
              'Berhasil',
              'Karyawan berhasil ditambahkan');
        }
        isLoadingTambahPegawai.value = false;
      } on FirebaseAuthException catch (e) {
        isLoadingTambahPegawai.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar(
              snackPosition: SnackPosition.BOTTOM,
              'Terjadi Kesalahan',
              'Password terlalu singkat');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar(
              snackPosition: SnackPosition.BOTTOM,
              'Terjadi Kesalahan',
              'email pegawai sudah terdaftar');
        } else if (e.code == 'invalid-credential') {
          Get.snackbar(
              snackPosition: SnackPosition.BOTTOM,
              'Terjadi Kesalahan',
              'password salah');
        } else {
          Get.snackbar(
              snackPosition: SnackPosition.BOTTOM, 'Terjadi Kesalahan', e.code);
        }
      } catch (e) {
        isLoadingTambahPegawai.value = false;
        Get.snackbar(
            snackPosition: SnackPosition.BOTTOM,
            'Terjadi Kesalahan',
            'Tidak dapat menambahkan pegawai, harap dicoba lagi');
      }
    } else {
      isLoading.value = false;
      Get.snackbar(
          snackPosition: SnackPosition.BOTTOM,
          'Error',
          'Password Admin wajib diisi');
    }
  }

  Future<void> tambahPegawai() async {
    if (nipC.text.isNotEmpty &&
        namaC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        noHpC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
        title: 'Verifikasi Admnin',
        content: Column(
          children: [
            Text('Masukan password'),
            SizedBox(height: 10),
            TextField(
              controller: passAdminC,
              obscureText: true,
              autocorrect: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Password',
              ),
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
                if (isLoadingTambahPegawai.isFalse) {
                  await pegawaiDitambahkan();
                }
                isLoading.value = false;
              },
              child: Text(isLoadingTambahPegawai.isFalse
                  ? 'Tambah Pegawai'
                  : 'LOADING...'),
            ),
          ),
        ],
      );
    } else {
      Get.snackbar(
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromARGB(255, 156, 151, 151),
          'Terjadi Kesalahan',
          '* Wajib di isi');
    }
  }
}
