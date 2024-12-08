import 'dart:math';

import 'package:get/get.dart';

import '../src.dart';

class PostGalleryView extends StatelessWidget {
  final int itemsCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, int index) previewItemBuilder;
  final Widget Function(BuildContext context, int index)? previewTitleBuilder;
  final double width, height;

  const PostGalleryView({
    super.key,
    required this.itemsCount,
    required this.itemBuilder,
    required this.previewItemBuilder,
    this.previewTitleBuilder,
    this.width = 150,
    this.height = 150,
  });

  onItemTap(int index) {
    Get.dialog(
      Material(
        color: Colors.transparent,
        child: FullScreenPreview(
          itemsCount: itemsCount,
          index: index,
          itemBuilder: previewItemBuilder,
          titleBuilder: previewTitleBuilder,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> gridItems = [];

    int gridCount = min(itemsCount, 4);
    for (int i = 0; i < gridCount; i++) {
      if (i == gridCount - 1 && i != itemsCount - 1) {
        gridItems.add(
          InkWell(
            onTap: () => onItemTap(i),
            child: Stack(
              children: [
                Positioned.fill(
                  child: itemBuilder(context, i),
                ),
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.5)),
                ),
                Positioned.fill(
                  top: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      '+${itemsCount - gridCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        gridItems.add(
          InkWell(
            onTap: () => onItemTap(i),
            child: itemBuilder(context, i),
          ),
        );
      }
    }
    return ButtonView(
      onPressed: () => onItemTap(0),
      backgroundColor: const Color.fromARGB(90, 123, 123, 123),
      padding: EdgeInsets.zero,
      borderRadius: 5,
      width: width,
      height: height,
      child: MyGridView(
        children: gridItems,
      ),
    );
  }
}

class FullScreenPreview extends StatefulWidget {
  final int itemsCount;
  final int index;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? titleBuilder;

  const FullScreenPreview({
    super.key,
    required this.itemsCount,
    required this.index,
    required this.itemBuilder,
    required this.titleBuilder,
  });

  @override
  State<FullScreenPreview> createState() => _FullScreenPreviewState();
}

class _FullScreenPreviewState extends State<FullScreenPreview> {
  late PageController pageController;

  int currentIndex = 1;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: widget.index);
    currentIndex = widget.index + 1;
    pageController.addListener(() {
      setState(() {
        currentIndex = (pageController.page ?? 0).round() + 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Get.back(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Flex(
            direction: Axis.vertical,
            children: [
              if (widget.titleBuilder != null)
                widget.titleBuilder!(context, currentIndex),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: PageView(
                    controller: pageController,
                    children: [
                      for (int i = 0; i < widget.itemsCount; i++)
                        widget.itemBuilder(context, i)
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: currentIndex - 1 > 0
                        ? () => pageController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeIn,
                            )
                        : null,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: UIColors.info,
                      size: 28,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      '$currentIndex/${widget.itemsCount}',
                      style: TextStyles.title,
                    ),
                  ),
                  IconButton(
                    onPressed: currentIndex + 1 <= widget.itemsCount
                        ? () => pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeIn,
                            )
                        : null,
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: UIColors.info,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
