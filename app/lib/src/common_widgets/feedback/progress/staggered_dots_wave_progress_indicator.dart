import 'package:echoes/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StaggeredDotsWaveProgressIndicator extends StatelessWidget {
  const StaggeredDotsWaveProgressIndicator({super.key, this.size = Sizes.p48, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: color ?? Theme.of(context).colorScheme.onBackground,
      size: size,
    );
  }
}
