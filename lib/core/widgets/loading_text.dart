import 'package:flutter/material.dart';

import 'image.dart';

class LoadingText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final LoadingTextIcon? prefixIcon;
  final LoadingTextIcon? suffixIcon;
  final bool isLoading;
  final double? loadingProgress;
  final double spacing;

  const LoadingText({
    required this.text,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.loadingProgress,
    this.spacing = 12,
  });

  @override
  Widget build(final BuildContext context) {
    final buttonStyle = ElevatedButtonTheme.of(context).style;

    if (isLoading) {
      return CircularProgressIndicator.adaptive(value: loadingProgress);
    }
    final foregroundColor = buttonStyle?.foregroundColor?.resolve({});

    return Row(
      mainAxisSize: .min,
      children: [
        if (prefixIcon != null) ...[
          _buildIcon(prefixIcon!, foregroundColor),
          SizedBox(width: spacing),
        ],
        Text(text, style: textStyle),
        if (suffixIcon != null) ...[
          SizedBox(width: spacing),
          _buildIcon(suffixIcon!, foregroundColor),
        ],
      ],
    );
  }

  Widget _buildIcon(
    final LoadingTextIcon data,
    final Color? foregroundColor,
  ) {
    if (data.widget != null) {
      Widget child = data.widget!;
      if (data.isColorDynamic && foregroundColor != null) {
        child = IconTheme.merge(
          data: IconThemeData(color: foregroundColor),
          child: child,
        );
      } else if (data.color != null) {
        child = IconTheme.merge(
          data: IconThemeData(color: data.color),
          child: child,
        );
      }

      final mWidth = data.size ?? data.width;
      final mHeight = data.size ?? data.height;
      if (mWidth != null || mHeight != null) {
        child = SizedBox(width: mWidth, height: mHeight, child: child);
      }
      return child;
    }

    return AppImage(
      data.icon!,
      color: data.isColorDynamic ? foregroundColor : data.color,
      width: data.size ?? data.width,
      height: data.size ?? data.height,
      fit: .contain,
    );
  }
}

class LoadingTextIcon {
  final String? icon;
  final Widget? widget;
  final double? width;
  final double? height;
  final double? size;
  final Color? color;
  final bool isColorDynamic;

  LoadingTextIcon({
    this.icon,
    this.widget,
    this.width,
    this.height,
    this.size,
    this.color,
    this.isColorDynamic = false,
  }) : assert(
          (icon != null && widget == null) || (icon == null && widget != null),
          'Either icon or widget must be provided',
        ) {
    if (isColorDynamic) {
      assert(color == null);
    }
  }
}
