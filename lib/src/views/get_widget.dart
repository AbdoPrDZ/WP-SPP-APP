import 'package:get/get.dart';

import 'views.dart';

abstract class MGetWidget<T extends GetxController> extends StatefulWidget {
  const MGetWidget({super.key});

  @protected
  T get initController;

  T get controller {
    try {
      return Get.find<T>();
    } catch (e) {
      return Get.put(initController);
    }
  }

  @protected
  Widget buildWidget(BuildContext context);

  Widget _build(BuildContext context) => GetBuilder<T>(
        init: Get.put(initController),
        builder: (controller) => buildWidget(context),
      );

  void initState() {}

  void dispose() {}

  @override
  State<MGetWidget> createState() => _MGetWidgetState();
}

class _MGetWidgetState extends State<MGetWidget> {
  @override
  initState() {
    widget.initState();
    super.initState();
  }

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget._build(context);
}
