// To parse this JSON data, do
//
//     final objectModelMove = objectModelMoveFromJson(jsonString);

import 'dart:convert';

ObjectModelMove objectModelMoveFromJson(String str) => ObjectModelMove.fromJson(json.decode(str));



class ObjectModelMove {
  ObjectModelMove({
    this.key,
    this.flags,
    this.result,
  });

  String? key;
  String? flags;
  Result? result;

  factory ObjectModelMove.fromJson(Map<String, dynamic> json) => ObjectModelMove(
    key: json["key"] == null ? null : json["key"],
    flags: json["flags"] == null ? null : json["flags"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );


}

class Result {
  Result({
    this.axes,
    this.calibration,
    this.compensation,
    this.currentMove,
    this.extruders,
    this.idle,
    this.kinematics,
    this.limitAxes,
    this.noMovesBeforeHoming,
    this.prdoubleingAcceleration,
    this.queue,
    this.rotation,
    this.shaping,
    this.speedFactor,
    this.travelAcceleration,
    this.virtualEPos,
    this.workplaceNumber,
  });

  List<Axe>? axes;
  Calibration? calibration;
  Compensation? compensation;
  CurrentMove? currentMove;
  List<Extruder>? extruders;
  Idle? idle;
  Kinematics? kinematics;
  bool? limitAxes;
  bool? noMovesBeforeHoming;
  num? prdoubleingAcceleration;
  List<Queue>? queue;
  Rotation? rotation;
  Shaping? shaping;
  num? speedFactor;
  num? travelAcceleration;
  num? virtualEPos;
  num? workplaceNumber;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    axes: json["axes"] == null ? null : List<Axe>.from(json["axes"].map((x) => Axe.fromJson(x))),
    calibration: json["calibration"] == null ? null : Calibration.fromJson(json["calibration"]),
    compensation: json["compensation"] == null ? null : Compensation.fromJson(json["compensation"]),
    currentMove: json["currentMove"] == null ? null : CurrentMove.fromJson(json["currentMove"]),
    extruders: json["extruders"] == null ? null : List<Extruder>.from(json["extruders"].map((x) => Extruder.fromJson(x))),
    idle: json["idle"] == null ? null : Idle.fromJson(json["idle"]),
    kinematics: json["kinematics"] == null ? null : Kinematics.fromJson(json["kinematics"]),
    limitAxes: json["limitAxes"] == null ? null : json["limitAxes"],
    noMovesBeforeHoming: json["noMovesBeforeHoming"] == null ? null : json["noMovesBeforeHoming"],
    prdoubleingAcceleration: json["prdoubleingAcceleration"] == null ? null : json["prdoubleingAcceleration"],
    queue: json["queue"] == null ? null : List<Queue>.from(json["queue"].map((x) => Queue.fromJson(x))),
    rotation: json["rotation"] == null ? null : Rotation.fromJson(json["rotation"]),
    shaping: json["shaping"] == null ? null : Shaping.fromJson(json["shaping"]),
    speedFactor: json["speedFactor"] == null ? null : json["speedFactor"],
    travelAcceleration: json["travelAcceleration"] == null ? null : json["travelAcceleration"],
    virtualEPos: json["virtualEPos"] == null ? null : json["virtualEPos"],
    workplaceNumber: json["workplaceNumber"] == null ? null : json["workplaceNumber"],
  );


}

class Axe {
  Axe({
    this.acceleration,
    this.babystep,
    this.current,
    this.drivers,
    this.homed,
    this.jerk,
    this.letter,
    this.machinePosition,
    this.max,
    this.maxProbed,
    this.microstepping,
    this.min,
    this.minProbed,
    this.percentCurrent,
    this.percentStstCurrent,
    this.speed,
    this.stepsPerMm,
    this.userPosition,
    this.visible,
    this.workplaceOffsets,
  });

  num? acceleration;
  num? babystep;
  num? current;
  List<String>? drivers;
  bool? homed;
  num? jerk;
  String? letter;
  num? machinePosition;
  num? max;
  bool? maxProbed;
  Microstepping? microstepping;
  num? min;
  bool? minProbed;
  num? percentCurrent;
  num? percentStstCurrent;
  num? speed;
  num? stepsPerMm;
  num? userPosition;
  bool? visible;
  List<num>? workplaceOffsets;

  factory Axe.fromJson(Map<String, dynamic> json) => Axe(
    acceleration: json["acceleration"] == null ? null : json["acceleration"],
    babystep: json["babystep"] == null ? null : json["babystep"],
    current: json["current"] == null ? null : json["current"],
    drivers: json["drivers"] == null ? null : List<String>.from(json["drivers"].map((x) => x)),
    homed: json["homed"] == null ? null : json["homed"],
    jerk: json["jerk"] == null ? null : json["jerk"],
    letter: json["letter"] == null ? null : json["letter"],
    machinePosition: json["machinePosition"] == null ? null : json["machinePosition"],
    max: json["max"] == null ? null : json["max"],
    maxProbed: json["maxProbed"] == null ? null : json["maxProbed"],
    microstepping: json["microstepping"] == null ? null : Microstepping.fromJson(json["microstepping"]),
    min: json["min"] == null ? null : json["min"],
    minProbed: json["minProbed"] == null ? null : json["minProbed"],
    percentCurrent: json["percentCurrent"] == null ? null : json["percentCurrent"],
    percentStstCurrent: json["percentStstCurrent"] == null ? null : json["percentStstCurrent"],
    speed: json["speed"] == null ? null : json["speed"],
    stepsPerMm: json["stepsPerMm"] == null ? null : json["stepsPerMm"],
    userPosition: json["userPosition"] == null ? null : json["userPosition"],
    visible: json["visible"] == null ? null : json["visible"],
    workplaceOffsets: json["workplaceOffsets"] == null ? null : List<num>.from(json["workplaceOffsets"].map((x) => x)),
  );


}

class Microstepping {
  Microstepping({
    this.doubleerpolated,
    this.value,
  });

  bool? doubleerpolated;
  num? value;

  factory Microstepping.fromJson(Map<String, dynamic> json) => Microstepping(
    doubleerpolated: json["doubleerpolated"] == null ? null : json["doubleerpolated"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "doubleerpolated": doubleerpolated == null ? null : doubleerpolated,
    "value": value == null ? null : value,
  };
}

class Calibration {
  Calibration({
    this.calibrationFinal,
    this.initial,
    this.numFactors,
  });

  Final? calibrationFinal;
  Final? initial;
  num? numFactors;

  factory Calibration.fromJson(Map<String, dynamic> json) => Calibration(
    calibrationFinal: json["final"] == null ? null : Final.fromJson(json["final"]),
    initial: json["initial"] == null ? null : Final.fromJson(json["initial"]),
    numFactors: json["numFactors"] == null ? null : json["numFactors"],
  );

}

class Final {
  Final({
    this.deviation,
    this.mean,
  });

  num? deviation;
  num? mean;

  factory Final.fromJson(Map<String, dynamic> json) => Final(
    deviation: json["deviation"] == null ? null : json["deviation"],
    mean: json["mean"] == null ? null : json["mean"],
  );

  Map<String, dynamic> toJson() => {
    "deviation": deviation == null ? null : deviation,
    "mean": mean == null ? null : mean,
  };
}

class Compensation {
  Compensation({
    this.fadeHeight,
    this.file,
    this.liveGrid,
    this.meshDeviation,
    this.probeGrid,
    this.skew,
    this.type,
  });

  dynamic fadeHeight;
  dynamic file;
  dynamic liveGrid;
  dynamic meshDeviation;
  ProbeGrid? probeGrid;
  Skew? skew;
  String? type;

  factory Compensation.fromJson(Map<String, dynamic> json) => Compensation(
    fadeHeight: json["fadeHeight"],
    file: json["file"],
    liveGrid: json["liveGrid"],
    meshDeviation: json["meshDeviation"],
    probeGrid: json["probeGrid"] == null ? null : ProbeGrid.fromJson(json["probeGrid"]),
    skew: json["skew"] == null ? null : Skew.fromJson(json["skew"]),
    type: json["type"] == null ? null : json["type"],
  );

}

class ProbeGrid {
  ProbeGrid({
    this.axes,
    this.maxs,
    this.mins,
    this.radius,
    this.spacings,
  });

  List<String>? axes;
  List<num>? maxs;
  List<num>? mins;
  num? radius;
  List<num>? spacings;

  factory ProbeGrid.fromJson(Map<String, dynamic> json) => ProbeGrid(
    axes: json["axes"] == null ? null : List<String>.from(json["axes"].map((x) => x)),
    maxs: json["maxs"] == null ? null : List<num>.from(json["maxs"].map((x) => x)),
    mins: json["mins"] == null ? null : List<num>.from(json["mins"].map((x) => x)),
    radius: json["radius"] == null ? null : json["radius"],
    spacings: json["spacings"] == null ? null : List<num>.from(json["spacings"].map((x) => x)),
  );


}

class Skew {
  Skew({
    this.compensateXy,
    this.tanXy,
    this.tanXz,
    this.tanYz,
  });

  bool? compensateXy;
  num? tanXy;
  num? tanXz;
  num? tanYz;

  factory Skew.fromJson(Map<String, dynamic> json) => Skew(
    compensateXy: json["compensateXY"] == null ? null : json["compensateXY"],
    tanXy: json["tanXY"] == null ? null : json["tanXY"],
    tanXz: json["tanXZ"] == null ? null : json["tanXZ"],
    tanYz: json["tanYZ"] == null ? null : json["tanYZ"],
  );


}

class CurrentMove {
  CurrentMove({
    this.acceleration,
    this.deceleration,
    this.laserPwm,
    this.requestedSpeed,
    this.topSpeed,
  });

  num? acceleration;
  num? deceleration;
  dynamic? laserPwm;
  num? requestedSpeed;
  num? topSpeed;

  factory CurrentMove.fromJson(Map<String, dynamic> json) => CurrentMove(
    acceleration: json["acceleration"] == null ? null : json["acceleration"],
    deceleration: json["deceleration"] == null ? null : json["deceleration"],
    laserPwm: json["laserPwm"],
    requestedSpeed: json["requestedSpeed"] == null ? null : json["requestedSpeed"],
    topSpeed: json["topSpeed"] == null ? null : json["topSpeed"],
  );

  Map<String, dynamic> toJson() => {
    "acceleration": acceleration == null ? null : acceleration,
    "deceleration": deceleration == null ? null : deceleration,
    "laserPwm": laserPwm,
    "requestedSpeed": requestedSpeed == null ? null : requestedSpeed,
    "topSpeed": topSpeed == null ? null : topSpeed,
  };
}

class Extruder {
  Extruder({
    this.acceleration,
    this.current,
    this.driver,
    this.factor,
    this.filament,
    this.jerk,
    this.microstepping,
    this.nonlinear,
    this.percentCurrent,
    this.percentStstCurrent,
    this.position,
    this.pressureAdvance,
    this.rawPosition,
    this.speed,
    this.stepsPerMm,
  });

  num? acceleration;
  num? current;
  String? driver;
  num? factor;
  String? filament;
  num? jerk;
  Microstepping? microstepping;
  Nonlinear? nonlinear;
  num? percentCurrent;
  num? percentStstCurrent;
  num? position;
  num? pressureAdvance;
  num?rawPosition;
  num? speed;
  num? stepsPerMm;

  factory Extruder.fromJson(Map<String, dynamic> json) => Extruder(
    acceleration: json["acceleration"] == null ? null : json["acceleration"],
    current: json["current"] == null ? null : json["current"],
    driver: json["driver"] == null ? null : json["driver"],
    factor: json["factor"] == null ? null : json["factor"],
    filament: json["filament"] == null ? null : json["filament"],
    jerk: json["jerk"] == null ? null : json["jerk"],
    microstepping: json["microstepping"] == null ? null : Microstepping.fromJson(json["microstepping"]),
    nonlinear: json["nonlinear"] == null ? null : Nonlinear.fromJson(json["nonlinear"]),
    percentCurrent: json["percentCurrent"] == null ? null : json["percentCurrent"],
    percentStstCurrent: json["percentStstCurrent"] == null ? null : json["percentStstCurrent"],
    position: json["position"] == null ? null : json["position"],
    pressureAdvance: json["pressureAdvance"] == null ? null : json["pressureAdvance"],
    rawPosition: json["rawPosition"] == null ? null : json["rawPosition"],
    speed: json["speed"] == null ? null : json["speed"],
    stepsPerMm: json["stepsPerMm"] == null ? null : json["stepsPerMm"],
  );


}

class Nonlinear {
  Nonlinear({
    this.a,
    this.b,
    this.upperLimit,
  });

  num? a;
  num? b;
  num? upperLimit;

  factory Nonlinear.fromJson(Map<String, dynamic> json) => Nonlinear(
    a: json["a"] == null ? null : json["a"],
    b: json["b"] == null ? null : json["b"],
    upperLimit: json["upperLimit"] == null ? null : json["upperLimit"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "a": a == null ? null : a,
    "b": b == null ? null : b,
    "upperLimit": upperLimit == null ? null : upperLimit,
  };
}

class Idle {
  Idle({
    this.factor,
    this.timeout,
  });

  num? factor;
  num? timeout;

  factory Idle.fromJson(Map<String, dynamic> json) => Idle(
    factor: json["factor"] == null ? null : json["factor"].toDouble(),
    timeout: json["timeout"] == null ? null : json["timeout"],
  );

  Map<String, dynamic> toJson() => {
    "factor": factor == null ? null : factor,
    "timeout": timeout == null ? null : timeout,
  };
}

class Kinematics {
  Kinematics({
    this.forwardMatrix,
    this.inverseMatrix,
    this.name,
    this.tiltCorrection,
    this.segmentation,
  });

  List<List<num>>? forwardMatrix;
  List<List<num>>? inverseMatrix;
  String? name;
  TiltCorrection? tiltCorrection;
  dynamic? segmentation;

  factory Kinematics.fromJson(Map<String, dynamic> json) => Kinematics(
    forwardMatrix: json["forwardMatrix"] == null ? null : List<List<num>>.from(json["forwardMatrix"].map((x) => List<num>.from(x.map((x) => x)))),
    inverseMatrix: json["inverseMatrix"] == null ? null : List<List<num>>.from(json["inverseMatrix"].map((x) => List<num>.from(x.map((x) => x)))),
    name: json["name"] == null ? null : json["name"],
    tiltCorrection: json["tiltCorrection"] == null ? null : TiltCorrection.fromJson(json["tiltCorrection"]),
    segmentation: json["segmentation"],
  );

}

class TiltCorrection {
  TiltCorrection({
    this.correctionFactor,
    this.lastCorrections,
    this.maxCorrection,
    this.screwPitch,
    this.screwX,
    this.screwY,
  });

  num? correctionFactor;
  List<dynamic>? lastCorrections;
  num? maxCorrection;
  num? screwPitch;
  List<dynamic>? screwX;
  List<dynamic>? screwY;

  factory TiltCorrection.fromJson(Map<String, dynamic> json) => TiltCorrection(
    correctionFactor: json["correctionFactor"] == null ? null : json["correctionFactor"],
    lastCorrections: json["lastCorrections"] == null ? null : List<dynamic>.from(json["lastCorrections"].map((x) => x)),
    maxCorrection: json["maxCorrection"] == null ? null : json["maxCorrection"],
    screwPitch: json["screwPitch"] == null ? null : json["screwPitch"].toDouble(),
    screwX: json["screwX"] == null ? null : List<dynamic>.from(json["screwX"].map((x) => x)),
    screwY: json["screwY"] == null ? null : List<dynamic>.from(json["screwY"].map((x) => x)),
  );


}

class Queue {
  Queue({
    this.gracePeriod,
    this.length,
  });

  num? gracePeriod;
  num? length;

  factory Queue.fromJson(Map<String, dynamic> json) => Queue(
    gracePeriod: json["gracePeriod"] == null ? null : json["gracePeriod"].toDouble(),
    length: json["length"] == null ? null : json["length"],
  );

  Map<String, dynamic> toJson() => {
    "gracePeriod": gracePeriod == null ? null : gracePeriod,
    "length": length == null ? null : length,
  };
}

class Rotation {
  Rotation();

  factory Rotation.fromJson(Map<String, dynamic> json) => Rotation(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Shaping {
  Shaping({
    this.amplitudes,
    this.damping,
    this.durations,
    this.frequency,
    this.minAcceleration,
    this.type,
  });

  List<dynamic>? amplitudes;
  num? damping;
  List<dynamic>? durations;
  num? frequency;
  num? minAcceleration;
  String? type;

  factory Shaping.fromJson(Map<String, dynamic> json) => Shaping(
    amplitudes: json["amplitudes"] == null ? null : List<dynamic>.from(json["amplitudes"].map((x) => x)),
    damping: json["damping"] == null ? null : json["damping"].toDouble(),
    durations: json["durations"] == null ? null : List<dynamic>.from(json["durations"].map((x) => x)),
    frequency: json["frequency"] == null ? null : json["frequency"],
    minAcceleration: json["minAcceleration"] == null ? null : json["minAcceleration"],
    type: json["type"] == null ? null : json["type"],
  );


}
