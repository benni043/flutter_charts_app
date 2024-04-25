import 'package:flutter/material.dart';
import 'package:flutter_charts_app/pages/Home.dart';
import 'package:flutter_charts_app/pages/Settings.dart';
import 'package:flutter_charts_app/providers/roomProvider.dart';
import 'package:flutter_charts_app/providers/urlProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UrlProvider()),
        ChangeNotifierProvider(create: (context) => RoomProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: "/settings",
        routes: {
          "/": (context) => const Home(),
          "/settings": (context) => const Settings(),
        },
      ),
    );
  }
}
