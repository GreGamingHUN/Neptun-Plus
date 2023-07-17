import 'package:flutter/material.dart';
import 'package:neptunplus_flutter/home_screen.dart';
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
        children: const [
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Beállítások'),
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
                    builder: (context) => ProfilePopup(),
                  );
                },
                icon: Icon(Icons.account_circle_outlined)),
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
                  icon: Icon(
                      (currentIndex == 0 ? Icons.house : Icons.house_outlined)),
                  label: 'Kezdőlap'),
              NavigationDestination(
                  icon: (newMessages == 0
                      ? Icon(
                          currentIndex == 1 ? Icons.mail : Icons.mail_outlined)
                      : Badge(
                          label: Text(newMessages.toString()),
                          child: Icon(currentIndex == 1
                              ? Icons.mail
                              : Icons.mail_outlined),
                        )),
                  label: 'Üzenetek'),
              NavigationDestination(
                  icon: Icon(currentIndex == 2
                      ? Icons.calendar_today
                      : Icons.calendar_today_outlined),
                  label: 'Órarend'),
              NavigationDestination(
                  icon: Icon(
                      currentIndex == 3 ? Icons.book : Icons.book_outlined),
                  label: 'Tárgyak'),
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
        HomeScreen(),
        MessagesScreen(),
        TimetableScreen(),
        SubjectsScreen()
      ][currentIndex],
    );
  }
}
