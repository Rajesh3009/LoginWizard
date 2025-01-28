import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsernameView extends ConsumerWidget {
  const UsernameView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: SelectableText('Username GeneratorUsername GeneratorUsername GeneratorUsername Generator')),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),
            ),
          ),
          Text('Specify the format of the username'),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'w:w:n'),
          ),
          Text('w = word, n = number'),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Generate'),
          ),
          SizedBox(height: 10),
          ElevatedButton(onPressed: () {}, child: Text('History')),
        ],
      ),
    );
  }
}
