import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:neptunplus_flutter/home_screen.dart';
import 'package:neptunplus_flutter/main_screen.dart';
import 'package:neptunplus_flutter/neptun_connection.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  runApp(MyApp());
  setHighRefreshRate();
}

setHighRefreshRate() async {
  await FlutterDisplayMode.setHighRefreshRate();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return ThemeProvider(
          saveThemesOnChange: true,
          loadThemeOnInit: true,
          themes: [
            AppTheme(
                id: 'lighttheme',
                data: ThemeData(useMaterial3: true, colorScheme: lightDynamic),
                description: 'Light Theme'),
            AppTheme(
                id: 'darktheme',
                data: ThemeData(useMaterial3: true, colorScheme: darkDynamic),
                description: 'Dark Theme'),
          ],
          child: ThemeConsumer(
            child: Builder(
              builder: (context) => MaterialApp(
                title: 'Neptun Plus!',
                theme: ThemeProvider.themeOf(context).data,
                home: MyHomePage(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

LocalStorage storage = LocalStorage('neptun-plus');

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    autoLogin();
    super.initState();
  }

  TextEditingController neptunCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  autoLogin() async {
    await storage.ready;
    var neptunCode = await storage.getItem('neptunCode');
    var password = await storage.getItem('password');
    if (neptunCode != null && password != null) {
      goToHomeScreen();
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Neptun Plus!',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: neptunCodeController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    hintText: 'Neptun Kód'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    hintText: 'Jelszó'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                  onPressed: () async {
                    login();
                  },
                  child: (isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const CircularProgressIndicator(),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
                          child: Text('Bejelentkezés'),
                        ))),
            )
          ],
        ),
      )),
    );
  }

  login() async {
    try {
      setState(() {
        isLoading = true;
      });
      String neptunCode = neptunCodeController.text;
      String password = passwordController.text;
      await appLogin(neptunCode, password);
      goToHomeScreen();
      setState(() {
        isLoading = false;
      });
    } on NeptunErrorMessage catch (e) {
      Fluttertoast.showToast(msg: 'Neptun hiba: ${e.errorMessage}');
    }
  }

  goToHomeScreen() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ));
  }
}
