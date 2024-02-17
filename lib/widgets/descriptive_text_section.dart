import 'package:flutter/material.dart';

class DescriptiveTextSection extends StatelessWidget {
  const DescriptiveTextSection({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
          ),
        )
      ],
    );
  }
}
