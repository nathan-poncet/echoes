import 'package:echoes/src/common_widgets/feedback/dialog/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(BuildContext context) {
    if (!isLoading && hasError) {
      final message = _errorMessage(error);
      showExceptionBottomAlert(
        context: context,
        title: "Erreur",
        exception: message,
      );
    }
  }

  String _errorMessage(Object? error) {
    return error.toString();
  }
}
