import 'package:flutter/material.dart';

import 'view/pages/login_page.dart';
import 'view/theme.dart';

class PurrioritiesApp extends StatelessWidget {
  const PurrioritiesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      //
      home: const LoginPage(),
    );
  }
}
