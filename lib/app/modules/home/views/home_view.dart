import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Obx(
        () => controller.myWidgets.elementAt(controller.indexWidget.value),
      ),
      bottomNavigationBar: ConvexAppBar(
        // style: TabStyle.fixedCircle,
        style: TabStyle.react,
        curveSize: 80,
        initialActiveIndex: 1,
        backgroundColor: Colors.indigo[600],
        onTap: (value) => controller.changeIndex(value),
        items: [
          TabItem(
              title: "Home",
              icon: Icon(Icons.home),
            ),
            TabItem(
              title: "Absensi",
              icon: Icon(Icons.fingerprint_outlined),
            ),
            TabItem(
              title: "Profile",
              icon: Icon(Icons.person),
            ),
        ]),
    );
  }
}
