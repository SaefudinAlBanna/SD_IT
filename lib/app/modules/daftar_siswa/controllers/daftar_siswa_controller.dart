import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Siswa {
  final String nama;
  final String kelas;

  Siswa({required this.nama, required this.kelas});
}

class DaftarSiswaController extends GetxController {
  // final daftarSiswa = <Siswa>[].obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // @override
  // void onInit() {
  //   daftarSiswa.addAll([
  //     Siswa(nama: 'Budi', kelas: 'XII RPL 1'),
  //     Siswa(nama: 'Ani', kelas: 'XII RPL 2'),
  //     Siswa(nama: 'Joko', kelas: 'XII RPL 3'),
  //   ]);
  //   super.onInit();
  // }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDaftarSiswa() async* {
    String uid = auth.currentUser!.uid;

    // yield* firestore.collection('Pegawai').doc(uid).snapshots();
    yield* firestore.collection('Pegawai').doc(uid).snapshots();
  }

  void hapusSiswa(int index) {
    // daftarSiswa.removeAt(index);
  }
}
