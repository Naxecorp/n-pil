import 'dart:convert';

import 'gCodeProgram.dart';

ReturnedListGcodeProgram returnedListGcodeProgramFromJson(String str) =>
    ReturnedListGcodeProgram.fromJson(json.decode(str));

class ReturnedListGcodeProgram {
  ReturnedListGcodeProgram({
    this.dir,
    this.first,
    this.files,
    this.next,
  });

  String? dir;
  int? first;
  List<FileElement?>? files;
  int? next;

  factory ReturnedListGcodeProgram.fromJson(Map<String, dynamic> json) =>
      ReturnedListGcodeProgram(
        dir: json["dir"],
        first: json["first"],
        files: json["files"] == null
            ? []
            : json["files"] == null
                ? []
                : List<FileElement?>.from(
                    json["files"]!.map((x) => FileElement.fromJson(x))),
        next: json["next"],
      );
}
