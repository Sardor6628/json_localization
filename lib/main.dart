import 'package:flutter/material.dart';
import 'package:localization_webpage/constants/routes.dart';
import 'dart:convert';

import 'package:localization_webpage/presentation/main_page.dart';

void main() {
  runApp(const LocalizationApp());
}

class LocalizationApp extends StatelessWidget {
  const LocalizationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: globalRouter,
      title: 'Localization Webpage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
