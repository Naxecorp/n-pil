import 'package:flutter/material.dart';


class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ▶ Progress bar circulaire infinie
              CircularProgressIndicator(
                strokeWidth: 3, // plus fin ? augmente/diminue
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.primary, // couleur thème
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Chargement en cours...",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

