import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget(this.errorMessage, {super.key, this.color});
  final String errorMessage;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(color: color ?? Theme.of(context).colorScheme.error),
    );
  }
}
