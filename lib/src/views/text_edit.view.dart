import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../consts/consts.dart';
import '../utils/utils.dart';

class TextEditView extends StatefulWidget {
  final Key? fieldKey;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function(String?)? onSaved;
  final Function()? onEditingComplete;
  final List<TextInputFormatter> inputFormatter;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final Color? cursorColor;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Duration debounceDuration;
  final Validator? validator;
  final String? hint, label;
  final List<Widget Function(BuildContext context)>? labelActions;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double? width, height, maxWidth, maxHeight;
  final Color? backgroundColor;
  final IconData? prefixIcon, suffixIcon;
  final Function()? onPrefixPress, onSuffixPress;
  final Widget Function(BuildContext context)? buildPrefix, buildSuffix;
  final bool multiLine;
  final DateTime? firstDate, lastDate;
  final String dateFormat;
  final bool dispose;
  final bool enabled;

  const TextEditView({
    super.key,
    this.fieldKey,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onSaved,
    this.onEditingComplete,
    this.inputFormatter = const [],
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.sentences,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.cursorColor,
    this.borderRadius,
    this.borderColor,
    this.debounceDuration = const Duration(milliseconds: 400),
    this.validator,
    this.hint,
    this.label,
    this.labelActions,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.width,
    this.height,
    this.maxWidth,
    this.maxHeight,
    this.backgroundColor,
    this.prefixIcon,
    this.suffixIcon,
    this.onPrefixPress,
    this.onSuffixPress,
    this.buildPrefix,
    this.buildSuffix,
    this.multiLine = false,
    this.firstDate,
    this.lastDate,
    this.dateFormat = 'yyyy-MM-dd HH:mm:ss',
    this.dispose = true,
    this.enabled = true,
  })  : assert(
          !(keyboardType == TextInputType.datetime &&
              (firstDate == null || lastDate == null)),
          'You have to pass firstDate and lastDate when keyboardType is datetime',
        ),
        assert(
          !(buildPrefix != null && prefixIcon != null && onPrefixPress != null),
          "You can't use prefix build function and prefix icon and on prefix press function in the same time",
        ),
        assert(
          !(buildSuffix != null && suffixIcon != null && onSuffixPress != null),
          "You can't use suffix build function and suffix icon and on suffix press function in the same time",
        );

  @override
  State<TextEditView> createState() => _TextEditViewState();
}

class _TextEditViewState extends State<TextEditView> {
  final LayerLink _layerLink = LayerLink();
  late FocusNode _focusNode;
  late TextInputType _keyboardType;
  bool _hideText = false;
  bool _isFocused = false;

  void onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void onTextChange() {
    _currentState?.didChange(widget.controller.text);
  }

  @override
  void initState() {
    super.initState();
    _keyboardType = widget.keyboardType;
    _hideText = _keyboardType == TextInputType.visiblePassword;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(onFocusChange);
    widget.controller.addListener(onTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(onFocusChange);
    widget.controller.removeListener(onTextChange);

    if (widget.dispose) {
      _focusNode.dispose();
      widget.controller.dispose();
    }

    super.dispose();
  }

  void pickDate() async {
    DateTime initialDateTIme =
        MDateTime.fromString(widget.controller.text) ?? DateTime.now();
    DateTime? date = widget.dateFormat.contains('yyyy-MM')
        ? await Get.dialog(DatePickerDialog(
            initialDate: initialDateTIme,
            firstDate: widget.firstDate!,
            lastDate: widget.lastDate!,
          ))
        : null;
    TimeOfDay? time = widget.dateFormat.contains('HH:mm')
        ? await Get.dialog(TimePickerDialog(
            initialTime: TimeOfDay.fromDateTime(initialDateTIme),
          ))
        : null;

    DateTime dateTime = MDateTime.fromDateAndTImeOfDay(
      date ?? initialDateTIme,
      time ?? TimeOfDay.fromDateTime(initialDateTIme),
    );

    widget.controller.text = dateTime.format(widget.dateFormat);
  }

  FormFieldState<String>? _currentState;

  TextButton _buildIconButton(
    BuildContext context, {
    required IconData icon,
    Color? color,
    Function()? onPressed,
  }) =>
      TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.resolveWith(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Icon(
          icon,
          color: color,
          size: 25,
        ),
      );

  @override
  Widget build(BuildContext context) {
    Widget parent({required Widget child}) =>
        widget.maxHeight != null ? Flexible(child: child) : child;

    if (widget.multiLine) _keyboardType = TextInputType.multiline;
    return FormField<String>(
      key: widget.fieldKey,
      validator: widget.validator != null
          ? (value) => widget.validator!.validate(value!).firstOrNull
          : null,
      initialValue: widget.controller.text,
      onSaved: widget.onSaved,
      builder: (state) {
        _currentState = state;
        return Container(
          margin: widget.margin,
          width: widget.width,
          height: widget.height,
          constraints: BoxConstraints(
            maxWidth: widget.maxWidth ?? double.infinity,
            maxHeight: widget.maxHeight ?? double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.label != null) ...[
                if (widget.labelActions != null)
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        widget.label!,
                        style: TextStyles.subMidTitleBold,
                      ),
                      for (final action in widget.labelActions!)
                        action(context),
                    ],
                  )
                else
                  Text(
                    widget.label!,
                    style: TextStyles.subMidTitle,
                  ),
                const Gap(5),
              ],
              parent(
                child: CompositedTransformTarget(
                  link: _layerLink,
                  child: TextField(
                    enabled: widget.enabled,
                    onEditingComplete: widget.onEditingComplete,
                    focusNode: _focusNode,
                    obscureText: _hideText,
                    controller: widget.controller,
                    keyboardType: _keyboardType,
                    maxLines: widget.multiLine ? null : 1,
                    autofocus: widget.autofocus,
                    inputFormatters: widget.inputFormatter,
                    textCapitalization: widget.textCapitalization,
                    cursorColor: widget.cursorColor,
                    onChanged: widget.onChanged,
                    style: TextStyles.subMidTitle,
                    onSubmitted: (value) {
                      widget.onSubmitted?.call(value);
                      _focusNode.unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: TextStyles.subMidTitle2,
                      fillColor: _isFocused
                          ? widget.backgroundColor ?? UIThemeColors.fieldBg
                          : Colors.transparent,
                      filled: true,
                      prefixIcon: widget.buildPrefix?.call(context) ??
                          (widget.prefixIcon != null
                              ? (widget.onPrefixPress != null
                                  ? _buildIconButton(
                                      context,
                                      onPressed: widget.onPrefixPress,
                                      icon: widget.prefixIcon!,
                                      color: _isFocused
                                          ? UIThemeColors.fieldFocus
                                          : UIThemeColors.field,
                                    )
                                  : Icon(
                                      widget.prefixIcon,
                                      color: _isFocused
                                          ? UIThemeColors.fieldFocus
                                          : UIThemeColors.field,
                                    ))
                              : null),
                      suffixIcon: widget.buildSuffix?.call(context) ??
                          (widget.suffixIcon != null
                              ? (widget.onSuffixPress != null
                                  ? _buildIconButton(
                                      context,
                                      onPressed: widget.onSuffixPress,
                                      icon: widget.suffixIcon!,
                                      color: _isFocused
                                          ? UIThemeColors.fieldFocus
                                          : UIThemeColors.field,
                                    )
                                  : Icon(
                                      widget.suffixIcon,
                                      color: _isFocused
                                          ? UIThemeColors.fieldFocus
                                          : UIThemeColors.field,
                                    ))
                              : _keyboardType == TextInputType.visiblePassword
                                  ? _buildIconButton(
                                      context,
                                      icon: _hideText
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      onPressed: () => setState(() {
                                        _hideText = !_hideText;
                                      }),
                                      color: _hideText
                                          ? UIThemeColors.field
                                          : UIThemeColors.fieldFocus,
                                    )
                                  : _keyboardType == TextInputType.datetime
                                      ? _buildIconButton(
                                          context,
                                          onPressed: pickDate,
                                          icon: Icons.calendar_month_outlined,
                                          color: UIThemeColors.fieldFocus,
                                        )
                                      : null),
                      contentPadding: widget.padding,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.8,
                          color: state.hasError
                              ? UIColors.fieldDanger
                              : widget.borderColor ?? const Color(0x33FFFFFF),
                        ),
                        borderRadius:
                            widget.borderRadius ?? BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.8,
                          color: state.hasError
                              ? UIColors.fieldDanger
                              : widget.borderColor ?? UIThemeColors.fieldFocus,
                        ),
                        borderRadius:
                            widget.borderRadius ?? BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.8,
                          color: state.hasError
                              ? UIColors.fieldDanger
                              : widget.borderColor ?? UIThemeColors.field,
                        ),
                        borderRadius:
                            widget.borderRadius ?? BorderRadius.circular(8),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: UIThemeColors.fieldBg, width: 0.8),
                        borderRadius:
                            widget.borderRadius ?? BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
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
                  style: TextStyles.fieldDanger,
                )
              ]
            ],
          ),
        );
      },
    );
  }
}
