import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:localization_webpage/model/jsonWithDetailsModel.dart';
import 'package:meta/meta.dart';

part 'json_to_csv_state.dart';

class JsonToCsvCubit extends Cubit<JsonToCsvState> {
  JsonToCsvCubit() : super(JsonToCsvState.initial());


  void checkValidity(JsonWithDetailsModel jsonData) {
    try {
      final Map<String, dynamic> jsonDataMap =
          jsonDecode(jsonData.textEditingController.text);
      if (jsonDataMap.isEmpty) {
        throw Exception('Empty JSON');
      }
      state.jsonDataList.firstWhere((element) => element == jsonData)
        ..jsonData=jsonData.jsonData
        ..isJsonValid = true
        ..isConfirmed = false;
      log('Json is valid:');
    } catch (e) {
      state.jsonDataList.firstWhere((element) => element == jsonData)
        ..jsonData=jsonData.jsonData
        ..isJsonValid = false
        ..isConfirmed = false;
      log('Json is invalid:');
    } finally {
      emit(state.copyWith(
        jsonDataList: List.from(state.jsonDataList),
      ));
    }
  }

  void confirmJson(JsonWithDetailsModel jsonData) {
    try {
      //check if json is Valid
      final Map<String, dynamic> jsonDataMap =
          jsonDecode(jsonData.textEditingController.text);
      if (jsonDataMap.isEmpty) {
        throw Exception('Empty JSON');
      }
      state.jsonDataList.firstWhere((element) => element == jsonData)
        ..jsonData=jsonData.jsonData
        ..isJsonValid = true
        ..isConfirmed = true;
      log('Json is valid: ${state.jsonDataList.firstWhere((element) => element == jsonData)}');
    } catch (e) {
      state.jsonDataList.firstWhere((element) => element == jsonData)
        ..jsonData=jsonData.jsonData
        ..isJsonValid = false
        ..isConfirmed = false;
      log('Json is invalid: ${state.jsonDataList.firstWhere((element) => element == jsonData)}');
    }
  }
  void addNewJsonBlock() {
    final newList = List<JsonWithDetailsModel>.from(state.jsonDataList)
      ..add(JsonWithDetailsModel(
        textEditingController: TextEditingController(),
        isJsonValid: false,
        isConfirmed: false, jsonData: {},
      ));
    emit(state.copyWith(
      jsonDataList: newList,
    ));
    log('Added new JSON block, length: ${state.jsonDataList.length}');
    log('${state.jsonDataList}');
  }
}
