import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:guru_project/app/modules/contoh/views/contoh_view.dart';
import 'package:intl/intl.dart';

class ContohController extends GetxController {
      TextEditingController suratC = TextEditingController();
      TextEditingController ayatHafalC = TextEditingController();
      TextEditingController jldSuratC = TextEditingController();
      TextEditingController halAyatC = TextEditingController();
      TextEditingController materiC = TextEditingController();
      TextEditingController nilaiC = TextEditingController();
      TextEditingController keteranganGuruC = TextEditingController();

      var data = Get.arguments;

      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      String idUser = FirebaseAuth.instance.currentUser!.uid;
      String idSekolah = 'UQjMpsKZKmWWbWVu4Uwb';
      String emailAdmin = FirebaseAuth.instance.currentUser!.email!;

      void test() {
        // print('ayatHafalC : ${ayatHafalC.text}');
        // print('suratC : ${suratC.text}');
        // print('jldSuratC : ${jldSuratC.text}');
        // print('halAyatC : ${halAyatC.text}');
        // print('materiC : ${materiC.text}');
        // print('nilaiC : ${nilaiC.text}');
        // print('keteranganGuruC : ${keteranganGuruC.text}');

        // DateTime now = DateTime.now();
          // print(DateFormat.yMd().format(now));
      }

      Future<void> simpanNilai() async {
        if(data != null && data.isNotEmpty) {
          String idTahunAjaranNya = data['tahunajaran'];
          String idTahunAjaran = idTahunAjaranNya.replaceAll("/", "-");


        CollectionReference<Map<String, dynamic>> colNilai =  firestore
            .collection('Sekolah')
            .doc(idSekolah)
            .collection('tahunajaran')
            .doc(idTahunAjaran)
            .collection('semester')
            .doc(data['namasemester'])
            .collection('kelompokmengaji')
            .doc(data['fase'])
            .collection('pengampu')
            .doc(data['namapengampu'])
            .collection('tempat')
            .doc(data['tempatmengaji'])
            .collection('daftarsiswa')
            .doc(data['nisn'])
            .collection('nilai');

          QuerySnapshot<Map<String, dynamic>> snapNilai = await colNilai.get();

          DateTime now = DateTime.now();
          String docIdNilai = DateFormat.yMd().format(now).replaceAll('/', '-');

          // ignore: prefer_is_empty
          if(snapNilai.docs.length == 0 || snapNilai.docs.isEmpty) {
            //belum pernah input nilai & set nilai
            colNilai.doc(docIdNilai).set({
              "tanggalinput" : now.toIso8601String(),
              "emailpenginput" : emailAdmin,
              "fase" : data['fase'],
              "idpengampu" : idUser,
              "idsiswa" : data['nisn'],
              "kelas" : data['kelas'],
              "kelompokmengaji" : data['kelompokmengaji'],
              "namapengampu" : data['namapengampu'],
              "namasemester" : data['namasemester'],
              "namasiswa" : data['namasiswa'],
              "tahunajaran" : data['tahunajaran'],
              "tempatmengaji" : data['tempatmengaji'],
              "hafalansurat" : suratC.text,
              "ayathafalansurat" : ayatHafalC.text,
              "ummijilidatausurat" : jldSuratC.text,
              "ummihalatauayat" : halAyatC.text,
              "materi" : materiC.text,
              "nilai" : nilaiC.text,
              "keteranganpengampu" : keteranganGuruC.text,
              "keteranganorangtua" : "0"
              });


              Get.snackbar('Informasi', 'Berhasil input nilai',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.grey[350]);

              // Get.back();

              refresh();
              Get.back();
              
            
          } else {
            // sudah pernah input nilai dihari ini --> beri keterangan
            Get.snackbar('Informasi', 'hari ini ananda sudah input nilai',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.grey[350]);
          }
        }
      }
}
