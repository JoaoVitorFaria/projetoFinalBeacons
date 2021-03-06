import 'package:flutter/material.dart';
import 'package:beacon/controller/controller_bluetooth.dart';
import 'package:beacon/view/view_inicial.dart';
import 'package:get/get.dart';

import 'controller/controller_distancia.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(RequirementStateController());
    Get.put(RequirementDistance());
    final themeData = Theme.of(context);
    const primary = Colors.blue;

    return GetMaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: primary,
        appBarTheme: themeData.appBarTheme.copyWith(
          elevation: 0.5,
          color: Colors.white,
          actionsIconTheme: themeData.primaryIconTheme.copyWith(
            color: primary,
          ),
          iconTheme: themeData.primaryIconTheme.copyWith(
            color: primary,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: primary,
      ),
      home: HomePage(),
    );
  }
}
