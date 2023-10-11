import 'dart:convert';

import 'EnumValues.dart';
import 'SystemsFiles.dart';

enum Type { F }

final typeValues = EnumValues({"f": Type.F});

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
