import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tambah_pegawai_controller.dart';

class TambahPegawaiView extends GetView<TambahPegawaiController> {
  const TambahPegawaiView({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TambahPegawaiView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextFormField(
            autocorrect: false,
            controller: controller.nipC,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                icon: Icon(Icons.numbers_outlined),
                labelText: 'NIP *',
                hintText: 'Input NIP Karyawan'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          TextFormField(
            autocorrect: false,
            controller: controller.namaC,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.person),
              hintText: 'Nama Karyawan / Pegawai',
              labelText: 'Nama *',
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            autocorrect: false,
            controller: controller.emailC,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.email),
              hintText: 'Alamat Email',
              labelText: 'Email *',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 10),
          TextFormField(
            autocorrect: false,
            controller: controller.noHpC,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.phone),
              hintText: 'No Handphone',
              labelText: 'No Handphone *',
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 20),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.tambahPegawai();
                }
              },
              child: Text(controller.isLoading.isFalse
                  ? 'Tambah Pegawai'
                  : 'LOADING...'),
            ),
          ),
        ],
      ),
    );
  }
}
