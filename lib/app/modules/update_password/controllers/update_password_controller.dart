import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  FirebaseAuth auth =FirebaseAuth.instance;

  void updatePassword() async {
    // Update password logic here
    if (oldPasswordController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      if (newPasswordController.text == confirmPasswordController.text) {
        isLoading.value = true;
        try {
          String emailUser =  auth.currentUser!.email!;

         await auth.signInWithEmailAndPassword(email: emailUser, password: oldPasswordController.text);

          await auth.currentUser!.updatePassword(newPasswordController.text);

        //   await auth.signOut();

        //  await auth.signInWithEmailAndPassword(email: emailUser, password: oldPasswordController.text);
        Get.back();
        Get.snackbar('Sukses', 'Update password berhasil..');


        } on FirebaseAuthException catch (e) {
          if(e.code == "wrong-password") {
          Get.snackbar('Error', 'Password lama salah');
          } else {
          Get.snackbar('Error', e.code.toString().toLowerCase());
          }
        } catch (e) {
          Get.snackbar('Error', 'Tidak dapat update password');
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar('Error', 'New password & Confirm password harus sama');
      }
    } else {
      Get.snackbar('Error', 'Semua field harus di isi');
    }
  }
}
