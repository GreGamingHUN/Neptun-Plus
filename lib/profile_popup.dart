import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:neptunplus_flutter/main.dart';
import 'package:theme_provider/theme_provider.dart';

class ProfilePopup extends StatefulWidget {
  const ProfilePopup({super.key});

  @override
  State<ProfilePopup> createState() => _ProfilePopupState();
}

LocalStorage storage = LocalStorage('neptun-plus');

class _ProfilePopupState extends State<ProfilePopup> {
  String neptunCode = '';
  @override
  void initState() {
    getNeptunCode();
    super.initState();
  }

  getNeptunCode() async {
    await storage.ready;
    neptunCode = await storage.getItem('neptunCode');
    setState(() {});
  }

  bool darkMode = false;
  @override
  Widget build(BuildContext context) {
    if (ThemeProvider.themeOf(context).id == 'darktheme') {
      darkMode = true;
    }
    return AlertDialog(
      alignment: Alignment.topCenter,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Helló,',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    neptunCode,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Kijelentkezés'),
                          content:
                              const Text('Biztos ki szeretnél jelentkezni?'),
                          actions: [
                            OutlinedButton(
                                onPressed: () {
                                  logout();
                                },
                                child: const Text('Kilépés')),
                            FilledButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Mégsem'))
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.logout_outlined))
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sötét mód'),
              Switch(
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        ThemeProvider.controllerOf(context)
                            .setTheme('darktheme');
                      } else {
                        ThemeProvider.controllerOf(context)
                            .setTheme('lighttheme');
                      }
                      darkMode = !darkMode;
                    });
                  })
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Neptun Plus!',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'v0.0.1',
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  logout() async {
    await storage.deleteItem('neptunCode');
    await storage.deleteItem('password');
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyApp(),
        ));
  }
}
