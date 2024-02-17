import 'package:flutter/material.dart';

class SmallCircularButton extends StatefulWidget {
  const SmallCircularButton({
    super.key,
    this.color,
    required this.onTap,
    this.isSelected = false,
    this.child,
  });
  final Widget? child;
  final bool isSelected;
  final Color? color;
  final void Function()? onTap;

  @override
  State<SmallCircularButton> createState() => _SmallCircularButtonState();
}

class _SmallCircularButtonState extends State<SmallCircularButton> {
  Color get outerBorderColor => widget.isSelected
      ? Theme.of(context).colorScheme.primary
      : Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        padding: const EdgeInsets.all(2),
        color: outerBorderColor,
        child: ClipOval(
          child: Container(
            color: Theme.of(context).canvasColor,
            padding: const EdgeInsets.all(2),
            child: ClipOval(
              child: SizedBox(
                width: 24,
                height: 24,
                child: Material(
                  color: widget.color,
                  child: InkWell(
                    onTap: widget.onTap,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
