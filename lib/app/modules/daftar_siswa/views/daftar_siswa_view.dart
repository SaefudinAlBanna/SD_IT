import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
// import 'package:guru_project/app/routes/app_pages.dart';

import '../controllers/daftar_siswa_controller.dart';

class DaftarSiswaView extends GetView<DaftarSiswaController> {
  const DaftarSiswaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DAFTAR SISWA'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.getDaftarSiswa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
          // Map<String, dynamic> data = snapshot.data!.data() ?? {};
          // Map<String, dynamic> data = snapshot.data!.data()!;
          // print(data);
          } else {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
      
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.data!.data() == null) {
            return const Center(
              child: Text('Data tidak ditemukan'),
            );
          }
          Map<String, dynamic> data = snapshot.data!.data()!;
          // controller.daftarSiswa.clear();
          // snapshot.data!.data()!.forEach((key, value) {
          //   controller.daftarSiswa.add(Siswa(
          //     nama: value['nama'],
          //     kelas: value['kelas'],
          //   ));
          // });
          
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(data['nama'] ?? 'N'),
                    // child: Text('N'),
                  ),
                  // title: Text(controller.daftarSiswa[index].nama),
                  subtitle: Text(data['kelas'] ?? 'K'),
                  // trailing: IconButton(
                  //   icon: const Icon(Icons.delete),
                  //   onPressed: () {
                  //     controller.hapusSiswa(index);
                  //   },
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_circle_right_outlined),
                    onPressed: () {
                      // Get.toNamed('/detail_siswa', arguments: controller.daftarSiswa[index]);
                      // Get.toNamed(Routes.DETAIL_SISWA);
                      // print(data.length);
                    },
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
