import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localization_webpage/presentation/csv_to_json_page.dart';
import 'package:localization_webpage/presentation/json_to_csv_page.dart';
import 'package:localization_webpage/presentation/main_page.dart';

class RoutesPath {
  static const String home = "/";
  static const String csvToJson = "/csv_to_json";
  static const String jsonToCsv = "/json_to_csv";
}

final GoRouter globalRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path:RoutesPath.home,
      builder: (BuildContext context, GoRouterState state) {
        return const MainPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path:deleteFirstSlash(RoutesPath.csvToJson),

          builder: (BuildContext context, GoRouterState state) {
            return const CsvToJsonPage();
          }
        ),
        GoRoute(
            path:deleteFirstSlash(RoutesPath.jsonToCsv),
          builder: (BuildContext context, GoRouterState state) {
            return const JsonToCsvPage();
          }
        ),
      ],
    ),
  ],
);

String deleteFirstSlash(String path) {
  if (path.startsWith("/")) {
    return path.substring(1);
  }
  return path;
}