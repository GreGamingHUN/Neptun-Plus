import 'package:flutter/material.dart';

class BeallitasokScreen extends StatelessWidget {
  const BeallitasokScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beállítások'),
      ),
      body: Column(
        children: [
          SwitchListTile(
            tileColor: Theme.of(context).cardColor,
            value: true,
            onChanged: (status) {},
            title: const Text('nagyonjo'),
          )
        ],
      ),
    );
  }
}
