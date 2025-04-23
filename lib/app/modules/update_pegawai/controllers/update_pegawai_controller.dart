import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class UpdatePegawaiController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController nipC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController noHpC = TextEditingController();
  TextEditingController alamatC = TextEditingController();
  // TextEditingController jabatanC = TextEditingController();

  // FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String idSekolah = 'UQjMpsKZKmWWbWVu4Uwb';

  // void updateProfile() async {
  Future<void> updateProfile(String uid) async {
    isLoading.value = true;
    // String uid = auth.currentUser!.uid;
    if(namaC.text.isNotEmpty && noHpC.text.isNotEmpty) {
      await firestore.collection('Sekolah').doc(idSekolah).collection('pegawai').doc(uid).update({
        'nama': namaC.text,
        'noHp': noHpC.text,
       });


      isLoading.value = false;
      Get.snackbar(
        'Berhasil',
        'Data berhasil diupdate',
        snackPosition: SnackPosition.BOTTOM,

      );
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Gagal',
        'Data tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
   
  } 
}
