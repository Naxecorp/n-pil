import 'dart:convert';

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
