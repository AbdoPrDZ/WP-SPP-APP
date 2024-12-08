import 'package:get/get.dart';

import '../consts/consts.dart';
import 'views.dart';

abstract class MGetPage<T extends GetxController> extends MGetWidget<T> {
  const MGetPage({super.key});

  Widget? buildDrawer() => null;
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;
  Widget? buildFloatingActionButton(BuildContext context) => null;
  Widget? bottomNavigationBar(BuildContext context) => null;
  Widget? buildBottomSheet(BuildContext context) => null;

  GlobalKey<ScaffoldState>? get scaffoldKey => null;

  CustomPainter? get backgroundPainter => null;

  bool get isScrollable => false;

  void snack(Widget child) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: child,
        backgroundColor: UIThemeColors.cardBg,
        showCloseIcon: true,
        closeIconColor: UIColors.danger,
      ),
    );
  }

  void snackText(String text) => snack(
        Text(text, style: TextStyles.subMidTitle),
      );

  bool get canPop => true;

  @protected
  Widget buildBody(BuildContext context);

  @override
  Widget buildWidget(BuildContext context) => PopScope(
        canPop: canPop,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: backgroundPainter != null
              ? Colors.transparent
              : UIThemeColors.pageBackground,
          drawer: buildDrawer(),
          bottomNavigationBar: bottomNavigationBar(context),
          appBar: buildAppBar(context),
          body: backgroundPainter != null
              ? CustomPaint(
                  painter: backgroundPainter,
                  child: SizedBox.expand(
                    child: isScrollable
                        ? SingleChildScrollView(
                            child: buildBody(context),
                          )
                        : buildBody(context),
                  ),
                )
              : SizedBox.expand(
                  child: isScrollable
                      ? SingleChildScrollView(
                          child: buildBody(context),
                        )
                      : buildBody(context),
                ),
          floatingActionButton: buildFloatingActionButton(context),
          bottomSheet: buildBottomSheet(context),
          extendBody: true,
        ),
      );
}

enum PageStatus {
  loading,
  done;

  bool get isLoading => this == loading;
  bool get isDone => this == done;
}
