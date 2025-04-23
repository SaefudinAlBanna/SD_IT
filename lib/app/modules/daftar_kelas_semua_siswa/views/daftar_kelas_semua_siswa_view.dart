import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/daftar_kelas_semua_siswa_controller.dart';

class DaftarKelasSemuaSiswaView
    extends GetView<DaftarKelasSemuaSiswaController> {
  const DaftarKelasSemuaSiswaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DAFTAR SISWA PER KELAS'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Tahun Ajaran : '),
                  FutureBuilder<String>(
                      future: controller.getTahunAjaranTerakhir(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else {
                          return Text(
                            snapshot.data ?? 'No Data',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          );
                        }
                      }),
                ],
              ),
              FutureBuilder<Object>(
                  future: controller.getDataSemuaKelas(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      List<String> kelasAjarGuru =
                          snapshot.data as List<String>;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          color: Colors.amber,
                          child: Row(
                            children: kelasAjarGuru.map((k) {
                              return TextButton(
                                onPressed: () {
                                  // Get.toNamed(Routes.DAFTAR_KELAS, arguments: k);
                                  // print(k);
                                },
                                child: Text(k, style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  }),
              //=========================
            ],
          ),
          SizedBox(height: 20),
          // Text('Kelas : ${kelasAjarGuru.map(k)}'),
          Expanded(child: ListTile(

          ))
        ],
      ),
    );
  }
}
