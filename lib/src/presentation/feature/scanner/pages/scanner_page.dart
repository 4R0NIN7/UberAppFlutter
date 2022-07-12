import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';

import '../../../../core/values/ui_values.dart';
import '../../deviceDetails/pages/device_details_screen.dart';
import '../controller/scanner_controller.dart';

class ScannerPage extends StatelessWidget {
  ScannerPage({Key? key}) : super(key: key);
  final scannerController = Get.find<ScannerController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          body: Container(
              margin: const EdgeInsets.only(top: value20),
              child: _listScannedDevices()),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (scannerController.isScanning.isFalse) {
                  scannerController.startScanning();
                } else {
                  scannerController.stopScanning();
                }
              },
              backgroundColor: scannerController.isScanning.isFalse
                  ? Colors.blueAccent
                  : Colors.redAccent,
              foregroundColor: Colors.white,
              child: Icon(
                scannerController.isScanning.isFalse
                    ? Icons.search
                    : Icons.search_off,
              )),
        ));
  }

  Widget _listScannedDevices() {
    return Obx(() => ListView.builder(
        padding: const EdgeInsets.all(10.0),
        shrinkWrap: false,
        itemCount: scannerController.discoveredDevices.length,
        itemBuilder: (BuildContext context, int index) {
          return _listItemScannedDevice(
              context, index, scannerController.discoveredDevices[index]);
        }));
  }

  Widget _listItemScannedDevice(
      BuildContext context, int index, DiscoveredDevice discoveredDevice) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.devices),
        ),
        title: Text(discoveredDevice.name),
        subtitle: Text("Rssi: ${discoveredDevice.rssi}"),
        onTap: () {
          scannerController.stopScanning();
          Get.to(() => DetailsScreen(device: discoveredDevice));
        },
      ),
    );
  }

  SnackbarController _showSnackbar(DiscoveredDevice discoveredDevice) {
    return Get.snackbar(
      "You have clicked",
      discoveredDevice.name,
      icon: const Icon(Icons.devices, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
