// To parse this JSON data, do
//
//     final systemsFiles = systemsFilesFromJson(jsonString);

import 'dart:convert';

SystemsFiles systemsFilesFromJson(String str) => SystemsFiles.fromJson(json.decode(str));

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
    files: json["files"] == null ? [] : List<SysFileElement>.from(json["files"]!.map((x) => SysFileElement.fromJson(x))),
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "dir": dir,
    "first": first,
    "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x.toJson())),
    "next": next,
  };
}

class SysFileElement {
  Type? type;
  String? name;
  int? size;
  DateTime? date;

  SysFileElement({
    this.type,
    this.name,
    this.size,
    this.date,
  });

  factory SysFileElement.fromJson(Map<String, dynamic> json) => SysFileElement(
    type: typeValues.map[json["type"]]!,
    name: json["name"],
    size: json["size"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "type": typeValues.reverse[type],
    "name": name,
    "size": size,
    "date": date?.toIso8601String(),
  };
}

enum Type { F }

final typeValues = EnumValues({
  "f": Type.F
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
