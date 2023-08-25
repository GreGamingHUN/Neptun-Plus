import 'package:flutter/material.dart';
import 'package:neptunplus_flutter/beallitasok_screen.dart';
import 'package:neptunplus_flutter/exams_screen.dart';
import 'package:neptunplus_flutter/messages_screen.dart';
import 'package:neptunplus_flutter/profile_popup.dart';
import 'package:neptunplus_flutter/subjects_screen.dart';
import 'package:neptunplus_flutter/timetable_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  int newMessages = 0;
  @override
  void initState() {
    getNewMessages();
    super.initState();
  }

  getNewMessages() async {
    int? tmp = await messagesStorage.getItem('newMessages');
    if (tmp == null) {
      return;
    }
    setState(() {
      newMessages = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Beállítások'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BeallitasokScreen(),
                )),
          )
        ],
      )),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Neptun Plus!'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ProfilePopup(),
                  );
                },
                icon: const Icon(Icons.account_circle_outlined)),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            selectedIndex: currentIndex,
            destinations: [
              NavigationDestination(
                  icon: (newMessages == 0
                      ? Icon(
                          currentIndex == 0 ? Icons.mail : Icons.mail_outlined)
                      : Badge(
                          label: Text(newMessages.toString()),
                          child: Icon(currentIndex == 0
                              ? Icons.mail
                              : Icons.mail_outlined),
                        )),
                  label: 'Üzenetek'),
              NavigationDestination(
                  icon: Icon(currentIndex == 1
                      ? Icons.calendar_today
                      : Icons.calendar_today_outlined),
                  label: 'Órarend'),
              NavigationDestination(
                  icon: Icon(
                      currentIndex == 2 ? Icons.book : Icons.book_outlined),
                  label: 'Tárgyak'),
              NavigationDestination(
                  icon: Icon(currentIndex == 3
                      ? Icons.library_books
                      : Icons.library_books_outlined),
                  label: 'Vizsgák'),
            ],
            onDestinationSelected: (value) {
              setState(() {
                getNewMessages();
                currentIndex = value;
              });
            },
          ),
        ),
      ),
      body: [
        const MessagesScreen(),
        const TimetableScreen(),
        const SubjectsScreen(),
        const ExamsScreen()
      ][currentIndex],
    );
  }
}
