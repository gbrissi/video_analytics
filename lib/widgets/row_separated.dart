import 'package:flutter/material.dart';

class RowSeparated extends StatelessWidget {
  RowSeparated({
    super.key,
    required List<Widget> children,
    required double spacing,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : spacedChildren = _getSpacedChildren(children, spacing);
  final List<Widget> spacedChildren;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: spacedChildren,
    );
  }
}

List<Widget> _getSpacedChildren(
  List<Widget> children,
  double spacing,
) {
  final List<Widget> spacedChildren = [];
  final SizedBox divider = SizedBox(width: spacing);

  for (var i = 0; i < children.length; i++) {
    spacedChildren.add(children[i]);

    if (!(i == (children.length - 1))) {
      spacedChildren.add(divider);
      continue;
    }

    break;
  }

  return spacedChildren;
}
