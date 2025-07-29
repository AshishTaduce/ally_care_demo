import 'package:flutter/material.dart';

class InstructionList extends StatelessWidget {
  final List<String> instructions;
  const InstructionList({Key? key, required this.instructions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: instructions
          .asMap()
          .entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '${entry.key + 1}. ${entry.value}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
          .toList(),
    );
  }
} 