import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LifestyleTab extends ConsumerStatefulWidget {
  const LifestyleTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LifestyleTabState();
}

class _LifestyleTabState extends ConsumerState<LifestyleTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
