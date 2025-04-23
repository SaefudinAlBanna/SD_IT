import 'package:flutter/material.dart';

import 'package:dropdown_search/dropdown_search.dart';

import 'package:get/get.dart';

import '../controllers/tambah_siswa_controller.dart';

class TambahSiswaView extends GetView<TambahSiswaController> {
  const TambahSiswaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TAMBAH SISWA BARU'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16,),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tahun Ajaran : ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    FutureBuilder<String>(
                        future: controller.getTahunAjaranTerakhir(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error');
                          } else {
                            return Text(snapshot.data ?? 'No Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),);
                          }
                        }),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "DATA SISWA",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 5,
                  width: Get.width,
                  color: Colors.blue,
                ),
                TextFormField(
                  controller: controller.nisnSiswaController,
                  decoration: const InputDecoration(labelText: 'NISN'),
                ),
                TextFormField(
                  controller: controller.namaSiswaController,
                  decoration: const InputDecoration(labelText: 'Nama Siswa'),
                ),
                DropdownSearch<String>(
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      prefixText: 'Jenis Kelamin: ',
                    ),
                  ),
                  selectedItem: controller.jenisKelaminSiswaController.text,
                  items: (f, cs) => ["Laki-laki", 'Perempuan'],
                  onChanged: (String? value) {
                    controller.jenisKelaminSiswaController.text = value!;
                  },
                  popupProps: PopupProps.menu(
                      // disabledItemFn: (item) => item == '1A',
                      fit: FlexFit.tight),
                ),
                DropdownSearch<String>(
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      prefixText: 'Agama: ',
                    ),
                  ),
                  selectedItem: controller.agamaSiswaController.text,
                  items: (f, cs) =>
                      ["Islam", 'Kristen', 'Katolik', 'Hindu', 'Budha'],
                  onChanged: (String? value) {
                    controller.agamaSiswaController.text = value!;
                  },
                  popupProps: PopupProps.menu(
                      // disabledItemFn: (item) => item == '1A',
                      fit: FlexFit.tight),
                ),
                TextFormField(
                  controller: controller.tempatLahirSiswaController,
                  decoration: const InputDecoration(labelText: 'Tempat Lahir'),
                ),
                TextFormField(
                  controller: controller.tanggalLahirSiswaController,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Lahir',
                    prefix: IconButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ).then((value) {
                          controller.tanggalLahirSiswaController.text =
                              value.toString();
                        });
                      },
                      icon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                TextFormField(
                  controller: controller.alamatSiswaController,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DATA ORANG TUA",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 5,
                  width: Get.width,
                  color: Colors.blue,
                ),
                TextFormField(
                  controller: controller.namaAyahController,
                  decoration: const InputDecoration(labelText: 'Nama Ayah'),
                ),
                TextFormField(
                  controller: controller.namaIbuController,
                  decoration: const InputDecoration(labelText: 'Nama Ibu'),
                ),
                TextFormField(
                  controller: controller.emailOrangTuaController,
                  decoration:
                      const InputDecoration(labelText: 'Email Orang Tua'),
                ),
                TextFormField(
                  controller: controller.noHpOrangTuaController,
                  decoration:
                      const InputDecoration(labelText: 'No. HP Orang Tua'),
                ),
                TextFormField(
                  controller: controller.alamatOrangTuaController,
                  decoration:
                      const InputDecoration(labelText: 'Alamat Orang Tua'),
                ),
                TextFormField(
                  controller: controller.pekerjaanAyahController,
                  decoration:
                      const InputDecoration(labelText: 'Pekerjaan Ayah'),
                ),
                TextFormField(
                  controller: controller.pekerjaanIbuController,
                  decoration: const InputDecoration(labelText: 'Pekerjaan Ibu'),
                ),
                TextFormField(
                  controller: controller.pendidikanAyahController,
                  decoration:
                      const InputDecoration(labelText: 'Pendidikan Ayah'),
                ),
                TextFormField(
                  controller: controller.pendidikanIbuController,
                  decoration:
                      const InputDecoration(labelText: 'Pendidikan Ibu'),
                ),
                TextFormField(
                  controller: controller.noHpWaliController,
                  decoration: const InputDecoration(labelText: 'No. HP Wali'),
                ),
                TextFormField(
                  controller: controller.alamatWaliController,
                  decoration: const InputDecoration(labelText: 'Alamat Wali'),
                ),
                TextFormField(
                  controller: controller.pekerjaanWaliController,
                  decoration:
                      const InputDecoration(labelText: 'Pekerjaan Wali'),
                ),
                TextFormField(
                  controller: controller.pendidikanWaliController,
                  decoration:
                      const InputDecoration(labelText: 'Pendidikan Wali'),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DATA PEMBAYARAN SEKOLAH",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 5,
                  width: Get.width,
                  color: Colors.blue,
                ),
                TextFormField(
                  controller: controller.biayaSppController,
                  decoration: const InputDecoration(labelText: 'Biaya SPP'),
                ),
                TextFormField(
                  controller: controller.biayaUangPangkalController,
                  decoration:
                      const InputDecoration(labelText: 'Biaya Uang Pangkal'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await
                      controller.tambahSiswa();
                }
              },
              child: const Text('Tambah Siswa'),
            ),
          ],
        ),
      ),
    );
  }
}
