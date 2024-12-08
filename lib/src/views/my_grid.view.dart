import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MyGridView extends StatelessWidget {
  final List<Widget> children;
  final int colCount;
  final double gapSize;
  final MainAxisAlignment rowMainAxisAlignment, colMainAxisAlignment;
  final CrossAxisAlignment rowCrossAxisAlignment, colCrossAxisAlignment;
  final MainAxisSize rowMainAxisSize, colMainAxisSize;

  const MyGridView({
    super.key,
    required this.children,
    this.colCount = 2,
    this.gapSize = 4,
    this.rowMainAxisAlignment = MainAxisAlignment.center,
    this.colMainAxisAlignment = MainAxisAlignment.center,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
    this.colCrossAxisAlignment = CrossAxisAlignment.center,
    this.rowMainAxisSize = MainAxisSize.max,
    this.colMainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    int rowCount = (children.length / colCount).ceil();

    List<List<Widget>> rowsList = [];
    int itemIndex = 0;
    for (int i = 0; i < rowCount; i++) {
      int leftCount = children.length - (i * colCount);
      int rowColCount = leftCount < colCount ? leftCount : colCount;
      List<Widget> row = [];
      for (int j = 0; j < rowColCount; j++) {
        row.add(Flexible(child: children[itemIndex]));
        if (j < rowColCount - 1) row.add(Gap(gapSize));
        itemIndex++;
      }
      rowsList.add(row);
    }

    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: rowMainAxisAlignment,
      crossAxisAlignment: rowCrossAxisAlignment,
      mainAxisSize: rowMainAxisSize,
      children: [
        for (int i = 0; i < rowsList.length; i++) ...[
          Flexible(
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: colMainAxisAlignment,
              crossAxisAlignment: colCrossAxisAlignment,
              mainAxisSize: colMainAxisSize,
              children: rowsList[i],
            ),
          ),
          if (i < rowsList.length - 1) Gap(gapSize)
        ]
      ],
    );
  }
}
