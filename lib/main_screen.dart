import 'package:flutter/material.dart';
import 'package:neptunplus_app/main.dart';
import 'messages_screen.dart';
import 'subjects_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int messagesCount = 0;
  bool showMessageBadge = false;
  static const List<Widget> _screenPages = <Widget>[
    HomeScreen(),
    SubjectsScreen(),
    MessagesScreen(),
  ];

  @override
  void initState() {
    if (storage.getItem('messages') != null) {
      List<dynamic> messages = storage.getItem('messages');
      messagesCount = messages.length;
      showMessageBadge = true;
    }
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neptun Plus!'),
        centerTitle: true,
        leading: const Icon(Icons.menu_outlined),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18.0),
            child: Icon(Icons.account_circle_outlined),
          )
        ],
      ),
      body: Center(
        child: _screenPages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
            activeIcon: Icon(Icons.book),
            icon: Icon(Icons.book_outlined),
            label: 'Kezdőlap'),
        const BottomNavigationBarItem(
            activeIcon: Icon(Icons.house),
            icon: Icon(Icons.house_outlined),
            label: 'Tárgyak'),
        BottomNavigationBarItem(
          tooltip: 'wat',
          activeIcon: Badge(
              label: Text(messagesCount.toString()),
              isLabelVisible: showMessageBadge,
              child: const Icon(Icons.mail)),
          icon: Badge(
              label: Text(messagesCount.toString()),
              isLabelVisible: showMessageBadge,
              child: const Icon(Icons.mail_outlined)),
          label: 'Üzenetek',
        ),
      ], currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storage.ready,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return Column(
            children: [
              Text(storage.getItem('username')),
              Text(storage.getItem('password')),
              Text(storage.getItem('loggedin')),
            ],
          );
        } else {
          return const Text('wat');
        }
      },
    );
  }
}
