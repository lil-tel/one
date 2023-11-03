import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:one/splash_screen.dart';
import 'package:one/auth_page.dart';
import 'package:one/settings_page.dart';

import 'package:one/pagehome.dart';
import 'package:one/pageplus.dart';
import 'package:one/pagepeople.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Color _color = ThemeData().primaryColor;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(// This widget is the root of your application.
      title: 'One',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _color,
        ),
      ),
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _color,
          brightness: Brightness.values[0],
        ),
      ),
      themeMode: _themeMode,
      home: SplashScreen(), // Set SplashScreen as the home route
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  ThemeMode getTheme(){
    return _themeMode;
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  _AppInitializerState();

  User? _user;

  @override
  void initState() {
    super.initState();
    checkAuthState();
  }

  void checkAuthState() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return AuthPage();
    } else {
      return HomePage();
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState ();

  int pageIndex = 0;

  final pages = [
    PageHome(),
    PagePlus(),
    PagePeople(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: (){},
        ),
        title: Text(
          getTitle(pageIndex),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: getActions(context),
      ),
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
              Icons.home_filled,
              color: Colors.white,
              size: 35,
            )
                : const Icon(
              Icons.home_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
              Icons.add,
              color: Colors.white,
              size: 35,
            )
                : const Icon(
              Icons.add,
              color: Colors.white,
              size: 35,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? const Icon(
              Icons.widgets_rounded,
              color: Colors.white,
              size: 35,
            )
                : const Icon(
              Icons.widgets_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }

  getActions(BuildContext context) {
    switch (pageIndex) {
      case 2:
        return [IconButton(
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
          icon: Icon(
            color: Theme.of(context).colorScheme.primary,
            Icons.settings,
          ),
        )
        ];
      default:
        List<Widget> emptyList = [];
        return emptyList;
    }
  }

  getTitle(int index) {
    switch (index) {
      case 0:
        return 'One';
      case 1:
        return 'New post';
      case 2:
        return 'People';
    }
  }
}