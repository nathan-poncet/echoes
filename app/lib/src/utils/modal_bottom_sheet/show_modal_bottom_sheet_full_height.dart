import 'package:echoes/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

Future<T?> showModalBottomSheetFullHeight<T>(
        {required BuildContext context, required Widget child}) =>
    showModalBottomSheet<T>(
      useSafeArea: true,
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(Sizes.p16)),
            ),
            child: child);
      },
    );
