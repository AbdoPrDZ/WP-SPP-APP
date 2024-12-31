import 'dart:io';

import '../../pages/pages.dart';
import '../src.dart';

class UserAvatarView extends StatelessWidget {
  final Widget? child;
  final DecorationImage? decorationImage;
  final double size;
  final Color backgroundColor;
  final Color borderColor;
  final double? borderSize;
  final Widget? topRightFloatingWidget;
  final Widget? bottomRightFloatingWidget;
  final EdgeInsets margin;
  final Function()? onPressed;

  const UserAvatarView({
    this.child,
    this.decorationImage,
    this.topRightFloatingWidget,
    this.bottomRightFloatingWidget,
    this.size = 65,
    this.backgroundColor = Colors.white,
    this.borderColor = UIColors.border,
    this.borderSize,
    this.margin = const EdgeInsets.symmetric(vertical: 5),
    this.onPressed,
    super.key,
  });

  UserAvatarView.image(
    ImageProvider image, {
    Key? key,
    BoxFit fit = BoxFit.cover,
    double size = 56,
    double? borderSize = 1,
    EdgeInsets margin = EdgeInsets.zero,
    Color backgroundColor = Colors.white,
    Color borderColor = UIColors.border,
    Widget? topRightFloatingWidget,
    Widget? bottomRightFloatingWidget,
    Function()? onPressed,
  }) : this(
          key: key,
          decorationImage: DecorationImage(
            image: image,
            fit: fit,
          ),
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderSize: borderSize,
          size: size,
          margin: margin,
          topRightFloatingWidget: topRightFloatingWidget,
          bottomRightFloatingWidget: bottomRightFloatingWidget,
          onPressed: onPressed,
        );

  static MNetworkImage networkImage(
    String url, {
    Key? key,
    BoxFit fit = BoxFit.cover,
    double size = 56,
    double? borderSize = 1,
    EdgeInsets margin = EdgeInsets.zero,
    Color backgroundColor = Colors.white,
    Color borderColor = UIColors.border,
    Widget? topRightFloatingWidget,
    Widget? bottomRightFloatingWidget,
    Function()? onPressed,
  }) =>
      MNetworkImage(
        url: url,
        build: (image) => UserAvatarView(
          key: key,
          decorationImage: DecorationImage(
            image: FileImage(image),
            fit: fit,
          ),
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderSize: borderSize,
          size: size,
          margin: margin,
          topRightFloatingWidget: topRightFloatingWidget,
          bottomRightFloatingWidget: bottomRightFloatingWidget,
          onPressed: onPressed,
        ),
        onLoadingWidget: UserAvatarView(
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderSize: borderSize,
          size: size,
          margin: margin,
          topRightFloatingWidget: topRightFloatingWidget,
          bottomRightFloatingWidget: bottomRightFloatingWidget,
          onPressed: onPressed,
          child: const CircularProgressIndicator(color: UIColors.primary),
        ),
        onFailedWidget: UserAvatarView(
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderSize: borderSize,
          size: size,
          margin: margin,
          topRightFloatingWidget: topRightFloatingWidget,
          bottomRightFloatingWidget: bottomRightFloatingWidget,
          onPressed: onPressed,
          child: const Icon(
            Icons.broken_image_outlined,
            color: UIColors.border,
          ),
        ),
      );

  static Widget networkImageOrAvatarLetter(
    String? url,
    String avatarLetters, {
    Key? key,
    BoxFit fit = BoxFit.cover,
    double size = 56,
    double? borderSize = 1,
    EdgeInsets margin = EdgeInsets.zero,
    Color backgroundColor = Colors.white,
    Color borderColor = UIColors.border,
    Widget? topRightFloatingWidget,
    Widget? bottomRightFloatingWidget,
    Function()? onPressed,
  }) =>
      url == null
          ? UserAvatarView.label(
              avatarLetters,
              key: key,
              size: size,
              borderSize: borderSize,
              margin: margin,
              backgroundColor: backgroundColor,
              borderColor: borderColor,
              topRightFloatingWidget: topRightFloatingWidget,
              bottomRightFloatingWidget: bottomRightFloatingWidget,
              onPressed: onPressed,
            )
          : networkImage(
              url,
              key: key,
              size: size,
              borderSize: borderSize,
              margin: margin,
              backgroundColor: backgroundColor,
              borderColor: borderColor,
              topRightFloatingWidget: topRightFloatingWidget,
              bottomRightFloatingWidget: bottomRightFloatingWidget,
              onPressed: onPressed,
            );

  static Widget imagePick(
    String? url,
    String avatarLetters,
    File? newImage, {
    Key? key,
    BoxFit fit = BoxFit.cover,
    double size = 120,
    double floatingIconSize = 28,
    double? borderSize,
    EdgeInsets margin = EdgeInsets.zero,
    Color backgroundColor = Colors.white,
    Color borderColor = UIColors.border,
    Widget? topRightFloatingWidget,
    required Function(File? image) onPick,
  }) {
    void onPressed() => RouteManager.to(
          PagesInfo.pickAndCropImage,
          arguments: PickAndCropImagePageData(onDone: onPick),
        );

    final bottomRightFloatingWidget = Container(
      width: floatingIconSize,
      height: floatingIconSize,
      decoration: BoxDecoration(
        color: UIThemeColors.iconBg.withOpacity(0.8),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(
        Icons.image_outlined,
        color: UIThemeColors.iconFg,
        size: 20,
      ),
    );

    return newImage != null
        ? UserAvatarView.image(
            FileImage(newImage),
            borderColor: borderColor,
            borderSize: borderSize,
            size: size,
            margin: margin,
            topRightFloatingWidget: topRightFloatingWidget,
            bottomRightFloatingWidget: bottomRightFloatingWidget,
            onPressed: onPressed,
          )
        : url == null
            ? UserAvatarView.label(
                avatarLetters,
                borderColor: borderColor,
                borderSize: borderSize,
                size: size,
                textSize: 38,
                margin: margin,
                topRightFloatingWidget: topRightFloatingWidget,
                bottomRightFloatingWidget: bottomRightFloatingWidget,
                onPressed: onPressed,
              )
            : MNetworkImage(
                url: url,
                build: (image) => UserAvatarView(
                  key: key,
                  decorationImage: DecorationImage(
                    image: FileImage(image),
                    fit: fit,
                  ),
                  backgroundColor: backgroundColor,
                  borderColor: borderColor,
                  borderSize: borderSize,
                  size: size,
                  margin: margin,
                  topRightFloatingWidget: topRightFloatingWidget,
                  bottomRightFloatingWidget: bottomRightFloatingWidget,
                  onPressed: onPressed,
                ),
                onLoadingWidget: UserAvatarView(
                  backgroundColor: backgroundColor,
                  borderColor: borderColor,
                  borderSize: borderSize,
                  size: size,
                  margin: margin,
                  topRightFloatingWidget: topRightFloatingWidget,
                  bottomRightFloatingWidget: bottomRightFloatingWidget,
                  onPressed: onPressed,
                  child: const CircularProgressIndicator(
                    color: UIColors.primary,
                  ),
                ),
                onFailedWidget: UserAvatarView(
                  backgroundColor: backgroundColor,
                  borderColor: borderColor,
                  borderSize: borderSize,
                  size: size,
                  margin: margin,
                  topRightFloatingWidget: topRightFloatingWidget,
                  bottomRightFloatingWidget: bottomRightFloatingWidget,
                  onPressed: onPressed,
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: UIColors.border,
                  ),
                ),
              );
  }

  UserAvatarView.label(
    String label, {
    Key? key,
    double size = 56,
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 5),
    Color? backgroundColor,
    Color borderColor = UIColors.border,
    Color? textColor,
    double textSize = 24,
    double? borderSize,
    Widget? topRightFloatingWidget,
    Widget? bottomRightFloatingWidget,
    Function()? onPressed,
  }) : this(
          key: key,
          backgroundColor: backgroundColor ?? UIThemeColors.cardBg,
          size: size,
          margin: margin,
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyles.titleBold.copyWith(
              color: textColor ?? UIThemeColors.iconFg1,
              fontSize: textSize,
            ),
          ),
          borderSize: borderSize,
          borderColor: borderColor,
          topRightFloatingWidget: topRightFloatingWidget,
          bottomRightFloatingWidget: bottomRightFloatingWidget,
        );

  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        child: SizedBox(
          width: size,
          child: InkWell(
            onTap: onPressed,
            child: Stack(
              children: [
                Container(
                  width: size,
                  height: size,
                  constraints: BoxConstraints(
                    minHeight: size,
                    minWidth: size,
                    maxHeight: size,
                    maxWidth: size,
                  ),
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      border: borderSize != null
                          ? Border.all(
                              color: borderColor,
                              width: borderSize!,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(size),
                      image: decorationImage),
                  alignment: Alignment.center,
                  child: child,
                ),
                if (topRightFloatingWidget != null)
                  Positioned(
                    right: 0,
                    child: topRightFloatingWidget!,
                  ),
                if (bottomRightFloatingWidget != null)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: bottomRightFloatingWidget!,
                  ),
              ],
            ),
          ),
        ),
      );
}
