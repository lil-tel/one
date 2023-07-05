import 'package:flutter/material.dart';
import 'package:one/ThemeManager.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:one/splash_screen.dart';
import 'package:one/auth_page.dart';
import 'package:one/settings_page.dart';

import 'package:one/pagehome.dart';
import 'package:one/pageplus.dart';
import 'package:one/pagepeople.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => new ThemeNotifier(),
    child: MyApp(),
  ));;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // SharedPreferences? prefs;
  // bool dark = false;

  /*void getSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? dark = prefs.getBool('dark');
    if (dark == null){
      await prefs.setBool('dark', false);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(// This widget is the root of your application.
          title: 'One',
          theme: theme.getTheme(),
          home: SplashScreen(theme), // Set SplashScreen as the home route
        ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key, required this.theme});

  final ThemeNotifier theme;

  @override
  _AppInitializerState createState() => _AppInitializerState(theme:theme);
}

class _AppInitializerState extends State<AppInitializer> {
  _AppInitializerState({required this.theme});

  final ThemeNotifier theme;

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
      return HomePage(theme);
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage(this.theme, {Key? key}) : super(key: key);

  final ThemeNotifier theme;

  @override
  _HomePageState createState() => _HomePageState(theme);
}

class _HomePageState extends State<HomePage> {
  _HomePageState (this.theme);

  final ThemeNotifier theme;
  int pageIndex = 0;

  final pages = [
    const PageHome(),
    const PagePlus(),
    const PagePeople(),
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
        actions: getActions(context, theme),
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

  getActions(BuildContext context, ThemeNotifier theme) {
    switch (pageIndex) {
      case 2:
        return [IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage(theme)),
            );
          },
          icon: const Icon(
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