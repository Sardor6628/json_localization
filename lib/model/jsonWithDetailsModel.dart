import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class JsonWithDetailsModel extends Equatable{
  TextEditingController textEditingController;
  int generatedID = DateTime.now().millisecondsSinceEpoch;
  Map<String, dynamic>jsonData;
  bool isJsonValid;
  bool isConfirmed = false;
  JsonWithDetailsModel({
    required this.textEditingController,
    required this.jsonData,
    required this.isJsonValid,
    required this.isConfirmed,
  });

  JsonWithDetailsModel copyWith({
    TextEditingController? textEditingController,
    Map<String, dynamic>? jsonData,
    bool? isJsonValid,
    bool? isConfirmed,
  }) {
    return JsonWithDetailsModel(
      textEditingController: textEditingController ?? this.textEditingController,
      jsonData: jsonData ?? this.jsonData,
      isJsonValid: isJsonValid ?? this.isJsonValid,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }
  @override
  String toString() {
    return 'JsonWithDetailsModel(textEditingController: $textEditingController, jsonData: $jsonData, isJsonValid: $isJsonValid, isConfirmed: $isConfirmed)';
  }

  @override
  List<Object?> get props =>[textEditingController, jsonData, isJsonValid, isConfirmed];
}
JsonWithDetailsModel emptyJsonWithDetailsModel = JsonWithDetailsModel(
  textEditingController: TextEditingController(),
  jsonData: {},
  isJsonValid: true,
  isConfirmed: false,
);