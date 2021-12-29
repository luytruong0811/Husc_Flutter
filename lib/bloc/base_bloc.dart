import 'dart:async';

abstract class BaseBloC {
  StreamController<bool> _loadingController =
      StreamController<bool>.broadcast();
  Stream<bool> get loadingState => _loadingController.stream;

  void showLoading() {
    _loadingController.sink.add(true);
  }

  void hideLoading() {
    _loadingController.sink.add(false);
  }

  void clearData();

  void dispose() {
    _loadingController.close();
  }
}
