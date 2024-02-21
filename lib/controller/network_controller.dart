import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      _showNoInternetSnackbar();
    } else {
      _closeSnackbarIfOpen();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        _showBackOnlineSnackbar();
      }
    }
  }

  void _showNoInternetSnackbar() {
    Get.rawSnackbar(
      messageText: const Text(
        'No Internet Connection',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      isDismissible: false,
      duration: const Duration(days: 1),
      backgroundColor: Colors.red[400]!,
      icon: const Icon(
        Icons.wifi_off,
        color: Colors.white,
        size: 35,
      ),
      margin: EdgeInsets.zero,
      snackStyle: SnackStyle.GROUNDED,
    );
  }

  void _showBackOnlineSnackbar() {
    Get.rawSnackbar(
      messageText: const Text(
        'Back Online',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      isDismissible: false,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green[400]!,
      icon: const Icon(
        Icons.wifi_outlined,
        color: Colors.white,
        size: 35,
      ),
      margin: EdgeInsets.zero,
      snackStyle: SnackStyle.GROUNDED,
    );
  }


  void _closeSnackbarIfOpen() {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
  }
}
