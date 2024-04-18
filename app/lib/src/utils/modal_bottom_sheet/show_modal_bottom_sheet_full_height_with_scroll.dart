import 'package:echoes/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<T?> showModalBottomSheetFullHeightWithScroll<T>(
    {required BuildContext context,
    required Widget Function(ScrollController) builder,
    bool useSafeArea = true}) {
  bool hasBeenPoped = false;

  return showModalBottomSheet<T>(
    useSafeArea: useSafeArea,
    useRootNavigator: true,
    isDismissible: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: context.pop,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              if (!hasBeenPoped && notification.extent <= 0.1) {
                context.pop();
                hasBeenPoped = true;

                return true;
              }

              return false;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 1,
              minChildSize: 0.0,
              maxChildSize: 1.0,
              snap: true,
              snapAnimationDuration: const Duration(milliseconds: 250),
              builder: (context, scrollController) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(Sizes.p16)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: builder(scrollController)),
            ),
          ),
        ),
      );
    },
  );
}
