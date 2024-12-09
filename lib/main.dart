import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/about': (context) => Scaffold(
          appBar: AppBar(title: Text('About')),
          body: Center(child: Text('This is the About page')),
        ),
        '/login': (context) => Scaffold(
          appBar: AppBar(title: Text('Login')),
          body: Center(child: Text('This is the Login page')),
        ),
      },
    );
  }
}
