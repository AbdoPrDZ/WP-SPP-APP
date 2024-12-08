import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../src/src.dart';

part 'page.data.dart';

class SuccessPage extends StatefulWidget {
  static String name = '/success';

  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  SuccessPageData pageData = Get.arguments;

  @override
  void initState() {
    super.initState();

    pageData.onInit?.call();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: UIThemeColors.pageBackground,
        body: SizedBox.expand(
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                pageData.image,
                width: 176,
                height: 176,
              ),
              const Gap(40),
              Text(
                pageData.title,
                style: TextStyles.titlePrimaryBold,
              ),
              if (pageData.description != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15)
                      .copyWith(top: 10),
                  child: Text(
                    pageData.description!,
                    style: TextStyles.midTitle,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (pageData.showLoading) ...[
                const Spacer(),
                const CircularProgressIndicator(color: UIColors.primary),
                const Spacer(),
              ],
            ],
          ),
        ),
      );
}
