import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popcorn1/colours.dart';

class NetworkController extends GetxController
{
  final Connectivity connectivity = Connectivity();

  @override
  void onInit()
  {
    super.onInit();
    connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  void updateConnectionStatus(ConnectivityResult connectivityResult)
  {
    if (connectivityResult == ConnectivityResult.none)
    {
      Get.rawSnackbar(
        messageText: const Text(
          'Connection lost!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          )
        ),
        isDismissible: false,
        duration: const Duration(days: 1),
        backgroundColor: Colours.themeColour,
        icon: const Icon(Icons.wifi_off, color: Colours.scaffoldBgColour, size: 35),
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.GROUNDED,
      );
    }
    else
    {
      if(Get.isSnackbarOpen)
      {
        Get.closeCurrentSnackbar();
      }
    }
  }
}