import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:guru_project/app/routes/app_pages.dart';

import '../controllers/tambah_siswa_kelompok_controller.dart';

final dataxx = Get.arguments;

class TambahSiswaKelompokView extends GetView<TambahSiswaKelompokController> {
  const TambahSiswaKelompokView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('TambahSiswaKelompokView'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.getIsiBaru(),
          builder: (context, snapshotKel) {
            if (snapshotKel.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshotKel.hasData) {
            Map<String, dynamic> data = snapshotKel.data!.data()!;
            
          
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tahun Ajaran :'),
                    Text(data['tahunajaran'].toString()),
                  ],
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data['namasemester'].toString()),
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
                        Text(data['namapengampu'].toString()),
                        
                        SizedBox(height: 10),
                        // Text(data['tempatmengaji'].toString()),
                        // Text('Tahun Ajaran : '),
                  FutureBuilder<String>(
                      future: controller.getDataTempat(),
                      builder: (context, snapshottempat) {
                        if (snapshottempat.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshottempat.hasError) {
                          return Text('Error');
                        } else {
                          return Text(
                            snapshottempat.data ?? 'No Data',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          );
                        }
                      }),


                        SizedBox(height: 10),
                        Text(data['fase'].toString()),
                        
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
                                                            controller.tampilSiswaKelompok();
                                                            controller.refreshTampilan();
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
                //=======================================================
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: controller.tampilSiswaKelompok(),
                      builder: (context, snapshotKelompok) {
                        if (snapshotKelompok.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        // ignore: prefer_is_empty
                        if (snapshotKelompok.data?.docs.length == 0 ||
                            snapshotKelompok.data == null) {
                          return Center(
                            child: Text(
                                'Silahkan pilih siswa kelompok di halaman sebelumnya'),
                          );
                        }
                        // else {
                        return ListView.builder(
                          itemCount: snapshotKelompok.data!.docs.length,
                          itemBuilder: (context, index) {
                            String namaSiswa = snapshotKelompok.data!.docs[index]
                                    .data()['namasiswa'] ??
                                'No Name';
                            String kelasSiswa = snapshotKelompok.data!.docs[index]
                                    .data()['kelas'] ??
                                'No KELAS';
                            return ListTile(
                              title: Text(namaSiswa),
                              subtitle: Text(kelasSiswa),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                      onPressed: () {}, icon: Icon(Icons.checklist_rtl_outlined)),
                                  IconButton(
                                    onPressed: () {
                                      Get.toNamed(Routes.CONTOH, arguments: namaSiswa);
                                    },
                                    icon: Icon(Icons.add_box),
                                  ),
                                  Checkbox(value: false, onChanged: (value) => true),
                                ],
                              ),
                            );
                          },
                        );
                        // }
                      }),
                ),
                //=======================================================
                FloatingActionButton(
                    backgroundColor: Colors.blueAccent,
                    onPressed: () {
                      // Get.offAllNamed(Routes.TAMBAH_KELOMPOK_MENGAJI);
                      Get.offAllNamed(Routes.HOME);
                      RefreshCallback;
                    },
                    child: Text('kembali')),
                    ElevatedButton(onPressed: (){
                      Get.to(TambahSiswaKelompokView());
                    }, child: Text('test')),
              ],
            );
          } 
          return const Center(child: Text('Data tidak ditemukan'));
          }
        ));
  }
}
