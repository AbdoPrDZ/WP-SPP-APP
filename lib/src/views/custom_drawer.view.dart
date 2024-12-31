import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../consts/consts.dart';
import '../utils/utils.dart';
import 'button.view.dart';

class CustomDrawerView extends StatefulWidget {
  final List<DrawerItem> tabsItems;
  final PageController pageController;
  final Widget Function(BuildContext context)? buildHeader;
  final Widget Function(BuildContext context)? buildFooter;
  final Widget Function(
    DrawerItem drawerItem,
    Function(DrawerItem) onTabItemSelected, {
    bool isSelected,
  })? buildItem;
  final Function(DrawerItem drawerItem)? onTabItemSelected;

  const CustomDrawerView({
    super.key,
    required this.tabsItems,
    required this.pageController,
    required this.onTabItemSelected,
    this.buildHeader,
    this.buildFooter,
    this.buildItem,
  });

  @override
  createState() => _CustomDrawerViewState();
}

class _CustomDrawerViewState extends State<CustomDrawerView> {
  late DrawerItem currentDrawerItem;

  MainService get mainService => Get.find();

  @override
  void initState() {
    super.initState();
    currentDrawerItem =
        widget.tabsItems[widget.pageController.page?.toInt() ?? 0];
  }

  void onTabItemSelected(DrawerItem drawerItem) async {
    if (!drawerItem.isAction) {
      widget.pageController.animateToPage(
        widget.tabsItems.indexOf(drawerItem),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      Get.back();
      if (widget.onTabItemSelected != null) {
        widget.onTabItemSelected!(drawerItem);
        setState(() {
          currentDrawerItem = drawerItem;
        });
      }
    } else {
      await drawerItem.onActionTab?.call();
    }
  }

  TextButton _buildItem(
    DrawerItem drawerItem,
    Function(DrawerItem drawerItem) onTabItemSelected, {
    bool isSelected = false,
  }) =>
      TextButton(
        onPressed: () => onTabItemSelected(drawerItem),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => isSelected ? UIThemeColors.fieldBg : Colors.transparent,
          ),
          alignment: Alignment.centerLeft,
          padding: WidgetStateProperty.resolveWith(
            (states) => const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
          ),
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Icon(
              drawerItem.icon,
              color: isSelected ? UIColors.primary : UIThemeColors.text3,
              size: 24,
            ),
            const Gap(10),
            Flexible(
              child: Text(
                drawerItem.text,
                style: TextStyles.smallTitle.copyWith(
                  color: isSelected ? UIColors.primary : UIThemeColors.text3,
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Drawer(
          child: Container(
            width: 280,
            height: SizeConfig(context).realScreenHeight * 0.9,
            margin: EdgeInsets.symmetric(
              vertical: SizeConfig(context).screenHeight * 0.04,
            ),
            decoration: BoxDecoration(
              color: UIThemeColors.pageBackground,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  mainService.appLanguage.isAr ? 0 : 19,
                ),
                topLeft: Radius.circular(
                  mainService.appLanguage.isAr ? 19 : 0,
                ),
                bottomRight: Radius.circular(
                  mainService.appLanguage.isAr ? 0 : 19,
                ),
                bottomLeft: Radius.circular(
                  mainService.appLanguage.isAr ? 19 : 0,
                ),
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 2,
                  spreadRadius: 2,
                  offset: Offset(2, 1),
                  color: Color(0X77333333),
                )
              ],
            ),
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: UIColors.primary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(
                        mainService.appLanguage.isAr ? 0 : 19,
                      ),
                      topLeft: Radius.circular(
                        mainService.appLanguage.isAr ? 19 : 0,
                      ),
                    ),
                  ),
                  child: widget.buildHeader?.call(context),
                ),
                Flexible(
                  child: Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                        child: ListView.builder(
                          itemCount: widget.tabsItems.length,
                          itemBuilder: (context, index) =>
                              (widget.buildItem ?? _buildItem)(
                            widget.tabsItems[index],
                            onTabItemSelected,
                            isSelected:
                                currentDrawerItem == widget.tabsItems[index],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.light_mode_outlined,
                      color: mainService.themeMode == UIThemeMode.light
                          ? UIColors.primary
                          : UIThemeColors.text2,
                    ),
                    Switch(
                      value: mainService.themeMode == UIThemeMode.dark,
                      onChanged: (value) {
                        mainService.setThemeMode(
                          value ? UIThemeMode.dark : UIThemeMode.light,
                        );
                        Get.back();
                      },
                    ),
                    Icon(
                      Icons.dark_mode_outlined,
                      color: mainService.themeMode == UIThemeMode.dark
                          ? UIColors.primary
                          : UIThemeColors.text2,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final lang in Language.all)
                        ButtonView(
                          backgroundColor: lang.backgroundColor,
                          onPressed: mainService.appLanguage == lang
                              ? null
                              : () => mainService.setAppLanguage(lang),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            "$lang",
                            style: TextStyle(
                              color: mainService.appLanguage == lang
                                  ? const Color(0XFF707070)
                                  : const Color(0XFFFFFFFF),
                              fontSize: 15,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: UIColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(
                        mainService.appLanguage.isAr ? 0 : 19,
                      ),
                      bottomLeft: Radius.circular(
                        mainService.appLanguage.isAr ? 19 : 0,
                      ),
                    ),
                  ),
                  child: widget.buildFooter?.call(context),
                ),
              ],
            ),
          ),
        ),
      );
}

class DrawerItem {
  final String name;
  final IconData icon;
  final String text;
  final bool isAction;
  final Future Function()? onActionTab;
  final Widget Function(BuildContext context)? buildTab;
  final Widget? Function(BuildContext context)? buildFloatingActionButton;

  const DrawerItem(
    this.name,
    this.text,
    this.icon, {
    this.isAction = false,
    this.onActionTab,
    this.buildTab,
    this.buildFloatingActionButton,
  })  : assert(
          !((isAction && buildTab != null) || (!isAction && buildTab == null)),
          'The DrawerItem can\'t be an action and have tab widget or does not have tab widget and is not action same time',
        ),
        assert(
          !(isAction && onActionTab == null),
          'onActionTab required when DrawerItem is action',
        );
}
