import 'dart:convert';


class GcodeProgram {

  String path = "toto";
  double size = 0;
  String name = "tata";

}


ReturnedListGcodeProgram returnedListGcodeProgramFromJson(String str) => ReturnedListGcodeProgram.fromJson(json.decode(str));


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

  factory ReturnedListGcodeProgram.fromJson(Map<String, dynamic> json) => ReturnedListGcodeProgram(
    dir: json["dir"],
    first: json["first"],
    files: json["files"] == null ? [] : json["files"] == null ? [] : List<FileElement?>.from(json["files"]!.map((x) => FileElement.fromJson(x))),
    next: json["next"],
  );

}

class FileElement {
  FileElement({
    this.type,
    this.name,
    this.size,
    this.date,
  });

  String? type;
  String? name;
  int? size;
  String? date;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    type: json["type"],
    name: json["name"],
    size: json["size"],
    date: json["date"],
  );

}
