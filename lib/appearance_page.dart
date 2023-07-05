import 'package:flutter/material.dart';
import 'package:one/ThemeManager.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage(this.theme, {super.key});

  final ThemeNotifier theme;

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
                  onTap: () => theme.setDarkMode(),
                  child: Card(
                    shadowColor: theme.getTheme().colorScheme.onSurface,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children:(
                          [
                            Icon(
                              theme.getTheme() == theme.darkTheme ? Icons.dark_mode : Icons.dark_mode_outlined,
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
                  onTap: () => theme.setLightMode(),
                  child: Card(
                    shadowColor: theme.getTheme().colorScheme.onSurface,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children:(
                          [
                            Icon(
                              theme.getTheme() == theme.lightTheme ? Icons.light_mode : Icons.light_mode_outlined,
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
