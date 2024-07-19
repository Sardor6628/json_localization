import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localization_webpage/model/jsonWithDetailsModel.dart';
import 'dart:html' as html;

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
        ..jsonData = jsonData.jsonData
        ..isJsonValid = true
        ..isConfirmed = false;
    } catch (e) {
      state.jsonDataList.firstWhere((element) => element == jsonData)
        ..jsonData = jsonData.jsonData
        ..isJsonValid = false
        ..isConfirmed = false;
    } finally {
      emit(state.copyWith(
        jsonDataList: List.from(state.jsonDataList),
      ));
    }
  }

  void addNewJsonBlock() {
    final newList = List<JsonWithDetailsModel>.from(state.jsonDataList)
      ..add(JsonWithDetailsModel(
        textEditingController: TextEditingController(),
        isJsonValid: false,
        isConfirmed: false,
        jsonData: {},
      ));
    emit(state.copyWith(
      jsonDataList: newList,
    ));
    log('Added new JSON block, length: ${state.jsonDataList.length}');
    log('${state.jsonDataList}');
  }

  void generateAndDownloadExcel(BuildContext context) {
    if (!checkIfCanGenerate()) {
      Fluttertoast.showToast(
          msg: 'One or more JSON blocks are invalid',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    try {
      final List<List<CellValue>> csvData = [];
      Map<String, List<String>> _dataFiltered = {};

      for (var i = 0; i < state.jsonDataList.length; i++) {
        if (state.jsonDataList[i].isJsonValid) {
          final Map<String, dynamic> jsonDataMap =
              jsonDecode(state.jsonDataList[i].textEditingController.text);

          if (_dataFiltered.isEmpty) {
            _dataFiltered = jsonDataMap
                .map((key, value) => MapEntry(key, [value.toString()]));
          } else {
            jsonDataMap.forEach((key, value) {
              _dataFiltered.update(
                  key, (valueList) => valueList..add(value.toString()),
                  ifAbsent: () => List.filled(i, "")..add(value.toString()));
            });
          }
        }

        // Ensure that all keys have the correct number of elements
        _dataFiltered.forEach((key, value) {
          if (value.length < i + 1) {
            _dataFiltered.update(key, (valueList) => valueList..add(""));
          }
        });
      }

      csvData.add([
        TextCellValue('Key'),
        ...state.jsonDataList
            .map((e) =>
                TextCellValue('Block ${state.jsonDataList.indexOf(e) + 1}'))
            .toList()
      ]);

      _dataFiltered.forEach((key, value) {
        List<TextCellValue>? _value =
            _dataFiltered[key]?.map((e) => TextCellValue(e)).toList();
        csvData.add([TextCellValue(key), ...?_value]);
      });

      if (csvData.length < 2) {
        Fluttertoast.showToast(
            msg: 'No valid JSON blocks to generate CSV',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }

      var excel = Excel.createExcel();
      log('Excel data: ${excel}');
      for (var i = 0; i < csvData.length; i++) {
        excel['Sheet1'].appendRow(csvData[i]);
      }
      log('Excel data: $excel');

      final List<int> excelBytes = excel.save()!;
      emit(state.copyWith(
        error: '',
      ));
    } catch (e) {
      log("Error: $e");
      emit(state.copyWith(
        error: 'Error: ${e.toString()}',
      ));
    }
  }

  void generateAndDownloadCsv(BuildContext context) {
    if (!checkIfCanGenerate()) {
      Fluttertoast.showToast(
          msg: 'One or more JSON blocks are invalid',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    try {
      final List<List<dynamic>> csvData = [];
      Map<String, List<String>> _dataFiltered = {};
      for (var i = 0; i < state.jsonDataList.length; i++) {
        if (state.jsonDataList[i].isJsonValid) {
          final Map<String, dynamic> jsonDataMap =
              jsonDecode(state.jsonDataList[i].textEditingController.text);
          if (_dataFiltered.isEmpty) {
            _dataFiltered = jsonDataMap
                .map((key, value) => MapEntry(key, [value.toString()]));
          } else {
            jsonDataMap.forEach((key, value) {
              _dataFiltered.update(
                  key, (valueList) => valueList..add(value.toString()),
                  ifAbsent: () => ["" * i, value.toString()]);
            });
          }
        }
        _dataFiltered.forEach((key, value) {
          if (value.length < i + 1) {
            _dataFiltered.update(key, (valueList) => valueList..add(""));
          }
        });
      }
      csvData.add([
        'Key',
        ...state.jsonDataList
            .map((e) => 'Block ${state.jsonDataList.indexOf(e) + 1}')
            .toList()
      ]);
      _dataFiltered.forEach((key, value) {
        csvData.add([key, ...value]);
      });
      if (csvData.length < 2) {
        Fluttertoast.showToast(
            msg: 'No valid JSON blocks to generate CSV',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }

      final String csv = const ListToCsvConverter().convert(csvData);
      final bytes = utf8.encode(csv);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final html.AnchorElement anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "data.csv")
        ..click();

      html.Url.revokeObjectUrl(url); // Cleanup

      emit(state.copyWith(
        csvOutput: csv,
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Error: ${e.toString()}',
      ));
    }
  }

  bool checkIfCanGenerate() {
    List<bool> isValidOrEmpty = [];
    for (var i = 0; i < state.jsonDataList.length; i++) {
      if (state.jsonDataList[i].isJsonValid ||
          state.jsonDataList[i].textEditingController.text.isEmpty) {
        isValidOrEmpty.add(true);
      } else {
        isValidOrEmpty.add(false);
      }
    }
    return isValidOrEmpty.contains(false) ? false : true;
  }
}
