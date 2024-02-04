import 'package:flutter/material.dart';

class SelectorOption<T> {
  final T value;
  final String name;

  SelectorOption({
    required this.value,
    required this.name,
  });
}

class SettingsSelector<T> extends StatelessWidget {
  const SettingsSelector({
    super.key,
    required this.selectedOption,
    required this.options,
    required this.onChanged,
  });
  final T selectedOption;
  final void Function(T value) onChanged;
  final List<SelectorOption<T>> options;
  String get selectedOptionName => options
      .firstWhere(
        (e) => e.value == selectedOption,
      )
      .name;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: options
          .map(
            (e) => MenuItemButton(
              child: Text(e.name),
              onPressed: () => onChanged(e.value),
            ),
          )
          .toList(),
      builder: (context, controller, child) {
        return IntrinsicWidth(
          child: OutlinedButton(
            style: const ButtonStyle(
              padding: MaterialStatePropertyAll(
                EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
              ),
            ),
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    selectedOptionName,
                  ),
                ),
                const Icon(
                  Icons.expand_more,
                  size: 18,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
