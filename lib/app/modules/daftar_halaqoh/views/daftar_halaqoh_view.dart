import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:guru_project/app/routes/app_pages.dart';

import '../controllers/daftar_halaqoh_controller.dart';

class DaftarHalaqohView extends GetView<DaftarHalaqohController> {
   DaftarHalaqohView({super.key});

  final data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: controller.getDaftarHalaqoh(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
        return Scaffold(
          appBar: AppBar(
            title: Text(data['namapengampu']),
            centerTitle: true,
          ),
          body: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = (snapshot.data as QuerySnapshot).docs[index];
                    return ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://ui-avatars.com/api/?name=${doc['namasiswa']}")),
                        ),
                      ),
                      title: Text(doc['namasiswa'] ?? 'No Data'),
                      subtitle: Text(doc['kelas'] ?? 'No Data'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            tooltip: 'Lihat',
                            icon: const Icon(Icons.arrow_circle_right_outlined),
                            onPressed: () {
                              Get.toNamed(Routes.DAFTAR_NILAI, arguments: doc);
                            },
                          ),
                        ],
                      ),
                    );
          },)
        );
          } else {
            return Center(
              child: Text('Terjadi kesalahan, Periksa koneksi internet'),
            );
          }
      }
    );
  }
}
