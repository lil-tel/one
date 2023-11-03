import 'package:flutter/material.dart';
import 'package:one/main.dart';


class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: (){ Navigator.pop(context); },
        ),
        title: Text(
          'Appearance',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => MyApp.of(context).changeTheme(ThemeMode.dark),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children:(
                          [
                            Icon(
                              MyApp.of(context).getTheme() == ThemeMode.dark ? Icons.dark_mode : Icons.dark_mode_outlined,
                              size: 50,
                            ),
                            Text('Dark mode')
                          ]
                        )
                      ),
                    )
                  )
                ),
                GestureDetector(
                    onTap: () => MyApp.of(context).changeTheme(ThemeMode.system),
                    child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              children:(
                                  [
                                    Icon(
                                      MyApp.of(context).getTheme() == ThemeMode.system
                                          ? Icons.circle_rounded : Icons.circle_outlined,
                                      size: 50,
                                    ),
                                    Text('System mode')
                                  ]
                              )
                          ),
                        )
                    )
                ),
                GestureDetector(
                  onTap: () => MyApp.of(context).changeTheme(ThemeMode.light),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children:(
                          [
                            Icon(
                              MyApp.of(context).getTheme() == ThemeMode.light ? Icons.light_mode : Icons.light_mode_outlined,
                              size: 50,
                            ),
                            Text('Light mode')
                          ]
                        )
                      ),
                    )
                  )
                ),
              ],
            )
          ]
        ),
      ),
    );
  }
}
