part of 'json_to_csv_cubit.dart';

class JsonToCsvState {
  List<JsonWithDetailsModel> jsonDataList;
  bool canGenerate;
  String csvOutput;
  String error;

  JsonToCsvState({
    required this.jsonDataList,
    required this.canGenerate,
    required this.csvOutput,
    required this.error,
  });

  factory JsonToCsvState.initial() {
    return JsonToCsvState(
      jsonDataList: [emptyJsonWithDetailsModel],
      canGenerate: false,
      csvOutput: '',
      error: '',
    );
  }

  JsonToCsvState copyWith({
    List<JsonWithDetailsModel>? jsonDataList,
    bool? canGenerate,
    String? csvOutput,
    listLength,
    String? error,
  }) {
    return JsonToCsvState(
      jsonDataList: jsonDataList ?? this.jsonDataList,
      canGenerate: canGenerate ?? this.canGenerate,
      csvOutput: csvOutput ?? this.csvOutput,
      error: error ?? this.error,
    );
  }
}

