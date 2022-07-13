import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_app_flutter/src/core/util/functions.dart';
import 'package:uber_app_flutter/src/core/values/ui_values.dart';

import '../../../../domain/entities/characteristics.dart';
import '../controller/device_details_controller.dart';

class DetailsScreen extends StatelessWidget {
  DetailsScreen({Key? key}) : super(key: key);
  final deviceDetailsController = Get.find<DeviceDetailsController>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: _tabAppBar(),
              body: _tabBarView(deviceDetailsController),
            )));
  }

  AppBar _tabAppBar() {
    return AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Connected device ${deviceDetailsController}"),
        bottom: const TabBar(tabs: [
          Tab(icon: Icon(Icons.on_device_training)),
          Tab(icon: Icon(Icons.area_chart)),
          Tab(icon: Icon(Icons.logout))
        ]));
  }

  TabBarView _tabBarView(DeviceDetailsController deviceDetailsController) {
    return TabBarView(children: [
      _actualReadingView(deviceDetailsController),
      _chartView(deviceDetailsController),
      _logOutView()
    ]);
  }

  Widget _chartView(DeviceDetailsController deviceDetailsController) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _listCharacteristicsPerDay(deviceDetailsController));
  }

  Widget _listCharacteristicsPerDay(
      DeviceDetailsController deviceDetailsController) {
    return Obx(() => ListView.builder(
        padding: const EdgeInsets.all(10.0),
        shrinkWrap: false,
        itemCount: deviceDetailsController.characteristicsPerDay.value.length,
        itemBuilder: (BuildContext context, int index) {
          return _listItemCharacteristics(
              context,
              index,
              deviceDetailsController.characteristicsPerDay.value[index],
              deviceDetailsController);
        }));
  }

  Widget _listItemCharacteristics(
      BuildContext context,
      int index,
      Characteristics characteristics,
      DeviceDetailsController deviceDetailsController) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.devices),
        ),
        title: Text(characteristics.day.toDateString()),
        onTap: () {
          deviceDetailsController.getReadingsByDay(characteristics.day);
        },
      ),
    );
  }

  Widget _logOutView() {
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("Logout view")));
  }

  Widget _actualReadingView(DeviceDetailsController deviceDetailsController) {
    return Obx(() => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Card(
                margin: const EdgeInsets.all(value20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                    leading: const Icon(Icons.data_exploration),
                    title: const Text("Actual reading from device"),
                    subtitle: Text(
                        "Temperature ${deviceDetailsController.lastReading.value?.temperature.toPrecision(2)} "
                        "Humidity ${deviceDetailsController.lastReading.value?.humidity} "))))));
  }
}
