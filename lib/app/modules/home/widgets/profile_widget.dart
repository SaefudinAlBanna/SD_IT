import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guru_project/app/modules/home/controllers/home_controller.dart';
import 'package:guru_project/app/routes/app_pages.dart';

class ProfileWidget extends GetView<HomeController> {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.getProfileBaru(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data!.data()!;
            return _buildProfileContent(data);
          }
          
          return const Center(child: Text('Data tidak ditemukan'));
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Profile",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.indigo[400],
      actions: [
        IconButton(
          onPressed: () => controller.signOut(),
          icon: const Icon(Icons.logout, size: 25, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildProfileContent(Map<String, dynamic> data) {
    return Stack(
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
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              _buildProfileHeader(data),
              const SizedBox(height: 50),
              Container(
                height: 1.5,
                color: Colors.grey[400],
              ),
              Expanded(
                child: _buildProfileInfo(data),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> data) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            image: DecorationImage(
              image: NetworkImage("https://ui-avatars.com/api/?name=${data['nama']}"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          data['nama'].toString().toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          "${data['role']}",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(Map<String, dynamic> data) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        children: [
          const SizedBox(height: 20),
          _buildInfoHeader(data),
          const SizedBox(height: 5),
          _buildInfoCard(data),
        ],
      ),
    );
  }

  Widget _buildInfoHeader(Map<String, dynamic> data) {
    // print("datanya adalah : $data");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Info Pegawai",
          style: TextStyle(fontSize: 20),
        ),
        IconButton(
          onPressed: () => Get.toNamed(Routes.UPDATE_PASSWORD),
          icon: const Icon(Icons.vpn_key_outlined, size: 25, color: Colors.grey),
        ),
        IconButton(
          onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
          icon: const Icon(Icons.abc, size: 25, color: Colors.grey),
        ),
        IconButton(
          onPressed: () => Get.toNamed(Routes.UPDATE_PEGAWAI, arguments: data),
          icon: const Icon(Icons.change_circle_outlined, size: 25, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> data) {
    return Card(
      color: Colors.grey[200],
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ...ListTile.divideTiles(
              color: Colors.grey,
              tiles: _buildInfoTiles(data),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInfoTiles(Map<String, dynamic> data) {
    return [
      _buildInfoTile(Icons.key_outlined, "NIP / NIK", data['nip']),
      _buildInfoTile(Icons.email_outlined, "Email", data['email']),
      _buildInfoTile(Icons.male_outlined, "Jenis Kelamin", "Laki-Laki"),
      _buildInfoTile(Icons.bloodtype_rounded, "Gol. Darah", "O"),
      _buildInfoTile(Icons.my_location, "Alamat Domisili", "Pringgolayan RT.08 Banguntapan"),
      _buildInfoTile(Icons.phone_android_outlined, "No Hp", data['noHp']),
      _buildInfoTile(Icons.man_3_outlined, "Nama Ayah", "Saefudin"),
      _buildInfoTile(Icons.woman_outlined, "Nama Ibu", "Jumariyah"),
    ];
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class ClassClipPathTop extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
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
