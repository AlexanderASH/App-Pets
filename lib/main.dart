import 'package:app_pets/src/pages/Home.dart';
import 'package:app_pets/src/pages/PetForm.dart';
import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pets',
      theme: ThemeData(
        primaryColor: Colors.pink
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (_) => HomePage(),
        'form': (_) => PetFormPage()
      },
    );
  }
}