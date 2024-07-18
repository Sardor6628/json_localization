import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localization_webpage/constants/routes.dart';
import 'package:localization_webpage/presentation/main_page.dart';
import 'package:localization_webpage/widgets/custom_elevation_button_widget.dart';

class OrientationSwitcher extends StatefulWidget {
  const OrientationSwitcher({Key? key}) : super(key: key);

  @override
  _OrientationSwitcherState createState() => _OrientationSwitcherState();
}

class _OrientationSwitcherState extends State<OrientationSwitcher> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool isPortrait = constraints.maxHeight > constraints.maxWidth;
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Wrap(
            direction: isPortrait ? Axis.vertical : Axis.horizontal,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: isPortrait ? constraints.maxWidth : constraints.maxWidth * 0.5,
                height: isPortrait ? constraints.maxHeight * 0.5 : constraints.maxHeight,
                child: CustomElevatedButton(
                  title: 'I want to convert JSON to Excel/CSV',
                  onPressed: () {
                    context.go(RoutesPath.jsonToCsv);
                  },
                  isLeftButton: true,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: isPortrait ? constraints.maxWidth : constraints.maxWidth * 0.5,
                height: isPortrait ? constraints.maxHeight * 0.5 : constraints.maxHeight,
                child: CustomElevatedButton(
                  title: 'I want to convert Excel/CSV to JSON',
                  onPressed: () {
                    context.go(RoutesPath.csvToJson);
                  },
                  isLeftButton: false,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}