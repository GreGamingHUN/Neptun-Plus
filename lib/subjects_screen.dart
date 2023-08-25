import 'package:flutter/material.dart';
import 'package:neptunplus_flutter/exams_screen.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getPeriodTermsList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Expanded(
              child: Column(children: []),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Icon(Icons.error_outline));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
