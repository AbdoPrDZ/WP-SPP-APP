import 'package:get/get.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../services/main.service.dart';
import '../../../../../src/src.dart';

class PrivacyTab extends StatelessWidget {
  const PrivacyTab({super.key});

  Future<String?> loadText() async {
    final response = await AppAPI.apiClient.get(AppAPI.privacyPolicy);

    return (response.success && response.value is String
        ? response.value
        : null);
  }

  MarkdownConfig get config => Get.find<MainService>().themeMode.isDark
      ? MarkdownConfig.darkConfig
      : MarkdownConfig.defaultConfig;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: UIThemeColors.pageBackground,
        body: SizedBox.expand(
          child: FutureBuilder<String?>(
            future: loadText(),
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: UIColors.primary,
                        ),
                      )
                    : snapshot.data == null
                        ? Center(
                            child: Text(
                              'privacy_policy.error'.tr,
                              style: TextStyles.midTitleDanger,
                            ),
                          )
                        : MarkdownWidget(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 35,
                              vertical: 15,
                            ),
                            data: snapshot.data ?? '',
                            config: config.copy(
                              configs: [
                                LinkConfig(
                                  onTap: (href) => launchUrl(
                                    Uri.parse(href),
                                  ),
                                ),
                                H1Config(style: TextStyles.bigTitleBold),
                                H2Config(style: TextStyles.titleBold),
                                H3Config(style: TextStyles.midTitleBold),
                                PConfig(textStyle: TextStyles.midTitle),
                                ListConfig(
                                  marker: (isOrdered, depth, index) => isOrdered
                                      ? Text(
                                          '$index-',
                                          style: TextStyles.midTitle,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                          ),
                                          child: Icon(
                                            Icons.circle_outlined,
                                            color: UIThemeColors.text2,
                                            size: 10,
                                          ),
                                        ),
                                )
                              ],
                            ),
                          ),
          ),
        ),
      );
}
