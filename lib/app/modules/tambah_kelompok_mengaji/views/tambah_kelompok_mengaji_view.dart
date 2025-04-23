import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tambah_kelompok_mengaji_controller.dart';

class TambahKelompokMengajiView
    extends GetView<TambahKelompokMengajiController> {
  const TambahKelompokMengajiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Tahun Ajaran : '),
                  FutureBuilder<String>(
                      future: controller.getTahunAjaranTerakhir(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
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
              SizedBox(height: 20),
              DropdownSearch<String>(
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: 'Fase',
                  ),
                ),
                selectedItem: controller.faseC.text.isNotEmpty
                    ? controller.faseC.text
                    : null,
                items: (f, cs) => controller.getDataFase(),
                onChanged: (String? value) {
                  if (value != null) {
                    controller.faseC.text = value;
                  }
                },
                popupProps: PopupProps.menu(fit: FlexFit.tight),
              ),
              SizedBox(height: 20),
              DropdownSearch<String>(
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: 'Pengampu',
                  ),
                ),
                selectedItem: controller.pengampuC.text.isNotEmpty
                    ? controller.pengampuC.text
                    : null,
                items: (f, cs) => controller.getDataPengampu(),
                onChanged: (String? value) {
                  if (value != null) {
                    controller.pengampuC.text = value;
                  }
                },
                popupProps: PopupProps.menu(fit: FlexFit.tight),
              ),
              SizedBox(height: 20),
              DropdownSearch<String>(
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: 'Tempat',
                  ),
                ),
                selectedItem: controller.tempatC.text.isNotEmpty
                    ? controller.tempatC.text
                    : null,
                items: (f, cs) => controller.getDataTempat(),
                onChanged: (String? value) {
                  if (value != null) {
                    controller.tempatC.text = value;
                    // print('ini tampatC : $value');
                  }
                },
                popupProps: PopupProps.menu(fit: FlexFit.tight),
              ),
              SizedBox(height: 20),
              DropdownSearch<String>(
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: 'semester',
                  ),
                ),
                selectedItem: controller.semesterC.text.isNotEmpty
                    ? controller.semesterC.text
                    : null,
                items: (f, cs) => controller.getDataSemester(),
                onChanged: (String? value) {
                  if (value != null) {
                    controller.semesterC.text = value;
                    // print('ini tampatC : $value');
                  }
                },
                popupProps: PopupProps.menu(fit: FlexFit.tight),
              ),
              SizedBox(height: 30),
              //====================================================
              Divider(height: 3),
              // Disable elevatedbutton ketika database belum terbuat
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    if(controller.faseC.text.isEmpty){
                      Get.snackbar('Peringatan', 'Fase kosong');
                    } else if(controller.pengampuC.text.isEmpty){
                      Get.snackbar('Peringatan', 'Pengampu kosong');
                    } else if(controller.tempatC.text.isEmpty){
                      Get.snackbar('Peringatan', 'Tempat kosong');
                    } else if (controller.semesterC.text.isEmpty){
                      Get.snackbar('Peringatan', 'Semester kosong');
                    } else {
                    controller.buatKelompok();
                    }
                  },
                  child: Text('Buat Kelompok')),
              
            ],
          ),
        ));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Tambah Kelompok Mengaji'),
      backgroundColor: Colors.indigo[400],
      elevation: 0,
    );
  }
}
