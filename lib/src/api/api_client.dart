import '../data/datasources/localsource/database/database.dart';

class FakeApiClient {
  Future<String> sendData(List<ReadingEntityData> list) async {
    return Future.delayed(
      const Duration(seconds: 2),
      () => 'Data sent!',
    );
  }
}
