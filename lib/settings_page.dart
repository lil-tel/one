import 'package:flutter/material.dart';

import 'package:one/profile_page.dart';
import 'package:one/appearance_page.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
            'Settings',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text('Notifications'),
              trailing: const Icon(Icons.notifications),
              onTap: () {
                // TODO: Handle notification settings
              },
            ),
            ListTile(
              title: const Text('Account'),
              trailing: const Icon(Icons.account_circle),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
                // TODO: Handle account settings
              },
            ),
            ListTile(
              title: const Text('Privacy'),
              trailing: const Icon(Icons.lock),
              onTap: () {
                // TODO: Handle privacy settings
              },
            ),
            ListTile(
              title: const Text('Appearance'),
              trailing: const Icon(Icons.color_lens),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppearancePage()),
                );
              },
            ),
          // Add more list tiles for other settings options
          ],
        ),
    );
  }
}
