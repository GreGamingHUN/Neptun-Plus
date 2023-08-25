import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarTimeline(
        locale: 'hu',
        monthColor: Theme.of(context).colorScheme.secondary,
        activeBackgroundDayColor: Theme.of(context).colorScheme.secondary,
        activeDayColor: Theme.of(context).textTheme.bodyMedium?.color,
        leftMargin: 25,
        onDateSelected: (p0) {
          print(p0);
        },
        firstDate: DateTime(2023),
        lastDate: DateTime(2024),
        initialDate: DateTime.now(),
      ),
    );
  }
}
