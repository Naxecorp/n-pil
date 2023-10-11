// To parse this JSON data, do
//
//     final systemsFiles = systemsFilesFromJson(jsonString);

import 'dart:convert';

import 'EnumValues.dart';
import 'SystemsFilesElement.dart';

SystemsFiles systemsFilesFromJson(String str) =>
    SystemsFiles.fromJson(json.decode(str));

String systemsFilesToJson(SystemsFiles data) => json.encode(data.toJson());

class SystemsFiles {
  String? dir;
  int? first;
  List<SysFileElement>? files;
  int? next;

  SystemsFiles({
    this.dir,
    this.first,
    this.files,
    this.next,
  });

  factory SystemsFiles.fromJson(Map<String, dynamic> json) => SystemsFiles(
        dir: json["dir"],
        first: json["first"],
        files: json["files"] == null
            ? []
            : List<SysFileElement>.from(
                json["files"]!.map((x) => SysFileElement.fromJson(x))),
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "dir": dir,
        "first": first,
        "files": files == null
            ? []
            : List<dynamic>.from(files!.map((x) => x.toJson())),
        "next": next,
      };
}

enum Type { F }

final typeValues = EnumValues({"f": Type.F});
