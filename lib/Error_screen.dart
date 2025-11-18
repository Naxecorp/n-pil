import 'package:flutter/material.dart';
import 'package:nweb/main.dart';


class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({
    super.key,
    this.message = "Chargement en cours...", // valeur par défaut
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(child: const Icon(Icons.error,size: 50,),
              onTap: () {
                runApp(const MyApp());
              },),
              const SizedBox(height: 16),
              Text(
                message, // <-- utilisation du message
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


