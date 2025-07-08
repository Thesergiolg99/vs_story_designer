import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class ErrorHandler {
  static void handleError(BuildContext context, dynamic error, {String? customMessage}) {
    debugPrint('Story Designer Error: $error');
    
    String message = customMessage ?? _getErrorMessage(error);
    showToast(
      message,
      position: ToastPosition.bottom,
      backgroundColor: Colors.red.withOpacity(0.8),
      duration: const Duration(seconds: 3),
    );
  }

  static String _getErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException') || 
        error.toString().contains('NetworkException')) {
      return 'Please check your internet connection';
    }
    
    if (error.toString().contains('Permission')) {
      return 'Permission denied. Please grant required permissions';
    }

    if (error.toString().contains('VideoPlayer')) {
      return 'Unable to play video. Please try again';
    }

    if (error.toString().contains('OutOfMemory') || 
        error.toString().contains('Memory')) {
      return 'Not enough memory. Try reducing media quality';
    }

    if (error.toString().contains('Storage')) {
      return 'Storage error. Please check available space';
    }

    return 'Something went wrong. Please try again';
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
