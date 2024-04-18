import 'package:echoes/src/constants/app_sizes.dart';
import 'package:echoes/src/constants/paddings.dart';
import 'package:flutter/material.dart';

Future<T?> showModalBottomSheetIntrinsicHeight<T>(
        {required BuildContext context,
        required String title,
        required String description,
        required Widget body,
        bool isDismissable = true,
        SizedBox spaceBetweenTextAndBody = gapH32}) =>
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(Sizes.p16))),
      showDragHandle: isDismissable,
      isDismissible: isDismissable,
      isScrollControlled: false,
      useSafeArea: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            minimum: EdgeInsets.only(bottom: Paddings.page.bottom),
            child: Padding(
              padding: Paddings.pageHorizontal.copyWith(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  top: isDismissable ? null : Paddings.page.top),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  gapH12,
                  Text(description, style: Theme.of(context).textTheme.bodyLarge),
                  if (description != '') spaceBetweenTextAndBody,
                  IntrinsicHeight(child: body),
                ],
              ),
            ),
          ),
        );
      },
    );
