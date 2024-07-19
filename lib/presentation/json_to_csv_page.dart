import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization_webpage/business_logic/json_to_csv/json_to_csv_cubit.dart';
import 'package:localization_webpage/constants/constant_text.dart';
import 'dart:convert'; // For JSON parsing
import 'package:csv/csv.dart';
import 'package:localization_webpage/model/jsonWithDetailsModel.dart'; // For CSV conversion

class JsonToCsvPage extends StatefulWidget {
  const JsonToCsvPage({super.key});

  @override
  State<JsonToCsvPage> createState() => _JsonToCsvPageState();
}

class _JsonToCsvPageState extends State<JsonToCsvPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JsonToCsvCubit(),
      child: BlocBuilder<JsonToCsvCubit, JsonToCsvState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      context.read<JsonToCsvCubit>().addNewJsonBlock(),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Add Block'),
                      const SizedBox(width: 10),
                      Icon(Icons.add),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: ()=>
                      context.read<JsonToCsvCubit>().generateAndDownloadCsv(context),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Generate CSV'),
                      const SizedBox(width: 10),
                      Icon(Icons.file_download),
                    ],
                  ),
                ),
              ],
            ),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(ConstantText.jsonToCsvPageDescription),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        itemCount: state.jsonDataList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Stack(
                              children: [
                                TextField(
                                  controller: state.jsonDataList[index]
                                      .textEditingController,
                                  maxLines: 10,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'JSON Block ${index + 1}',
                                    hintText: """{"key":"value}""",
                                    errorText:
                                        state.jsonDataList[index].isJsonValid ||
                                                state
                                                    .jsonDataList[index]
                                                    .textEditingController
                                                    .text
                                                    .isEmpty
                                            ? null
                                            : 'Invalid JSON',
                                  ),
                                  onChanged: (value) => context
                                      .read<JsonToCsvCubit>()
                                      .checkValidity(state.jsonDataList[index]),
                                  enabled:
                                      !state.jsonDataList[index].isConfirmed,
                                ),
                                Positioned(
                                  right: 10,
                                  top: 10,
                                  child: Visibility(
                                    visible: state.jsonDataList[index]
                                        .textEditingController.text.isNotEmpty,
                                    child: Icon(
                                      state.jsonDataList[index].isJsonValid
                                          ? Icons.check_circle
                                          : Icons.error,
                                      color:
                                          state.jsonDataList[index].isJsonValid
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
