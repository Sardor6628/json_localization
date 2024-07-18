import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization_webpage/business_logic/json_to_csv/json_to_csv_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<JsonToCsvCubit>(
          create: (context) => JsonToCsvCubit(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: globalRouter,
        title: 'Localization Webpage',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
