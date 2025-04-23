import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Password'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                autocorrect: false,
                controller: controller.oldPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Old Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                autocorrect: false,
                controller: controller.newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                autocorrect: false,
                controller: controller.confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => ElevatedButton(
                    onPressed: () {
                      if(controller.isLoading.isFalse) {
                      controller.updatePassword();
                      }
                    },
                    child: Text((controller.isLoading.isFalse) ? "UPDATE" : "Loading.." ),
                  )),
            ),
          ],
        ));
  }
}
