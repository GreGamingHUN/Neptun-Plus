import 'package:flutter/scheduler.dart';
import 'package:localstorage/localstorage.dart';
import 'api_calls.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neptun Plus',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Neptun Plus'),
    );
  }
}

final LocalStorage storage = LocalStorage('neptunplus_storage');

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with apiCalls {
  Future<dynamic> changeScreen() {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      FlutterDisplayMode.setHighRefreshRate();
    });
  }

  Future<bool> checkLoginStatus() async {
    final result = await storage.ready;
    if (result == true && storage.getItem('loggedin') == 'true') {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storage.ready,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          if (storage.getItem('loggedin') == 'true') {
            return const MainScreen();
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Kérlek jelentkezz be!'),
                    LoginForm(),
                  ],
                ),
              ),
            );
          }
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Elbasztad'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Kérlek jelentkezz be!'),
                  LoginForm(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final userNameTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  String apiCallResponse = "";

  void apiRequest() async {
    await storage.setItem('username', userNameTextController.text);
    await storage.setItem('password', passwordTextController.text);
    apiCallResponse = await apiCalls.getCurriculums(
        userNameTextController.text, passwordTextController.text);
    if (apiCallResponse == '') {
      Fluttertoast.showToast(msg: 'Hibás felhasználónév vagy jelszó!');
    } else {
      await storage.setItem('loggedin', 'true');
      changeScreen();
    }
  }

  Future<dynamic> changeScreen() {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  void dispose() {
    userNameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 64, right: 64),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A mező kitöltése kötelező';
                  }
                  return null;
                },
                controller: userNameTextController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Neptunkód'),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 64, right: 64),
              child: TextFormField(
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A mező kitöltése kötelező';
                  }
                  return null;
                },
                controller: passwordTextController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Jelszó'),
              ),
            ),
            FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    apiRequest();
                  }
                },
                child: const Text('Bejelentkezés')),
          ],
        ));
  }
}
