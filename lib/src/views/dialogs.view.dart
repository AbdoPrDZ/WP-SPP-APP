import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../consts/consts.dart';
import '../utils/utils.dart';
import 'views.dart';

class DialogsView extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin, padding;
  final double? width, height;
  final bool isDismissible;
  final Color? backgroundColor;
  final double borderRadius;

  const DialogsView({
    super.key,
    required this.child,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(16),
    this.width,
    this.height,
    this.isDismissible = true,
    this.backgroundColor,
    this.borderRadius = 10,
  });

  factory DialogsView.message(
    String title,
    String message, {
    List<DialogAction>? actions,
    bool isDismissible = true,
  }) =>
      DialogsView(
        isDismissible: isDismissible,
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyles.titleBold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 16,
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyles.subMidTitle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 3, right: 3),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (DialogAction action in (actions ?? DialogAction.ok))
                    ButtonView.text(
                      onPressed: action.onPressed,
                      text: action.text,
                      backgroundColor: action.actionColor,
                      height: null,
                    )
                ],
              ),
            ),
          ],
        ),
      );

  factory DialogsView.loading({
    Key? key,
    String? title,
    String? message,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? width,
    double? height,
  }) =>
      DialogsView(
        isDismissible: false,
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          textDirection: TextDirection.ltr,
          children: [
            if (title != null)
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyles.titleBold,
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 16),
              child: Flex(
                direction: Axis.horizontal,
                textDirection: TextDirection.ltr,
                children: [
                  const CircularProgressIndicator(color: UIColors.primary),
                  const Gap(10),
                  Text(
                    message ?? 'dialogs.loading.message'.tr,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: TextStyles.subMidTitle,
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  factory DialogsView.form({
    Key? key,
    required String title,
    GlobalKey<FormState>? formKey,
    required List<DialogFormField> fields,
    required List<DialogAction> actions,
    bool isDismissible = true,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? width,
    double? height,
  }) {
    if (fields.isEmpty) throw ErrorHint('Fields list must be not empty');

    return DialogsView(
      child: Form(
        key: formKey,
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyles.titleBold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 16,
              ),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  for (DialogFormField field in fields) field.buildField(null),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 3, right: 3),
              child: Flex(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                direction: Axis.horizontal,
                children: [
                  for (DialogAction action in actions)
                    ButtonView.text(
                      height: null,
                      text: action.text,
                      onPressed: action.onPressed,
                      backgroundColor: action.actionColor,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  factory DialogsView.preview(
    Widget child, {
    String? title,
    bool backOnTap = true,
  }) =>
      DialogsView(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: Get.back,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 2,
              sigmaY: 2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null) ...[
                  Text(
                    title,
                    style: TextStyles.titleBold,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(10),
                ],
                child,
              ],
            ),
          ),
        ),
      );

  factory DialogsView.previewImage(
    ImageProvider image, {
    String? title,
    bool backOnTap = true,
  }) =>
      DialogsView.preview(
        Image(
          image: image,
          height: 300,
          fit: BoxFit.contain,
        ),
        title: title,
        backOnTap: backOnTap,
      );

  factory DialogsView.previewNetworkImage(
    String url, {
    String? title,
    bool backOnTap = true,
  }) =>
      DialogsView.preview(
        MNetworkImage(
          url: url,
          build: (image) => Image.file(
            image,
            height: 300,
            fit: BoxFit.contain,
          ),
          onLoadingWidget: const SizedBox.square(
            dimension: 300,
            child: CircularProgressIndicator(
              color: UIColors.primary,
            ),
          ),
          onFailedWidget: const Icon(
            Icons.broken_image_outlined,
            color: UIColors.border,
            size: 80,
          ),
        ),
        title: title,
        backOnTap: backOnTap,
      );

  Future show() => Get.dialog(this, barrierDismissible: isDismissible);

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: isDismissible,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            margin: margin,
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: backgroundColor ?? UIThemeColors.cardBg,
            ),
            child: child,
          ),
        ),
      );
}

class DialogAction {
  final String text;
  final VoidCallback onPressed;
  final Color? actionColor;

  DialogAction({
    required this.text,
    required this.onPressed,
    this.actionColor,
  });

  /// ok - Ok Actions
  static List<DialogAction> ok = [
    DialogAction(
      text: 'dialogs.action.ok'.tr,
      onPressed: () => Get.back(),
    ),
  ];

  /// yesNo - Yes and No Actions (@Yes -> true, @No -> false)
  static List<DialogAction> yesNo = [
    DialogAction(
      text: 'dialogs.action.yes'.tr,
      onPressed: () => Get.back(result: true),
    ),
    DialogAction(
      text: 'dialogs.action.no'.tr,
      actionColor: UIColors.danger,
      onPressed: () => Get.back(result: false),
    ),
  ];

  /// rYesNo - Red Yes and No Actions (@Yes -> true, @No -> false)
  static List<DialogAction> rYesNo = [
    DialogAction(
      text: 'dialogs.action.yes'.tr,
      actionColor: UIColors.danger,
      onPressed: () => Get.back(result: true),
    ),
    DialogAction(
      text: 'dialogs.action.no'.tr,
      onPressed: () => Get.back(result: false),
    ),
  ];

  /// yesCancel - Yes and Cancel Actions (@Yes -> true, @Cancel -> false)
  static List<DialogAction> yesCancel = [
    DialogAction(
      text: 'dialogs.action.yes'.tr,
      onPressed: () => Get.back(result: true),
    ),
    DialogAction(
      text: 'dialogs.action.cancel'.tr,
      actionColor: UIColors.danger,
      onPressed: () => Get.back(result: false),
    ),
  ];

  /// rYesCancel - Red Yes and Cancel Actions (@Yes -> true, @Cancel -> false)
  static List<DialogAction> rYesCancel = [
    DialogAction(
      text: 'dialogs.action.yes'.tr,
      actionColor: UIColors.danger,
      onPressed: () => Get.back(result: true),
    ),
    DialogAction(
      text: 'dialogs.action.cancel'.tr,
      onPressed: () => Get.back(result: false),
    ),
  ];
}

class DialogFormField {
  final String name;
  final Widget Function(BuildContext? context) buildField;

  const DialogFormField(
    this.name,
    this.buildField,
  );

  factory DialogFormField.textEdit({
    required String name,
    required TextEditingController controller,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    Function(String?)? onSaved,
    List<TextInputFormatter> inputFormatter = const [],
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    bool autofocus = false,
    TextInputType keyboardType = TextInputType.text,
    FocusNode? focusNode,
    Color? cursorColor,
    Duration debounceDuration = const Duration(milliseconds: 400),
    Validator? validator,
    String? hint,
    String? label,
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    double? width,
    double? height,
    double? maxWidth,
    double? maxHeight,
    Color? backgroundColor,
    IconData? prefixIcon,
    IconData? suffixIcon,
    bool multiLine = false,
  }) =>
      DialogFormField(
        name,
        (context) => TextEditView(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onSaved: onSaved,
          inputFormatter: inputFormatter,
          textCapitalization: textCapitalization,
          autofocus: autofocus,
          keyboardType: keyboardType,
          cursorColor: cursorColor,
          debounceDuration: debounceDuration,
          validator: validator,
          hint: hint,
          label: label,
          margin: margin,
          width: width,
          height: height,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          backgroundColor: backgroundColor,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          multiLine: multiLine,
          focusNode: focusNode,
        ),
      );

  static DialogFormField dropDown<T>({
    required String name,
    T? value,
    String? hint,
    String? label,
    required List<DropdownMenuItem<T>> items,
    required Function(T? value) onChanged,
    EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 15),
    double? width,
    double height = 48,
    String? Function(T?)? validation,
  }) =>
      DialogFormField(
        name,
        (context) => DropDownView(
          value: value,
          hint: hint,
          label: label,
          items: items,
          onChanged: onChanged,
          margin: margin,
          padding: padding,
          width: width,
          height: height,
          validation: validation,
        ),
      );
}
