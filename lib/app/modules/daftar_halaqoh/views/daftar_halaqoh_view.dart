import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:guru_project/app/routes/app_pages.dart';

import '../controllers/daftar_halaqoh_controller.dart';

class DaftarHalaqohView extends GetView<DaftarHalaqohController> {
  DaftarHalaqohView({super.key});

  final data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          shadowColor: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(30))),
          width: 230,
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(15),
              height: 150,
              width: 230,
              color: Colors.grey,
              alignment: Alignment.bottomLeft,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                ),
              ),
            ),

            ListTile(
              onTap: () {
                Get.back();
                Get.defaultDialog(
                  title: '${data['fase']}',
                  content: SizedBox(
                    // height: 450,
                    // width: 350,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 5),
                            FutureBuilder<List<String>>(
                              future: controller.getDataKelasYangAda(),
                              builder: (context, snapshotkelas) {
                                // print('ini snapshotkelas = $snapshotkelas');
                                if (snapshotkelas.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshotkelas.hasData) {
                                  List<String> kelasAjarGuru =
                                      snapshotkelas.data!;
                                  return SingleChildScrollView(
                                    child: Row(
                                      children: kelasAjarGuru.map((k) {
                                        return TextButton(
                                          onPressed: () {
                                            Get.back();
                                            controller.kelasSiswaC.text = k;
                                            Get.bottomSheet(
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                    vertical: 30),
                                                color: Colors.white,
                                                child: Center(
                                                  child: StreamBuilder<
                                                          QuerySnapshot<
                                                              Map<String,
                                                                  dynamic>>>(
                                                      stream: controller
                                                          .getDataSiswaStream(),
                                                      builder: (context,
                                                          snapshotsiswa) {
                                                        if (snapshotsiswa
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return CircularProgressIndicator();
                                                        } else if (snapshotsiswa
                                                            .hasData) {
                                                          return ListView
                                                              .builder(
                                                            itemCount:
                                                                snapshotsiswa
                                                                    .data!
                                                                    .docs
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              String namaSiswa =
                                                                  snapshotsiswa
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .data()['namasiswa'] ??
                                                                      'No Name';
                                                              String nisnSiswa =
                                                                  snapshotsiswa
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .data()['nisn'] ??
                                                                      'No NISN';
                                                              // ignore: prefer_is_empty
                                                              if (snapshotsiswa
                                                                          .data!
                                                                          .docs
                                                                          .length ==
                                                                      0 ||
                                                                  snapshotsiswa
                                                                      .data!
                                                                      .docs
                                                                      .isEmpty) {
                                                                return Center(
                                                                  child: Text(
                                                                      'Semua siswa sudah terpilih'),
                                                                );
                                                              } else {
                                                                return ListTile(
                                                                  title: Text(snapshotsiswa
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .data()[
                                                                      'namasiswa']),
                                                                  subtitle: Text(
                                                                      snapshotsiswa
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .data()['kelas']),
                                                                  leading:
                                                                      CircleAvatar(
                                                                    child: Text(snapshotsiswa
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .data()['namasiswa'][0]),
                                                                  ),
                                                                  trailing: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: <Widget>[
                                                                      IconButton(
                                                                        tooltip:
                                                                            'Detail Nilai',
                                                                        icon: const Icon(
                                                                            Icons.info_outlined),
                                                                        onPressed:
                                                                            () {
                                                                          controller.simpanSiswaKelompok(
                                                                              namaSiswa,
                                                                              nisnSiswa);
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          );
                                                        } else {
                                                          return Center(
                                                            child: Text(
                                                                'No data available'),
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
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              leading: Icon(Icons.person_add_sharp),
              title: Text('Tambah Siswa'),
            ),
            //  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            //   stream: controller.getProfileBaru(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return ListTile(
            //         onTap: () => Get.toNamed(
            //           Routes.UPDATE_PEGAWAI,
            //           arguments: snapshot.data!.data(),
            //         ),
            //         leading: Icon(Icons.person),
            //         title: Text('Update Profile'),
            //       );
            //     }
            //     return SizedBox.shrink(); // Return an empty widget if no data
            //   },
            // ),
          ]),
        ),
        appBar: AppBar(
          title: Text(data['namapengampu']),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.getDaftarHalaqoh(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return ListView.builder(
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
                        IconButton(
                          tooltip: 'pindah',
                          icon: const Icon(Icons.change_circle_outlined),
                          onPressed: () {
                            Get.defaultDialog(
                              barrierDismissible: false,
                              title: '${data['fase']}',
                              content: SizedBox(
                                height: 300,
                                width: 400,
                                child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        // Text(data['fase']),
                                        SizedBox(height: 20),
                                        DropdownSearch<String>(
                                          decoratorProps:
                                              DropDownDecoratorProps(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              filled: true,
                                              labelText: 'Pengampu',
                                            ),
                                          ),
                                          selectedItem: controller
                                                  .pengampuC.text.isNotEmpty
                                              ? controller.pengampuC.text
                                              : null,
                                          items: (f, cs) =>
                                              controller.getDataPengampuFase(),
                                          onChanged: (String? value) {
                                            if (value != null) {
                                              controller.pengampuC.text = value;
                                            }
                                          },
                                          popupProps: PopupProps.menu(
                                              fit: FlexFit.tight),
                                        ),
                                        SizedBox(height: 20),
                                        TextField(
                                          controller: controller.alasanC,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Alasan Pindah',
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (controller.isLoading.isFalse) {
                                              // Get.back();
                                              await controller.pindahkan();
                                              // controller.test();
                                            }
                                          },
                                          // child: Text('Pindah halaqoh'),
                                          child: Row(
                                            children: [
                                              Text(controller.isLoading.isFalse ? "Pindah halaqoh" : "LOADING..."),
                                              SizedBox(width: 15),
                                              Center(child: controller.isLoading.isFalse ? SizedBox()  : CircularProgressIndicator()), 
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                        onPressed: () => Get.back(),
                                        child: Text('Batal')),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        // IconButton(
                        //   tooltip: 'hapus',
                        //   icon: const Icon(Icons.cancel_outlined),
                        //   onPressed: () {
                        //     controller.deleteUser(doc['nisn']);
                        //     controller.ubahStatusSiswa(
                        //         doc['nisn'], doc['kelas']);
                        //     controller.getDaftarHalaqoh();
                        //   },
                        // ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ));
  }
}
