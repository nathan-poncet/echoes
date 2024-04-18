import 'package:echoes/src/constants/app_sizes.dart';
import 'package:echoes/src/utils/modal_bottom_sheet/show_modal_bottom_sheet_intrinsic_height.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const kDialogDefaultKey = Key('dialog-default-key');

/// show a bottom sheet dialog for 3 scenarios : error,  confirm, (success)
Future<bool?> showBottomAlert({
  required BuildContext context,
  required String title,
  bool isDismissable = true,
  // Widget? icon,
  String? description,
  String? cancelActionText,
  String defaultActionText = 'OK',
}) async {
  return showModalBottomSheetIntrinsicHeight<bool>(
    context: context,
    title: title,
    description: description ?? '',
    isDismissable: true,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          child: Text(defaultActionText),
          onPressed: () => context.pop(true),
        ),
        if (cancelActionText != null)
          Padding(
            padding: const EdgeInsets.only(top: Sizes.p12),
            child: TextButton(
              child: Text(cancelActionText, style: Theme.of(context).textTheme.titleMedium),
              onPressed: () => context.pop(false),
            ),
          ),
      ],
    ),
  );
}

/// Generic function to show a platform-aware Material or Cupertino error dialog
Future<void> showExceptionBottomAlert({
  required BuildContext context,
  required String title,
  required String exception,
}) =>
    showBottomAlert(
      context: context,
      title: title,
      description: exception,
      defaultActionText: "Ok",
    );

Future<void> showNotImplementedAlertDialog({required BuildContext context}) => showBottomAlert(
      context: context,
      title: "Non implémenté",
    );
