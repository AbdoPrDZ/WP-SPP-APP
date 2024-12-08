import 'package:country_flags/country_flags.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../src.dart';

class PhoneInputView extends TextEditView {
  PhoneInputView({
    required String selectedCountry,
    required Function(String country) onCountryChange,
    super.key,
    super.fieldKey,
    required super.controller,
    super.onChanged,
    super.onSubmitted,
    super.onSaved,
    super.onEditingComplete,
    super.inputFormatter,
    super.autofocus,
    super.textCapitalization,
    super.focusNode,
    super.cursorColor,
    super.debounceDuration,
    super.validator,
    super.hint,
    super.label,
    super.labelActions,
    super.margin,
    super.width,
    super.height,
    super.maxWidth,
    super.maxHeight,
    super.backgroundColor,
    super.suffixIcon,
    super.onSuffixPress,
    super.buildSuffix,
    super.dispose,
  }) : super(
          keyboardType: TextInputType.phone,
          buildPrefix: (context) => InkWell(
            onTap: () async {
              final country = await SelectCountryDialog(
                selectedCountry: selectedCountry,
              ).show();
              if (country != null) onCountryChange(country);
            },
            child: Flex(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(10),
                SizedBox(
                  width: 28,
                  height: 19,
                  child: CountryFlag.fromCountryCode(
                    selectedCountry,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 2),
                  child: Text(
                    '${Countries.all[selectedCountry]?['call_code']}',
                    style: TextStyles.midTitle,
                  ),
                ),
              ],
            ),
          ),
        );
}

class SelectCountryDialog extends StatefulWidget {
  final String selectedCountry;
  const SelectCountryDialog({super.key, this.selectedCountry = 'DZ'});

  Future show() => Get.dialog(this);

  @override
  State<SelectCountryDialog> createState() => _SelectCountryDialogState();
}

class _SelectCountryDialogState extends State<SelectCountryDialog> {
  @override
  Widget build(BuildContext context) => DialogsView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "phone_input.select_country.title".tr,
              textAlign: TextAlign.start,
              style: TextStyles.titleBold,
            ),
            const Gap(15),
            Text(
              'phone_input.select_country.selected_country'.trParams({
                'country': Countries.all[widget.selectedCountry]?['name'] ?? '',
              }),
              style: TextStyles.subMidTitle,
            ),
            const Divider(
              color: UIColors.border,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.68,
              child: ListView.builder(
                itemCount: Countries.all.length,
                itemBuilder: (context, index) {
                  final country = Countries.all.values.elementAt(index);

                  return ButtonView(
                    backgroundColor: (widget.selectedCountry == country['code']
                            ? UIColors.primary
                            : UIColors.border)
                        .withOpacity(0.7),
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    onPressed: () => Get.back(result: country['code']),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        CountryFlag.fromCountryCode(
                          country['code']!,
                          width: 30,
                          height: 20,
                        ),
                        const Gap(5),
                        Flexible(
                          child: Text(
                            '${country['call_code']} ${country['name']}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(color: UIColors.border),
            ButtonView.text(
              onPressed: Get.back,
              text: 'phone_input.select_country.cancel_button'.tr,
              backgroundColor: UIColors.danger,
            )
          ],
        ),
      );
}
