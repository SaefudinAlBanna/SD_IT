import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/daftar_siswa_pindah_halaqoh_controller.dart';

class DaftarSiswaPindahHalaqohView
    extends GetView<DaftarSiswaPindahHalaqohController> {
  const DaftarSiswaPindahHalaqohView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DaftarSiswaPindahHalaqohView'),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: controller.dataSiswaPindah(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } if (snapshot.data!.docs.isEmpty || snapshot.data == null) {
              return Center(child: Text('Tidak ada siswa pindah halaqoh'));
            
            } if(snapshot.hasData) {
              return ListView.separated(
                
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var datanya = snapshot.data?.docs;
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("nama siswa : ${datanya != null && datanya.isNotEmpty
                            ? (datanya[0]['namasiswa'] ?? 'No Data')
                            : '-'}"),

                            Text(datanya != null && datanya.isNotEmpty
                                ? (datanya[0]['tanggalpindah'] != null
                                    ? DateFormat("dd-MM-yyyy").format(DateTime.parse(datanya[0]['tanggalpindah'] as String))
                                    : 'No Data')
                                : 'No Data'),
                          ],
                        ),
                        SizedBox(height: 3),
                        Text("kelas : ${datanya != null && datanya.isNotEmpty
                            ? (datanya[0]['kelas'] ?? 'No Data')
                            : '-'}"),
                        SizedBox(height: 3),
                        Text("Fase : ${datanya != null && datanya.isNotEmpty
                            ? (datanya[0]['fase'] ?? 'No Data')
                            : '-'}"),
                        // SizedBox(height: 3),
                        // Text("Fase : ${datanya != null && datanya.isNotEmpty
                        //     ? (datanya[0]['tahunajaran'] ?? 'No Data')
                        //     : '-'}"),
                        // SizedBox(height: 3),
                        // Text("Fase : ${datanya != null && datanya.isNotEmpty
                        //     ? (datanya[0]['namasemester'] ?? 'No Data')
                        //     : '-'}"),
                        SizedBox(height: 3),
                        Text("Halaqoh lama : ${datanya != null && datanya.isNotEmpty
                            ? (datanya[0]['tempathalaqohlama'] ?? 'No Data')
                            : '-'}"),
                        SizedBox(height: 3),
                        Text("Halaqoh baru : ${datanya != null && datanya.isNotEmpty
                            ? (datanya[0]['tempathalaqohbaru'] ?? 'No Data')
                            : '-'}"),
                        SizedBox(height: 3),
                        Text("alasan pindah : ${datanya != null && datanya.isNotEmpty
                            ? (datanya[0]['alasanpindah'] ?? 'No Data')
                            : '-'}"),
                      ],
                    ),
                  );
                },
              );
          } else {
            return Center(
              child: Text('No data available'),
            );
          }
        }),
    );
  }
}
