// To parse this JSON data, do
//
//     final objectModelJob = objectModelJobFromJson(jsonString);

import 'dart:convert';

ObjectModelJob objectModelJobFromJson(String str) => ObjectModelJob.fromJson(json.decode(str));

String objectModelJobToJson(ObjectModelJob data) => json.encode(data.toJson());

class ObjectModelJob {
  String? key;
  String? flags;
  Result? result;

  ObjectModelJob({
    this.key,
    this.flags,
    this.result,
  });

  factory ObjectModelJob.fromJson(Map<String, dynamic> json) => ObjectModelJob(
    key: json["key"],
    flags: json["flags"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "flags": flags,
    "result": result?.toJson(),
  };
}

class Result {
  Build? build;
  int? duration;
  FileClass? file;
  int? filePosition;
  dynamic lastDuration;
  dynamic lastFileName;
  dynamic layer;
  dynamic layerTime;
  int? pauseDuration;
  int? rawExtrusion;
  TimesLeft? timesLeft;
  int? warmUpDuration;

  Result({
    this.build,
    this.duration,
    this.file,
    this.filePosition,
    this.lastDuration,
    this.lastFileName,
    this.layer,
    this.layerTime,
    this.pauseDuration,
    this.rawExtrusion,
    this.timesLeft,
    this.warmUpDuration,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    build: json["build"] == null ? null : Build.fromJson(json["build"]),
    duration: json["duration"],
    file: json["file"] == null ? null : FileClass.fromJson(json["file"]),
    filePosition: json["filePosition"],
    lastDuration: json["lastDuration"],
    lastFileName: json["lastFileName"],
    layer: json["layer"],
    layerTime: json["layerTime"],
    pauseDuration: json["pauseDuration"],
    rawExtrusion: json["rawExtrusion"],
    timesLeft: json["timesLeft"] == null ? null : TimesLeft.fromJson(json["timesLeft"]),
    warmUpDuration: json["warmUpDuration"],
  );

  Map<String, dynamic> toJson() => {
    "build": build?.toJson(),
    "duration": duration,
    "file": file?.toJson(),
    "filePosition": filePosition,
    "lastDuration": lastDuration,
    "lastFileName": lastFileName,
    "layer": layer,
    "layerTime": layerTime,
    "pauseDuration": pauseDuration,
    "rawExtrusion": rawExtrusion,
    "timesLeft": timesLeft?.toJson(),
    "warmUpDuration": warmUpDuration,
  };
}

class Build {
  int? currentObject;
  bool? m486Names;
  bool? m486Numbers;
  List<dynamic>? objects;

  Build({
    this.currentObject,
    this.m486Names,
    this.m486Numbers,
    this.objects,
  });

  factory Build.fromJson(Map<String, dynamic> json) => Build(
    currentObject: json["currentObject"],
    m486Names: json["m486Names"],
    m486Numbers: json["m486Numbers"],
    objects: json["objects"] == null ? [] : List<dynamic>.from(json["objects"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "currentObject": currentObject,
    "m486Names": m486Names,
    "m486Numbers": m486Numbers,
    "objects": objects == null ? [] : List<dynamic>.from(objects!.map((x) => x)),
  };
}

class FileClass {
  List<dynamic>? filament;
  String? fileName;
  dynamic generatedBy;
  double? height;
  DateTime? lastModified;
  int? layerHeight;
  int? numLayers;
  dynamic printTime;
  dynamic simulatedTime;
  int? size;
  List<dynamic>? thumbnails;

  FileClass({
    this.filament,
    this.fileName,
    this.generatedBy,
    this.height,
    this.lastModified,
    this.layerHeight,
    this.numLayers,
    this.printTime,
    this.simulatedTime,
    this.size,
    this.thumbnails,
  });

  factory FileClass.fromJson(Map<String, dynamic> json) => FileClass(
    filament: json["filament"] == null ? [] : List<dynamic>.from(json["filament"]!.map((x) => x)),
    fileName: json["fileName"],
    generatedBy: json["generatedBy"],
    height: json["height"]?.toDouble(),
    lastModified: json["lastModified"] == null ? null : DateTime.parse(json["lastModified"]),
    layerHeight: json["layerHeight"],
    numLayers: json["numLayers"],
    printTime: json["printTime"],
    simulatedTime: json["simulatedTime"],
    size: json["size"],
    thumbnails: json["thumbnails"] == null ? [] : List<dynamic>.from(json["thumbnails"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "filament": filament == null ? [] : List<dynamic>.from(filament!.map((x) => x)),
    "fileName": fileName,
    "generatedBy": generatedBy,
    "height": height,
    "lastModified": lastModified?.toIso8601String(),
    "layerHeight": layerHeight,
    "numLayers": numLayers,
    "printTime": printTime,
    "simulatedTime": simulatedTime,
    "size": size,
    "thumbnails": thumbnails == null ? [] : List<dynamic>.from(thumbnails!.map((x) => x)),
  };
}

class TimesLeft {
  dynamic filament;
  int? file;
  dynamic slicer;

  TimesLeft({
    this.filament,
    this.file,
    this.slicer,
  });

  factory TimesLeft.fromJson(Map<String, dynamic> json) => TimesLeft(
    filament: json["filament"],
    file: json["file"],
    slicer: json["slicer"],
  );

  Map<String, dynamic> toJson() => {
    "filament": filament,
    "file": file,
    "slicer": slicer,
  };
}
