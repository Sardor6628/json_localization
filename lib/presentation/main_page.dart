import 'package:flutter/material.dart';
import 'package:localization_webpage/widgets/orienter_switcher_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: OrientationSwitcher(),
    );
  }
}

