import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pilih_siswa_halaqoh_controller.dart';

class PilihSiswaHalaqohView extends GetView<PilihSiswaHalaqohController> {
   PilihSiswaHalaqohView({super.key});

  final datax = Get.arguments;
  @override
  Widget build(BuildContext context) {
    var datacc = datax[0];
    return Scaffold(
      appBar: AppBar(
        title: const Text('PilihSiswaHalaqohView'),
        centerTitle: true,
      ),
      body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tahun Ajaran :'),
                Text(datacc['tahunajaran'].toString()),
              ],
            ),
        
        
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(datacc['namasemester'].toString()),
              ],
            ),
            SizedBox(height: 15),
            Divider(height: 3),
            SizedBox(height: 10),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('nama pengampu'),
                    SizedBox(height: 10),
                    Text('nama tempat'),
                    SizedBox(height: 10),
                    Text('Fase'),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(datacc['namapengampu'].toString()),
                    
                    SizedBox(height: 10),
                    Text(datacc['tempatmengaji'].toString()),
                    // Text('Tahun Ajaran : '),
              // FutureBuilder<String>(
              //     future: controller.getDataTempat(),
              //     builder: (context, snapshottempat) {
              //       if (snapshottempat.connectionState == ConnectionState.waiting) {
              //         return CircularProgressIndicator();
              //       } else if (snapshottempat.hasError) {
              //         return Text('Error');
              //       } else {
              //         return Text(
              //           snapshottempat.data ?? 'No Data',
              //           style: TextStyle(
              //               fontSize: 18, fontWeight: FontWeight.bold),
              //         );
              //       }
              //     }),
        
        
                    SizedBox(height: 10),
                    Text(datacc['fase'].toString()),
                    
                  ],
                ),
              ],
            ),
        
            //===========================================
            FutureBuilder<List<String>>(
              future: controller.getDataKelasYangAda(),
              builder: (context, snapshotkelas) {
                if (snapshotkelas.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshotkelas.hasData) {
                  List<String> kelasAjarGuru = snapshotkelas.data!;
                  return SingleChildScrollView(
                    child: Row(
                      children: kelasAjarGuru.map((k) {
                        return TextButton(
                          onPressed: () {
                            controller.kelasSiswaC.text = k;
                            // print('ini kelassiswaC = $k');
                            Get.bottomSheet(
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 30),
                                color: Colors.white,
                                child: Center(
                                  child: StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                      stream: controller.getDataSiswaStream(),
                                      builder: (context, snapshotsiswa) {
                                        if (snapshotsiswa.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshotsiswa.hasData) {
                                          return ListView.builder(
                                            itemCount:
                                                snapshotsiswa.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              String namaSiswa = snapshotsiswa
                                                      .data!.docs[index]
                                                      .data()['namasiswa'] ??
                                                  'No Name';
                                              String nisnSiswa = snapshotsiswa
                                                      .data!.docs[index]
                                                      .data()['nisn'] ??
                                                  'No NISN';
                                              return ListTile(
                                                title: Text(snapshotsiswa
                                                    .data!.docs[index]
                                                    .data()['namasiswa']),
                                                subtitle: Text(snapshotsiswa
                                                    .data!.docs[index]
                                                    .data()['kelas']),
                                                leading: CircleAvatar(
                                                  child: Text(snapshotsiswa
                                                      .data!.docs[index]
                                                      .data()['namasiswa'][0]),
                                                ),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    IconButton(
                                                      tooltip: 'Detail Nilai',
                                                      icon: const Icon(
                                                          Icons.info_outlined),
                                                      onPressed: () {
                                                        // controller
                                                        //     .tambahkanKelompokSiswa(
                                                        //         namaSiswa,
                                                        //         nisnSiswa);
                                                        controller
                                                            .simpanSiswaKelompok(
                                                                namaSiswa,
                                                                nisnSiswa);
                                                        // tampilkan siswa yang sudah terpilih
                                                        // controller.tampilkan();
                                                        // controller.refreshTampilan();
                                                        // print('simpan siswa');
                                                      },
                                                    ),
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
                                ),
                              ),
                            );
                          },
                          child: Text(k),
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            //============================================
            // ElevatedButton(onPressed: ()=>controller.getPengampu(), child: Text('test')),
            SizedBox(height: 30),
            FutureBuilder(
                future: controller.getDataKelompokYangDiajar(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    List<String> kelasAjarGuru = snapshot.data as List<String>;
                    return SingleChildScrollView(
                      child: Row(
                        children: kelasAjarGuru.map((k) {
                          return TextButton(
                            onPressed: () {},
                            child: Text(
                              k,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
            SizedBox(height: 15),
            Divider(height: 3),
            SizedBox(height: 15),
      
      
          ]
      ),
    );
  }
}
