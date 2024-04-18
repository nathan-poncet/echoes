import 'package:echoes/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  final String icon;
  final double? size;
  final Color? color;

  const SvgIcon(this.icon, {super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);

    final double? iconSize = size ?? iconTheme.size;
    final double iconOpacity = iconTheme.opacity ?? 1.0;
    Color iconColor = color ?? iconTheme.color!;
    if (iconOpacity != 1.0) {
      iconColor = iconColor.withOpacity(iconColor.opacity * iconOpacity);
    }

    return SvgPicture.asset(icon,
        width: iconSize ?? Sizes.p12,
        height: iconSize ?? Sizes.p12,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn));
  }
}
