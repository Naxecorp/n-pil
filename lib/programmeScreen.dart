import 'dart:async';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'dart:js_util';

List<String> ProgramCurrent = <String>[];

TextEditingController controller = TextEditingController();

class ProgrammeScreen extends StatefulWidget {
  @override
  State<ProgrammeScreen> createState() => ProgrammeScreenState();
}

class ProgrammeScreenState extends State<ProgrammeScreen> {

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
    );
    if(result==null)return;
    Uint8List? fileBytes = result.files.first.bytes;
    print(String.fromCharCodes(fileBytes!));
    controller.text=String.fromCharCodes(fileBytes!);

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //color: Colors.redAccent.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          child: Text('Charger depuis PC'),
                          onPressed: () {
                            _pickFile();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2B879B)),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          child: Text('Charger depuis Liste Conversationel'),
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2B879B)),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          child: Text('Charger depuis SD'),
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2B879B)),
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 23,
                        child: Container(
                          height: double.infinity,
                        )),
                    Flexible(
                      flex: 4,
                      child: Container(
                        height: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          child: Text('Vider Programme'),
                          onPressed: () {
                            controller.clear();
                            controller.text = '';
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9B2B2B)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //color: Colors.redAccent.withOpacity(0.5),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(color: Colors.black)),
                  child: TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                    maxLines: 900000,
                    minLines: 100,
                    controller: controller,
                    //focusNode: FocusNode(),
                    //cursorColor: Colors.blue, backgroundCursorColor: Colors.white,
                  ),
                ),
              ),
            )),
        Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  //color: Colors.redAccent.withOpacity(0.5),
                  ),
            )),
        Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //color: Colors.redAccent.withOpacity(0.5),
                child: Column(
                  children: [
                    Flexible(
                      flex: 4,
                      child: Container(
                        height: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          child: Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                              ),
                              Flexible(
                                  flex: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Démarrer Cycle'),
                                  )),
                            ],
                          ),
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2B9B80)),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Container(
                        height: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          child: Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                              ),
                              Flexible(
                                  flex: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Pause Cycle'),
                                  )),
                            ],
                          ),
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2B519B)),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Container(
                        height: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          child: Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                              ),
                              Flexible(
                                  flex: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Stop Cycle'),
                                  )),
                            ],
                          ),
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFCE711A)),
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 13,
                        child: Container(
                          height: double.infinity,
                        ))
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
