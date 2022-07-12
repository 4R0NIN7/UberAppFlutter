import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_app_flutter/src/core/util/modules/modules.dart';
import 'package:uber_app_flutter/src/presentation/feature/scanner/pages/scanner_page.dart';

void main() {
  Fimber.plantTree(DebugTree());
  runApp(
      GetMaterialApp(home: const SplashScreen(), initialBinding: AppBinding()));
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ElevatedButton(
                child: const Text("Go to Scanner"),
                onPressed: () => {Get.to(ScannerPage())})));
  }
}
