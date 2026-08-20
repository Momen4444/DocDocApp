import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await LocalStorageService.deleteToken();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Login Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await LocalStorageService.deleteToken();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/sign-in');
                }
              },
              child: const Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
