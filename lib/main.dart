import 'package:flutter/material.dart';

import 'package:event_management/screens/event_dropdown_screen.dart';
import 'package:event_management/screen/homescreen.dart';

void
    main() {
  runApp(
      const MyApp());
}

class MyApp
    extends StatelessWidget {
  const MyApp(
      {super.key});

  @override
  Widget
      build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const EventDropdownScreen(),
        '/home': (context) => const ServingMenuUI(),
      },
    );
  }
}
