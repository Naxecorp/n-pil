// To parse this JSON data, do
//
//     final machineObjectModel = machineObjectModelFromJson(jsonString);

import 'dart:convert';

MachineObjectModel machineObjectModelFromJson(String str) => MachineObjectModel.fromJson(json.decode(str));


class MachineObjectModel {
    String? key;
    String? flags;
    Result? result;

    MachineObjectModel({
        this.key,
        this.flags,
        this.result,
    });

    factory MachineObjectModel.fromRawJson(String str) => MachineObjectModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MachineObjectModel.fromJson(Map<String, dynamic> json) => MachineObjectModel(
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
    List<Board>? boards;
    List<Fan?>? fans;
    Heat? heat;
    List<Input>? inputs;
    Job? job;
    Move? move;
    Sensors? sensors;
    Seqs? seqs;
    List<Spindle>? spindles;
    State? state;
    List<Tool>? tools;

    Result({
        this.boards,
        this.fans,
        this.heat,
        this.inputs,
        this.job,
        this.move,
        this.sensors,
        this.seqs,
        this.spindles,
        this.state,
        this.tools,
    });

    factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        boards: json["boards"] == null ? [] : List<Board>.from(json["boards"]!.map((x) => Board.fromJson(x))),
        fans: json["fans"] == null ? [] : List<Fan?>.from(json["fans"]!.map((x) => x == null ? null : Fan.fromJson(x))),
        heat: json["heat"] == null ? null : Heat.fromJson(json["heat"]),
        inputs: json["inputs"] == null ? [] : List<Input>.from(json["inputs"]!.map((x) => Input.fromJson(x))),
        job: json["job"] == null ? null : Job.fromJson(json["job"]),
        move: json["move"] == null ? null : Move.fromJson(json["move"]),
        sensors: json["sensors"] == null ? null : Sensors.fromJson(json["sensors"]),
        seqs: json["seqs"] == null ? null : Seqs.fromJson(json["seqs"]),
        spindles: json["spindles"] == null ? [] : List<Spindle>.from(json["spindles"]!.map((x) => Spindle.fromJson(x))),
        state: json["state"] == null ? null : State.fromJson(json["state"]),
        tools: json["tools"] == null ? [] : List<Tool>.from(json["tools"]!.map((x) => Tool.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "boards": boards == null ? [] : List<dynamic>.from(boards!.map((x) => x.toJson())),
        "fans": fans == null ? [] : List<dynamic>.from(fans!.map((x) => x?.toJson())),
        "heat": heat?.toJson(),
        "inputs": inputs == null ? [] : List<dynamic>.from(inputs!.map((x) => x.toJson())),
        "job": job?.toJson(),
        "move": move?.toJson(),
        "sensors": sensors?.toJson(),
        "seqs": seqs?.toJson(),
        "spindles": spindles == null ? [] : List<dynamic>.from(spindles!.map((x) => x.toJson())),
        "state": state?.toJson(),
        "tools": tools == null ? [] : List<dynamic>.from(tools!.map((x) => x.toJson())),
    };
}

class Board {
    McuTemp? mcuTemp;
    McuTemp? v12;
    McuTemp? vIn;

    Board({
        this.mcuTemp,
        this.v12,
        this.vIn,
    });

    factory Board.fromRawJson(String str) => Board.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Board.fromJson(Map<String, dynamic> json) => Board(
        mcuTemp: json["mcuTemp"] == null ? null : McuTemp.fromJson(json["mcuTemp"]),
        v12: json["v12"] == null ? null : McuTemp.fromJson(json["v12"]),
        vIn: json["vIn"] == null ? null : McuTemp.fromJson(json["vIn"]),
    );

    Map<String, dynamic> toJson() => {
        "mcuTemp": mcuTemp?.toJson(),
        "v12": v12?.toJson(),
        "vIn": vIn?.toJson(),
    };
}

class McuTemp {
    double? current;

    McuTemp({
        this.current,
    });

    factory McuTemp.fromRawJson(String str) => McuTemp.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory McuTemp.fromJson(Map<String, dynamic> json) => McuTemp(
        current: json["current"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "current": current,
    };
}

class Fan {
    num? actualValue;
    num? requestedValue;
    num? rpm;

    Fan({
        this.actualValue,
        this.requestedValue,
        this.rpm,
    });

    factory Fan.fromRawJson(String str) => Fan.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Fan.fromJson(Map<String, dynamic> json) => Fan(
        actualValue: json["actualValue"],
        requestedValue: json["requestedValue"],
        rpm: json["rpm"],
    );

    Map<String, dynamic> toJson() => {
        "actualValue": actualValue,
        "requestedValue": requestedValue,
        "rpm": rpm,
    };
}

class Heat {
    List<Heater>? heaters;

    Heat({
        this.heaters,
    });

    factory Heat.fromRawJson(String str) => Heat.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Heat.fromJson(Map<String, dynamic> json) => Heat(
        heaters: json["heaters"] == null ? [] : List<Heater>.from(json["heaters"]!.map((x) => Heater.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "heaters": heaters == null ? [] : List<dynamic>.from(heaters!.map((x) => x.toJson())),
    };
}

class Heater {
    num? active;
    num? avgPwm;
    double? current;
    num? standby;
    String? state;

    Heater({
        this.active,
        this.avgPwm,
        this.current,
        this.standby,
        this.state,
    });

    factory Heater.fromRawJson(String str) => Heater.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Heater.fromJson(Map<String, dynamic> json) => Heater(
        active: json["active"],
        avgPwm: json["avgPwm"],
        current: json["current"]?.toDouble(),
        standby: json["standby"],
        state: json["state"],
    );

    Map<String, dynamic> toJson() => {
        "active": active,
        "avgPwm": avgPwm,
        "current": current,
        "standby": standby,
        "state": state,
    };
}

class Input {
    num? feedRate;
    bool? inMacro;
    num? lineNumber;
    Stat? state;

    Input({
        this.feedRate,
        this.inMacro,
        this.lineNumber,
        this.state,
    });

    factory Input.fromRawJson(String str) => Input.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Input.fromJson(Map<String, dynamic> json) => Input(
        feedRate: json["feedRate"],
        inMacro: json["inMacro"],
        lineNumber: json["lineNumber"],
        state: statValues.map[json["state"]]!,
    );

    Map<String, dynamic> toJson() => {
        "feedRate": feedRate,
        "inMacro": inMacro,
        "lineNumber": lineNumber,
        "state": statValues.reverse[state],
    };
}

enum Stat {
    IDLE
}

final statValues = EnumValues({
    "idle": Stat.IDLE
});

class Job {
    dynamic build;
    dynamic duration;
    num? filePosition;
    dynamic layer;
    dynamic layerTime;
    dynamic pauseDuration;
    dynamic rawExtrusion;
    TimesLeft? timesLeft;
    dynamic warmUpDuration;

    Job({
        this.build,
        this.duration,
        this.filePosition,
        this.layer,
        this.layerTime,
        this.pauseDuration,
        this.rawExtrusion,
        this.timesLeft,
        this.warmUpDuration,
    });

    factory Job.fromRawJson(String str) => Job.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Job.fromJson(Map<String, dynamic> json) => Job(
        build: json["build"],
        duration: json["duration"],
        filePosition: json["filePosition"],
        layer: json["layer"],
        layerTime: json["layerTime"],
        pauseDuration: json["pauseDuration"],
        rawExtrusion: json["rawExtrusion"],
        timesLeft: json["timesLeft"] == null ? null : TimesLeft.fromJson(json["timesLeft"]),
        warmUpDuration: json["warmUpDuration"],
    );

    Map<String, dynamic> toJson() => {
        "build": build,
        "duration": duration,
        "filePosition": filePosition,
        "layer": layer,
        "layerTime": layerTime,
        "pauseDuration": pauseDuration,
        "rawExtrusion": rawExtrusion,
        "timesLeft": timesLeft?.toJson(),
        "warmUpDuration": warmUpDuration,
    };
}

class TimesLeft {
    dynamic filament;
    dynamic file;
    dynamic slicer;

    TimesLeft({
        this.filament,
        this.file,
        this.slicer,
    });

    factory TimesLeft.fromRawJson(String str) => TimesLeft.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

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

class Move {
    List<Axe>? axes;
    CurrentMove? currentMove;
    List<Extruder>? extruders;
    num? virtualEPos;

    Move({
        this.axes,
        this.currentMove,
        this.extruders,
        this.virtualEPos,
    });

    factory Move.fromRawJson(String str) => Move.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Move.fromJson(Map<String, dynamic> json) => Move(
        axes: json["axes"] == null ? [] : List<Axe>.from(json["axes"]!.map((x) => Axe.fromJson(x))),
        currentMove: json["currentMove"] == null ? null : CurrentMove.fromJson(json["currentMove"]),
        extruders: json["extruders"] == null ? [] : List<Extruder>.from(json["extruders"]!.map((x) => Extruder.fromJson(x))),
        virtualEPos: json["virtualEPos"],
    );

    Map<String, dynamic> toJson() => {
        "axes": axes == null ? [] : List<dynamic>.from(axes!.map((x) => x.toJson())),
        "currentMove": currentMove?.toJson(),
        "extruders": extruders == null ? [] : List<dynamic>.from(extruders!.map((x) => x.toJson())),
        "virtualEPos": virtualEPos,
    };
}

class Axe {
    double? machinePosition;
    double? userPosition;

    Axe({
        this.machinePosition,
        this.userPosition,
    });

    factory Axe.fromRawJson(String str) => Axe.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Axe.fromJson(Map<String, dynamic> json) => Axe(
        machinePosition: json["machinePosition"]?.toDouble(),
        userPosition: json["userPosition"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "machinePosition": machinePosition,
        "userPosition": userPosition,
    };
}

class CurrentMove {
    num? acceleration;
    num? deceleration;
    dynamic laserPwm;
    num? requestedSpeed;
    num? topSpeed;

    CurrentMove({
        this.acceleration,
        this.deceleration,
        this.laserPwm,
        this.requestedSpeed,
        this.topSpeed,
    });

    factory CurrentMove.fromRawJson(String str) => CurrentMove.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CurrentMove.fromJson(Map<String, dynamic> json) => CurrentMove(
        acceleration: json["acceleration"],
        deceleration: json["deceleration"],
        laserPwm: json["laserPwm"],
        requestedSpeed: json["requestedSpeed"],
        topSpeed: json["topSpeed"],
    );

    Map<String, dynamic> toJson() => {
        "acceleration": acceleration,
        "deceleration": deceleration,
        "laserPwm": laserPwm,
        "requestedSpeed": requestedSpeed,
        "topSpeed": topSpeed,
    };
}

class Extruder {
    num? position;
    num? rawPosition;

    Extruder({
        this.position,
        this.rawPosition,
    });

    factory Extruder.fromRawJson(String str) => Extruder.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Extruder.fromJson(Map<String, dynamic> json) => Extruder(
        position: json["position"],
        rawPosition: json["rawPosition"],
    );

    Map<String, dynamic> toJson() => {
        "position": position,
        "rawPosition": rawPosition,
    };
}

class Sensors {
    List<Analog>? analog;
    List<Endstop>? endstops;
    List<dynamic>? filamentMonitors;
    List<GpIn?>? gpIn;
    List<Probe>? probes;

    Sensors({
        this.analog,
        this.endstops,
        this.filamentMonitors,
        this.gpIn,
        this.probes,
    });

    factory Sensors.fromRawJson(String str) => Sensors.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Sensors.fromJson(Map<String, dynamic> json) => Sensors(
        analog: json["analog"] == null ? [] : List<Analog>.from(json["analog"]!.map((x) => Analog.fromJson(x))),
        endstops: json["endstops"] == null ? [] : List<Endstop>.from(json["endstops"]!.map((x) => Endstop.fromJson(x))),
        filamentMonitors: json["filamentMonitors"] == null ? [] : List<dynamic>.from(json["filamentMonitors"]!.map((x) => x)),
        gpIn: json["gpIn"] == null ? [] : List<GpIn?>.from(json["gpIn"]!.map((x) => x == null ? null : GpIn.fromJson(x))),
        probes: json["probes"] == null ? [] : List<Probe>.from(json["probes"]!.map((x) => Probe.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "analog": analog == null ? [] : List<dynamic>.from(analog!.map((x) => x.toJson())),
        "endstops": endstops == null ? [] : List<dynamic>.from(endstops!.map((x) => x.toJson())),
        "filamentMonitors": filamentMonitors == null ? [] : List<dynamic>.from(filamentMonitors!.map((x) => x)),
        "gpIn": gpIn == null ? [] : List<dynamic>.from(gpIn!.map((x) => x?.toJson())),
        "probes": probes == null ? [] : List<dynamic>.from(probes!.map((x) => x.toJson())),
    };
}

class Analog {
    double? lastReading;

    Analog({
        this.lastReading,
    });

    factory Analog.fromRawJson(String str) => Analog.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Analog.fromJson(Map<String, dynamic> json) => Analog(
        lastReading: json["lastReading"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lastReading": lastReading,
    };
}

class Endstop {
    bool? triggered;

    Endstop({
        this.triggered,
    });

    factory Endstop.fromRawJson(String str) => Endstop.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Endstop.fromJson(Map<String, dynamic> json) => Endstop(
        triggered: json["triggered"],
    );

    Map<String, dynamic> toJson() => {
        "triggered": triggered,
    };
}

class GpIn {
    num? value;

    GpIn({
        this.value,
    });

    factory GpIn.fromRawJson(String str) => GpIn.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GpIn.fromJson(Map<String, dynamic> json) => GpIn(
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
    };
}

class Probe {
    List<int>? value;

    Probe({
        this.value,
    });

    factory Probe.fromRawJson(String str) => Probe.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Probe.fromJson(Map<String, dynamic> json) => Probe(
        value: json["value"] == null ? [] : List<int>.from(json["value"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "value": value == null ? [] : List<dynamic>.from(value!.map((x) => x)),
    };
}

class Seqs {
    num? boards;
    num? directories;
    num? fans;
    num? global;
    num? heat;
    num? inputs;
    num? job;
    num? move;
    num? network;
    num? reply;
    num? sensors;
    num? spindles;
    num? state;
    num? tools;
    List<int>? volChanges;
    num? volumes;

    Seqs({
        this.boards,
        this.directories,
        this.fans,
        this.global,
        this.heat,
        this.inputs,
        this.job,
        this.move,
        this.network,
        this.reply,
        this.sensors,
        this.spindles,
        this.state,
        this.tools,
        this.volChanges,
        this.volumes,
    });

    factory Seqs.fromRawJson(String str) => Seqs.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Seqs.fromJson(Map<String, dynamic> json) => Seqs(
        boards: json["boards"],
        directories: json["directories"],
        fans: json["fans"],
        global: json["global"],
        heat: json["heat"],
        inputs: json["inputs"],
        job: json["job"],
        move: json["move"],
        network: json["network"],
        reply: json["reply"],
        sensors: json["sensors"],
        spindles: json["spindles"],
        state: json["state"],
        tools: json["tools"],
        volChanges: json["volChanges"] == null ? [] : List<int>.from(json["volChanges"]!.map((x) => x)),
        volumes: json["volumes"],
    );

    Map<String, dynamic> toJson() => {
        "boards": boards,
        "directories": directories,
        "fans": fans,
        "global": global,
        "heat": heat,
        "inputs": inputs,
        "job": job,
        "move": move,
        "network": network,
        "reply": reply,
        "sensors": sensors,
        "spindles": spindles,
        "state": state,
        "tools": tools,
        "volChanges": volChanges == null ? [] : List<dynamic>.from(volChanges!.map((x) => x)),
        "volumes": volumes,
    };
}

class Spindle {
    num? current;
    String? state;

    Spindle({
        this.current,
        this.state,
    });

    factory Spindle.fromRawJson(String str) => Spindle.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Spindle.fromJson(Map<String, dynamic> json) => Spindle(
        current: json["current"],
        state: json["state"],
    );

    Map<String, dynamic> toJson() => {
        "current": current,
        "state": state,
    };
}

class State {
    num? currentTool;
    List<GpOut?>? gpOut;
    dynamic laserPwm;
    num? msUpTime;
    Stat? status;
    dynamic time;
    num? upTime;

    State({
        this.currentTool,
        this.gpOut,
        this.laserPwm,
        this.msUpTime,
        this.status,
        this.time,
        this.upTime,
    });

    factory State.fromRawJson(String str) => State.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory State.fromJson(Map<String, dynamic> json) => State(
        currentTool: json["currentTool"],
        gpOut: json["gpOut"] == null ? [] : List<GpOut?>.from(json["gpOut"]!.map((x) => x == null ? null : GpOut.fromJson(x))),
        laserPwm: json["laserPwm"],
        msUpTime: json["msUpTime"],
        status: statValues.map[json["status"]]!,
        time: json["time"],
        upTime: json["upTime"],
    );

    Map<String, dynamic> toJson() => {
        "currentTool": currentTool,
        "gpOut": gpOut == null ? [] : List<dynamic>.from(gpOut!.map((x) => x?.toJson())),
        "laserPwm": laserPwm,
        "msUpTime": msUpTime,
        "status": statValues.reverse[status],
        "time": time,
        "upTime": upTime,
    };
}

class GpOut {
    num? pwm;

    GpOut({
        this.pwm,
    });

    factory GpOut.fromRawJson(String str) => GpOut.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GpOut.fromJson(Map<String, dynamic> json) => GpOut(
        pwm: json["pwm"],
    );

    Map<String, dynamic> toJson() => {
        "pwm": pwm,
    };
}

class Tool {
    List<dynamic>? active;
    bool? isRetracted;
    List<dynamic>? standby;
    String? state;

    Tool({
        this.active,
        this.isRetracted,
        this.standby,
        this.state,
    });

    factory Tool.fromRawJson(String str) => Tool.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Tool.fromJson(Map<String, dynamic> json) => Tool(
        active: json["active"] == null ? [] : List<dynamic>.from(json["active"]!.map((x) => x)),
        isRetracted: json["isRetracted"],
        standby: json["standby"] == null ? [] : List<dynamic>.from(json["standby"]!.map((x) => x)),
        state: json["state"],
    );

    Map<String, dynamic> toJson() => {
        "active": active == null ? [] : List<dynamic>.from(active!.map((x) => x)),
        "isRetracted": isRetracted,
        "standby": standby == null ? [] : List<dynamic>.from(standby!.map((x) => x)),
        "state": state,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}


