import 'dart:math';

import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../src.dart';

class DropDownView<T> extends StatefulWidget {
  final T? value;
  final String? hint, label;
  final List<DropdownMenuItem<T>> items;
  final Function(T? value) onChanged;
  final EdgeInsets margin, padding;
  final double? width;
  final double height;
  final Color? fieldBg;
  final Border? border;
  final TextStyle? textStyle;
  final String? Function(T?)? validation;
  final bool displayArrow;
  final FocusNode? focusNode;

  const DropDownView({
    super.key,
    this.value,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.width = double.infinity,
    this.height = 48,
    this.fieldBg,
    this.border,
    this.textStyle,
    required this.items,
    required this.onChanged,
    this.hint,
    this.label,
    this.validation,
    this.displayArrow = true,
    this.focusNode,
  });

  @override
  State<DropDownView<T>> createState() => _DropDownViewState<T>();
}

class _DropDownViewState<T> extends State<DropDownView<T>> {
  FocusNode? _focusNode;

  bool isFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode!.addListener(onFocusChange);
  }

  void onFocusChange() => setState(() => isFocus = _focusNode!.hasFocus);

  @override
  void dispose() {
    _focusNode?.removeListener(onFocusChange);
    _focusNode?.dispose();
    super.dispose();
  }

  Language get appLanguage => Get.find<MainService>().appLanguage;

  Widget _buildChild(BuildContext context, FormFieldState<T> state) =>
      Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: isFocus
              ? widget.fieldBg ?? UIThemeColors.fieldBg
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: widget.border ??
              Border.all(
                color: state.hasError ? UIColors.danger : UIThemeColors.field,
                width: 0.8,
              ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DropdownButton<T>(
                value: widget.value,
                hint: widget.hint != null
                    ? Text(
                        widget.hint!,
                        style: TextStyles.subMidTitle2,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                style: widget.textStyle ?? TextStyles.subMidTitle2,
                items: widget.items,
                onChanged: (value) {
                  state.didChange(value);
                  widget.onChanged(value);
                },
                focusNode: _focusNode,
                dropdownColor: UIThemeColors.cardBg,
                borderRadius: BorderRadius.circular(8),
                underline: Container(),
                icon: Container(),
                padding: widget.padding,
              ),
            ),
            if (widget.displayArrow)
              Positioned(
                right: appLanguage.isAr ? null : widget.padding.right,
                left: appLanguage.isAr ? widget.padding.right : null,
                top: max(widget.height / 2 - 10, 0),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: UIThemeColors.text3,
                ),
              )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => FormField<T>(
        initialValue: widget.value,
        validator: widget.validation,
        builder: (state) => Container(
          width: widget.width,
          margin: widget.margin,
          child: widget.label == null && !state.hasError
              ? _buildChild(context, state)
              : Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.label != null) ...[
                      Text(
                        widget.label!,
                        style: TextStyles.subMidTitle,
                      ),
                      const Gap(5),
                    ],
                    _buildChild(context, state),
                    if (state.hasError) ...[
                      const Gap(4),
                      Text.rich(
                        TextSpan(
                          children: [
                            const WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: Icon(
                                  Icons.error_outline,
                                  color: UIColors.fieldDanger,
                                  size: 15,
                                ),
                              ),
                            ),
                            TextSpan(text: state.errorText!),
                          ],
                        ),
                        style: TextStyles.smallTitleFieldDanger,
                      )
                    ]
                  ],
                ),
        ),
      );
}
