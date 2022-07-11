import 'package:uber_app_flutter/src/database/database.dart';

class FakeApiClient {
  Future<String> sendData(List<ReadingEntityData> list) async {
    return Future.delayed(
      const Duration(seconds: 2),
      () => 'Data sent!',
    );
  }
}
