import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_siswa_controller.dart';

class DetailSiswaView extends GetView<DetailSiswaController> {
  DetailSiswaView({super.key});

  final String dataNama = Get.arguments;
  // final String dataKelas = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: controller.getDetailSiswa(),
        builder: (context, snapshotDetail) {
          if(snapshotDetail.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshotDetail.hasData) {
            final data = snapshotDetail.data!.docs.first.data();
          return SafeArea(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 30, bottom: 15),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.grey),
                      ),
                    ),
                    Text(data['nama']),
                  ],
                ),
                Expanded(
                  child: SafeArea(
                    child: ListView(
                      children: [
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          height: Get.height,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // InfoDetailSiswa(icon: Icon(Icons.airline_seat_recline_normal_rounded)),
                                InfoDetailSiswa(data: data, icon: Icon(Icons.access_alarm), isi: 'agama'),
                                InfoDetailSiswa(data: data, icon: Icon(Icons.access_alarm), isi: 'alamat')
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ); 
          } else {
            return Text('Terjadi kesalahan');
          }
        }
      ),
    );
  }
}

class InfoDetailSiswa extends StatelessWidget {
  const InfoDetailSiswa({
    super.key,
    required this.data,
    required this.icon,
    required this.isi,

  });

  final Map<String, dynamic> data;
  final Icon icon;
  final String isi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          icon,
          SizedBox(width: 10),
          Text(data[isi]),
        ],
      ),
    );
  }
}
