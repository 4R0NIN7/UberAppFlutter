import '../localsource/database/database.dart';

abstract class ApiClient {
  Future<String> sendData(List<ReadingEntityData> list);
}

class FakeApiClient implements ApiClient {
  @override
  Future<String> sendData(List<ReadingEntityData> list) async {
    return Future.delayed(
      const Duration(seconds: 2),
      () => 'Data sent!',
    );
  }
}
