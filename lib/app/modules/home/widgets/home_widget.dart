import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeWidget extends GetView<HomeController> {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.userStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data!.data()!;

            //menampilkan kelas guru yang diajar
            List kelasAjarGuru = data['kelasAjar'];

            return Scaffold(
              appBar: AppBar(
                title: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    data['nama'].toString().toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                backgroundColor: Colors.indigo[400],
                leading: Container(
                  height: 85,
                  width: 85,
                  margin: EdgeInsets.only(left: 15, top: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.grey[350],
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://ui-avatars.com/api/?name=${data['nama']}")),
                  ),
                ),
                actions: [
                  if (snapshot.connectionState == ConnectionState.waiting)
                    // SizedBox(),
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (snapshot.data!.data()!['role'] == 'admin')
                    IconButton(
                      onPressed: () => Get.toNamed(Routes.TAMBAH_PEGAWAI),
                      icon: Icon(Icons.admin_panel_settings_outlined),
                    )
                  else
                    SizedBox(),
                  Obx(
                    () => ElevatedButton(
                      onPressed: () async {
                        if (controller.isLoading.isFalse) {
                          controller.isLoading.value = true;
                          await FirebaseAuth.instance.signOut();
                          controller.isLoading.value = false;
                          Get.offAllNamed(Routes.LOGIN);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[400]),
                      child: controller.isLoading.isFalse
                          ? Icon(Icons.logout_outlined, color: Colors.black)
                          : CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
              body: Stack(
                children: [
                  ClipPath(
                    clipper: ClassClipPathTop(),
                    child: Container(
                      height: 250,
                      width: Get.width,
                      color: Colors.indigo[400],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            ClipPath(
                              clipper: ClipPathClass(),
                              child: Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.symmetric(horizontal: 25),
                                height: 215,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade200,
                                      Colors.blue.shade400
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '07:00:02',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'Masuk',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: IconButton(icon: Icon(Icons.alarm, size: 45), onPressed: () { Get.toNamed(Routes.CONTOH); }),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '14:10:02',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'Pulang',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Divider(
                                      height: 2,
                                      color: Colors.black,
                                    ),
                                    SizedBox(height: 5),
                                    Center(
                                      child: Container(
                                        height: 33,
                                        width: 230,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.amber,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Durasi Kerja : 00.00.00 Jam',
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: kelasAjarGuru.map((kelasNya) {
                                          return TextButton(
                                              onPressed: () {
                                                Get.toNamed(Routes.DAFTAR_KELAS, arguments: kelasNya);
                                                // print(kelasNya);
                                              },
                                              child: Text(kelasNya)
                                              );
                                        }).toList(),
                                        
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Container(
                          height: 1,
                          color: Colors.black,
                        ),
                        SizedBox(height: 25),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // GestureDetector(
                                      //   if(snapshot.connectionState == ConnectionState.done)
                                      //   if(snapshot.data!.data()!['role'] == 'admin')
                                      //   onTap: () =>
                                      //       Get.toNamed(Routes.TAMBAH_SISWA),
                                      //   child: ColumnMenuTengah(
                                      //     icon: Icon(Icons.person_add_outlined,
                                      //         size: 40),
                                      //     judulbawah: 'TAMBAH SISWA',
                                      //   ),
                                      // ),
                                      GestureDetector(
                                        onTap: () =>
                                            Get.toNamed(Routes.DAFTAR_SISWA),
                                        child: ColumnMenuTengah(
                                          icon: Icon(
                                              Icons.calendar_month_outlined,
                                              size: 45),
                                          judulbawah: 'DAFTAR SISWA',
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            Get.toNamed(Routes.DAFTAR_KELAS),
                                        child: ColumnMenuTengah(
                                          icon: Icon(Icons.facebook_outlined,
                                              size: 45),
                                          judulbawah: 'DAFTAR KELAS',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            Get.toNamed(Routes.DAFTAR_NILAI),
                                        child: ColumnMenuTengah(
                                          icon: Icon(Icons.dashboard_outlined,
                                              size: 45),
                                          judulbawah: 'DAFTAR NILAI',
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => Get.toNamed(Routes.INFO_SEKOLAH),
                                        child: ColumnMenuTengah(
                                          icon: Icon(
                                              Icons.calendar_month_outlined,
                                              size: 45),
                                          judulbawah: 'INFO SEKOLAH',
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => Get.toNamed(Routes.TAMBAH_KELOMPOK_MENGAJI),
                                        child: ColumnMenuTengah(
                                          icon: Icon(Icons.facebook_outlined,
                                              size: 45),
                                          judulbawah: 'Tambah kelompok',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox();
          }
        });
  }
}

class ColumnMenuTengah extends StatelessWidget {
  const ColumnMenuTengah({
    required this.judulbawah,
    required this.icon,
    super.key,
  });

  final String judulbawah;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            // color: Colors.amber,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Center(
            child: icon,
          ),
        ),
        SizedBox(height: 5),
        Text(judulbawah),
      ],
    );
  }
}

class TxtBtnKelas extends StatelessWidget {
  const TxtBtnKelas({
    super.key,
    required this.kelasnya,
  });

  final String kelasnya;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        kelasnya,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width - 50, size.height);
    path.lineTo(size.width, size.height - 50);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}

class ClassClipPathTop extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}
