import 'dart:io';

import 'package:gap/gap.dart';

import '../../pages/pick_and_crop_image/page.dart';
import '../src.dart';

class ButtonView extends StatelessWidget {
  final Function()? onPressed;
  final EdgeInsets margin, padding;
  final Widget child;
  final BoxDecoration? boxDecoration;
  final Color? backgroundColor, borderColor;
  final double borderRadius;
  final double? width, height;
  final String? tooltip;

  const ButtonView({
    super.key,
    required this.onPressed,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    required this.child,
    this.backgroundColor = UIColors.primary,
    this.borderColor,
    this.borderRadius = 4,
    this.boxDecoration,
    this.width,
    this.height,
    this.tooltip,
  });

  ButtonView.text({
    Key? key,
    required Function()? onPressed,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 28,
    ),
    required String text,
    TextStyle? textStyle,
    TextAlign? textAlign,
    Color? backgroundColor = UIColors.primary,
    Color? borderColor,
    double borderRadius = 15,
    double? width,
    double? height = 45,
    String? tooltip,
  }) : this(
          key: key,
          onPressed: onPressed,
          child: Text(
            text,
            style: textStyle ??
                TextStyles.midTitleBold +
                    const TextStyle(
                      color: Colors.white,
                    ),
            textAlign: textAlign,
          ),
          margin: margin,
          padding: padding,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderRadius: borderRadius,
          width: width,
          height: height,
          tooltip: tooltip,
        );

  // ButtonView.gradient({
  //   Key? key,
  //   required Function()? onPressed,
  //   EdgeInsets margin = EdgeInsets.zero,
  //   EdgeInsets padding = const EdgeInsets.symmetric(
  //     vertical: 12,
  //     horizontal: 28,
  //   ),
  //   required Widget child,
  //   Color? borderColor = const Color(0x33FFFFFF),
  //   double borderRadius = 32,
  //   double? width,
  //   double? height,
  //   String? tooltip,
  // }) : this(
  //         key: key,
  //         onPressed: onPressed,
  //         boxDecoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(borderRadius),
  //           gradient: LinearGradient(
  //             begin: Alignment.centerLeft,
  //             end: Alignment.bottomCenter,
  //             colors: [UIThemeColors.gradient1, UIThemeColors.gradient2],
  //           ),
  //           border: borderColor != null
  //               ? Border.all(
  //                   width: 0.8,
  //                   color: borderColor,
  //                 )
  //               : null,
  //         ),
  //         margin: margin,
  //         padding: padding,
  //         backgroundColor: Colors.transparent,
  //         borderColor: Colors.transparent,
  //         borderRadius: borderRadius,
  //         height: height,
  //         width: width,
  //         child: child,
  //         tooltip: tooltip,
  //       );

  // factory ButtonView.gradientText({
  //   Key? key,
  //   required Function()? onPressed,
  //   EdgeInsets margin = EdgeInsets.zero,
  //   EdgeInsets padding = const EdgeInsets.symmetric(
  //     vertical: 12,
  //     horizontal: 28,
  //   ),
  //   required String text,
  //   TextStyle? textStyle,
  //   Color borderColor = const Color(0x33FFFFFF),
  //   double borderRadius = 32,
  //   double? width,
  //   double? height,
  //   String? tooltip,
  // }) =>
  //     ButtonView.gradient(
  //       key: key,
  //       onPressed: onPressed,
  //       margin: margin,
  //       padding: padding,
  //       borderColor: borderColor,
  //       borderRadius: borderRadius,
  //       width: width,
  //       height: height,
  //       tooltip: tooltip,
  //       child: Text(
  //         text,
  //         style: textStyle ?? TextStyles.midTitleBold,
  //       ),
  //     );

  ButtonView.icon({
    Key? key,
    required Function()? onPressed,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    Color? backgroundColor = UIColors.primary,
    Color? borderColor,
    double borderRadius = 32,
    required IconData icon,
    double iconSize = 24,
    Color? iconColor,
    double? width,
    double height = 56,
    String? tooltip,
  }) : this(
          key: key,
          onPressed: onPressed,
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
          margin: margin,
          padding: padding,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderRadius: borderRadius,
          width: width,
          height: height,
          tooltip: tooltip,
        );

  ButtonView.textIcon(
    String text, {
    Key? key,
    required Function()? onPressed,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    Color? backgroundColor = UIColors.primary,
    Color? borderColor,
    double borderRadius = 32,
    required IconData icon,
    double iconSize = 20,
    Color? iconColor,
    TextStyle? textStyle,
    double? width,
    double? height = 56,
    String? tooltip,
  }) : this(
          key: key,
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: iconColor,
              ),
              const Gap(10),
              Text(
                text,
                style: textStyle ??
                    TextStyles.midTitleBold +
                        const TextStyle(
                          color: Colors.white,
                        ),
              ),
            ],
          ),
          margin: margin,
          padding: padding,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderRadius: borderRadius,
          width: width,
          height: height,
          tooltip: tooltip,
        );

  factory ButtonView.imagePick({
    Key? key,
    String? url,
    File? image,
    Widget Function()? emptyBuilder,
    required Function(File? image)? onPick,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    Color? borderColor = const Color(0x33FFFFFF),
    double borderRadius = 10,
    double? width,
    double? height = 280,
    String? tooltip,
  }) =>
      ButtonView(
        key: key,
        margin: margin,
        padding: padding,
        borderColor: borderColor,
        borderRadius: borderRadius,
        width: width,
        height: height,
        onPressed: onPick == null
            ? null
            : () => RouteManager.to(
                  PagesInfo.pickAndCropImage,
                  arguments: PickAndCropImagePageData(onDone: onPick),
                ),
        tooltip: tooltip,
        child: image != null
            ? Image.file(image, fit: BoxFit.cover)
            : url != null
                ? MNetworkImage(
                    url: url,
                    build: (file) => Image.file(file),
                    onLoadingWidget: const CircularProgressIndicator(),
                    onFailedWidget: const Icon(Icons.image_not_supported),
                  )
                : emptyBuilder?.call() ?? const Icon(Icons.image_search),
      );

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        margin: margin,
        decoration: boxDecoration,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            padding: padding,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(
                color: borderColor ?? UIColors.border,
                width: 0.5,
              ),
            ),
          ),
          onPressed: onPressed,
          child: child,
        ),
      );
}

class OutlineButtonView extends StatelessWidget {
  final Function()? onPressed;
  final EdgeInsets margin, padding;
  final Widget child;
  final Color? borderColor;
  final double borderRadius, borderSize;
  final double? width, height;

  const OutlineButtonView({
    super.key,
    required this.onPressed,
    this.width,
    this.height,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
    required this.child,
    this.borderColor,
    this.borderRadius = 20,
    this.borderSize = 1.8,
  });

  OutlineButtonView.text(
    String text, {
    Key? key,
    required Function()? onPressed,
    TextStyle? textStyle,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = const EdgeInsets.symmetric(
      vertical: 13,
      horizontal: 15,
    ),
    Color? borderColor,
    double borderRadius = 20,
    double borderSize = 1.8,
    double? width,
    double? height,
  }) : this(
          key: key,
          onPressed: onPressed,
          child: Text(text, style: textStyle),
          margin: margin,
          padding: padding,
          borderColor: borderColor,
          borderRadius: borderRadius,
          borderSize: borderSize,
          width: width,
          height: height,
        );

  OutlineButtonView.icon(
    IconData icon, {
    Key? key,
    required Function()? onPressed,
    double size = 50,
    double? iconSize,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    Color? borderColor,
    Color? iconColor,
    double borderRadius = 50,
    double borderSize = 1.8,
  }) : this(
          key: key,
          onPressed: onPressed,
          child: Icon(
            icon,
            size: iconSize ?? size * 0.7,
            color: iconColor,
          ),
          margin: margin,
          padding: padding,
          borderColor: borderColor,
          borderRadius: borderRadius,
          borderSize: borderSize,
          width: size,
          height: size,
        );

  OutlineButtonView.image(
    ImageProvider image, {
    Key? key,
    required Function()? onPressed,
    double size = 50,
    double? iconSize,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    Color? borderColor,
    double borderRadius = 50,
    double borderSize = 1.8,
  }) : this(
          key: key,
          onPressed: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
            width: iconSize ?? size * 0.7,
            height: iconSize ?? size * 0.7,
          ),
          margin: margin,
          padding: padding,
          borderColor: borderColor,
          borderRadius: borderRadius,
          borderSize: borderSize,
          width: size,
          height: size,
        );

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        margin: margin,
        constraints: BoxConstraints(
          maxHeight: height ?? double.infinity,
          maxWidth: width ?? double.infinity,
        ),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            side: BorderSide(
              color: borderColor ?? UIThemeColors.iconBg,
              width: borderSize,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding,
          ),
          child: child,
        ),
      );
}

class CirclerButtonView extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final double size, borderSize;
  final Color? backgroundColor, borderColor;
  final EdgeInsets? margin;
  final EdgeInsets padding;

  const CirclerButtonView({
    required this.child,
    required this.onPressed,
    this.size = 50,
    this.backgroundColor,
    this.borderColor,
    this.borderSize = 1,
    this.margin,
    this.padding = const EdgeInsets.all(5),
    super.key,
  });

  static CirclerButtonView text(
    String text, {
    required Function()? onPressed,
    TextStyle? textStyle,
    double size = 50,
    double borderSize = 1,
    Color? backgroundColor,
    Color borderColor = Colors.transparent,
    EdgeInsets? margin,
    EdgeInsets padding = const EdgeInsets.all(8),
  }) =>
      CirclerButtonView(
        onPressed: onPressed,
        size: size,
        borderSize: borderSize,
        backgroundColor: backgroundColor ?? UIThemeColors.iconBg,
        borderColor: borderColor,
        margin: margin,
        padding: padding,
        child: Text(text, style: textStyle),
      );

  static CirclerButtonView icon(
    IconData icon, {
    required Function()? onPressed,
    Color? iconColor,
    double size = 50,
    double borderSize = 1,
    double? iconSize,
    Color? backgroundColor,
    Color borderColor = Colors.transparent,
    EdgeInsets? margin,
  }) =>
      CirclerButtonView(
        onPressed: onPressed,
        size: size,
        borderSize: borderSize,
        backgroundColor: backgroundColor ?? UIThemeColors.iconBg,
        borderColor: borderColor,
        margin: margin,
        padding: EdgeInsets.zero,
        child: Icon(
          icon,
          color: iconColor ?? UIThemeColors.iconFg,
          size: iconSize ?? size * 0.6,
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        width: size,
        height: size,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              CircleBorder(
                side: BorderSide(
                  color: borderColor ?? UIColors.primary,
                  width: borderSize,
                ),
              ),
            ),
            padding: WidgetStateProperty.all(padding),
            backgroundColor: WidgetStateProperty.all(backgroundColor),
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (states) => states.contains(WidgetState.pressed)
                  ? Theme.of(context).splashColor
                  : null,
            ),
          ),
          child: child,
        ),
      );
}
