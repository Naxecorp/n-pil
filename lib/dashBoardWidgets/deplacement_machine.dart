import 'dart:async';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:nweb/widgetUtils/ArretUrgence.dart';
import '../../globals_var.dart' as global;
import 'package:nweb/service/API/API_Manager.dart';
import '../widgetUtils/Joystick/my_joystick.dart';
import '../widgetUtils/Joystick/my_joystick2.dart';

double stepValue = 0.1;

class DeplacementMachine extends StatefulWidget {
  const DeplacementMachine({super.key, this.child});

  final Widget? child;

  @override
  State<DeplacementMachine> createState() => _DeplacementMachine();
}

class _DeplacementMachine extends State<DeplacementMachine> {
  bool MovesWithoutEndstop = false;
  bool zCapteur = false;
  bool xCapteur = false;
  bool yCapteur = false;

  static const int _doorSeconds = 5;
  Timer? _doorTimer;
  int _doorRemaining = 0; // 0 = pas de countdown

  bool get _isDoorCountdown => _doorRemaining > 0;

  void _startDoorCountdown() {
    _doorTimer?.cancel();
    setState(() => _doorRemaining = _doorSeconds);

    _doorTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        _doorRemaining--;
        if (_doorRemaining <= 0) {
          _doorRemaining = 0;
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _doorTimer?.cancel();
    super.dispose();
  }

  void setTemperaturePopUp(BuildContext context, String heaterToSet) {
    TextEditingController _controllerTempe = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Programmer température :"),
          content: TextFormField(
            controller: _controllerTempe,
            onFieldSubmitted: (value) {
              if (heaterToSet == "head")
                API_Manager()
                    .sendGcodeCommand("M104 S$value")
                    .then((value) => API_Manager().sendrr_reply());
              if (heaterToSet == "bed")
                API_Manager()
                    .sendGcodeCommand("M140 S$value")
                    .then((value) => API_Manager().sendrr_reply());
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gpOut = global.machineObjectModel.result?.state?.gpOut;
    final isDoorOpenSignal =
        ((gpOut != null && gpOut.length > 2) ? (gpOut[2]?.pwm ?? 0) : 0) > 0;

    return Container(
      color: const Color(0xFFF0F0F3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          global.AdminLogged ? Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NeumorphicButton(
                    margin: const EdgeInsets.all(5),
                    style: const NeumorphicStyle(
                      color: Color(0xFFF0F0F3),
                    ),
                    onPressed: () {
                      API_Manager().sendGcodeCommand("M18 X");
                    },
                    child: Row(
                      children: [
                        Icon(Icons.power_off,color: Colors.deepOrange[200]),
                        Text("X")
                      ],
                    )),
                NeumorphicButton(
                    margin: const EdgeInsets.all(15),
                    style: const NeumorphicStyle(
                      color: Color(0xFFF0F0F3),
                    ),
                    onPressed: () {
                      API_Manager().sendGcodeCommand("M18 Y");
                    },
                    child: Row(
                      children: [
                        Icon(Icons.power_off,color: Colors.deepOrange[200]),
                        Text("Y")
                      ],
                    )),
                NeumorphicButton(
                    margin: const EdgeInsets.all(15),
                    style: const NeumorphicStyle(
                      color: Color(0xFFF0F0F3),
                    ),
                    onPressed: () {
                      API_Manager().sendGcodeCommand("M18 Z");
                    },
                    child: Row(
                      children: [
                        Icon(Icons.power_off,color: Colors.deepOrange[200]),
                        Text("Z")
                      ],
                    )),
              ],
            ),
          ):Container(),
          Flexible(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(2),
              //color: Colors.amber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 1,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                if (xCapteur ==
                                    true) // ajouter le lien avec les capteurs machine
                                  Container(
                                    width: 16,
                                    height: 13,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                  ),
                                NeumorphicButton(
                                  margin: const EdgeInsets.all(15),
                                  style: const NeumorphicStyle(
                                    color: Color(0xFFF0F0F3),
                                  ),
                                  onPressed: global.objectModelMove.result?.axes
                                              ?.elementAt(0)
                                              .homed ==
                                          false
                                      ? () async {
                                          await API_Manager()
                                              .sendGcodeCommand("G28 X");
                                        }
                                      : null,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.home_rounded,
                                        color: global
                                                    .machineObjectModel
                                                    .result
                                                    ?.sensors
                                                    ?.endstops?[0]!
                                                    .triggered ==
                                                true
                                            ? Colors.green
                                            : Colors.black87,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          'Axe X',
                                          style: TextStyle(
                                              color: Color(0xFF707585)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                if (yCapteur == true)
                                  Container(
                                    width: 16,
                                    height: 13,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                  ),
                                NeumorphicButton(
                                  margin: const EdgeInsets.all(15),
                                  style: const NeumorphicStyle(
                                    color: Color(0xFFF0F0F3),
                                  ),
                                  onPressed: global.objectModelMove.result?.axes
                                              ?.elementAt(1)
                                              .homed ==
                                          false
                                      ? () async {
                                          await API_Manager()
                                              .sendGcodeCommand("G28 Y");
                                        }
                                      : null,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.home_rounded,
                                        color: global
                                                    .machineObjectModel
                                                    .result
                                                    ?.sensors
                                                    ?.endstops?[1]!
                                                    .triggered ==
                                                true
                                            ? Colors.green
                                            : Colors.black87,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          'Axe Y',
                                          style: TextStyle(
                                              color: Color(0xFF707585)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                if (zCapteur == true)
                                  Container(
                                    width: 16,
                                    height: 13,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                  ),
                                // Bouton
                                NeumorphicButton(
                                  margin: const EdgeInsets.all(15),
                                  style: const NeumorphicStyle(
                                    color: Color(0xFFF0F0F3),
                                  ),
                                  onPressed: global.objectModelMove.result?.axes
                                              ?.elementAt(2)
                                              .homed ==
                                          false
                                      ? () async {
                                          await API_Manager()
                                              .sendGcodeCommand("G28 Z");
                                        }
                                      : null,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.home_rounded,
                                        color: global
                                                    .machineObjectModel
                                                    .result
                                                    ?.sensors
                                                    ?.endstops?[2]!
                                                    .triggered ==
                                                true
                                            ? Colors.green
                                            : Colors.black87,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          'Axe Z',
                                          style: TextStyle(
                                              color: Color(0xFF707585)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (((global.machineObjectModel.result?.move?.axes?.length) ?? 0) >=
              4)Flexible(
                          flex: 1,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                if (zCapteur == true)
                                  Container(
                                    width: 16,
                                    height: 13,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                  ),
                                // Bouton
                                NeumorphicButton(
                                  margin: const EdgeInsets.all(15),
                                  style: const NeumorphicStyle(
                                    color: Color(0xFFF0F0F3),
                                  ),
                                  onPressed: global.objectModelMove.result?.axes
                                              ?.elementAt(3)
                                              .homed ==
                                          false
                                      ? () async {
                                          await API_Manager()
                                              .sendGcodeCommand("G28 U");
                                        }
                                      : null,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.home_rounded,
                                        color: Colors.black87,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          'Axe U',
                                          style: TextStyle(
                                              color: Color(0xFF707585)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 1,
                          child: NeumorphicRadio(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            style: const NeumorphicRadioStyle(
                                shape: NeumorphicShape.convex,
                                unselectedColor: Color(0xFFF0F0F3)),
                            value: 0.01,
                            groupValue: stepValue,
                            onChanged: (double? value) {
                              setState(() {
                                stepValue = value!;
                              });
                            },
                            child: const Text(
                              "0.01",
                              style: TextStyle(color: Color(0xFF707585)),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: NeumorphicRadio(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            style: const NeumorphicRadioStyle(
                                shape: NeumorphicShape.convex,
                                unselectedColor: Color(0xFFF0F0F3)),
                            value: 0.1,
                            groupValue: stepValue,
                            onChanged: (double? value) {
                              setState(() {
                                stepValue = value!;
                              });
                            },
                            child: const Text(
                              "0.1",
                              style: TextStyle(color: Color(0xFF707585)),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: NeumorphicRadio(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            style: const NeumorphicRadioStyle(
                                shape: NeumorphicShape.convex,
                                unselectedColor: Color(0xFFF0F0F3)),
                            value: 1.0,
                            groupValue: stepValue,
                            onChanged: (double? value) {
                              setState(() {
                                stepValue = value!;
                              });
                            },
                            child: const Text("1",
                                style: TextStyle(color: Color(0xFF707585))),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: NeumorphicRadio(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            style: const NeumorphicRadioStyle(
                                shape: NeumorphicShape.convex,
                                unselectedColor: Color(0xFFF0F0F3)),
                            value: 10.0,
                            groupValue: stepValue,
                            onChanged: (double? value) {
                              setState(() {
                                stepValue = value!;
                              });
                            },
                            child: const Text("10",
                                style: TextStyle(color: Color(0xFF707585))),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: NeumorphicRadio(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            style: const NeumorphicRadioStyle(
                                shape: NeumorphicShape.convex,
                                unselectedColor: Color(0xFFF0F0F3)),
                            value: 50.0,
                            groupValue: stepValue,
                            onChanged: (double? value) {
                              setState(() {
                                stepValue = value!;
                              });
                            },
                            child: const Text("50",
                                style: TextStyle(color: Color(0xFF707585))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 3,
                  child: Container(
                    //color: Colors.green,
                    child: Joystick(
                      size: 70,
                      iconColor: const Color(0xFF707585),
                      onUpPressed: () async {
                        if (MovesWithoutEndstop)
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 Y$stepValue H2 F${global.SpeedValue}\nM121\n");
                        else
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 Y$stepValue F${global.SpeedValue}\nM121\n");
                        API_Manager().sendrr_reply();
                      },
                      onDownPressed: () async {
                        if (MovesWithoutEndstop)
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 H2 Y-$stepValue F${global.SpeedValue}\nM121\n");
                        else
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 Y-$stepValue F${global.SpeedValue}\nM121\n");
                        API_Manager().sendrr_reply();
                      },
                      onLeftPressed: () async {
                        if (MovesWithoutEndstop)
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 H2 X-$stepValue F${global.SpeedValue}\nM121\n");
                        else
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 X-$stepValue F${global.SpeedValue}\nM121\n");
                        API_Manager().sendrr_reply();
                      },
                      onRightPressed: () async {
                        if (MovesWithoutEndstop)
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 X$stepValue H2 F${global.SpeedValue}\nM121\n");
                        else
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 X$stepValue F${global.SpeedValue}\nM121\n");
                        API_Manager().sendrr_reply();
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Container(
                    child: Joystick2(
                      size: 70,
                      iconColor: const Color(0xFF707585),
                      onUpPressed: () async {
                        if (MovesWithoutEndstop)
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 H2 Z$stepValue F${global.SpeedValue}\nM121\n");
                        else
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 Z$stepValue F${global.SpeedValue}\nM121\n");
                        API_Manager().sendrr_reply();
                      },
                      onDownPressed: () async {
                        var Zstepdown;
                        if (stepValue > 10)
                          Zstepdown = 10;
                        else
                          Zstepdown = stepValue;
                        if (MovesWithoutEndstop)
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 H2 Z-$Zstepdown F${global.SpeedValue}\nM121\n");
                        else
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 Z-$Zstepdown F${global.SpeedValue}\nM121\n");
                        API_Manager().sendrr_reply();
                      },
                      onRotateALPressed: () async {
                        if (MovesWithoutEndstop)
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 U$stepValue H2 F${global.SpeedValue}\nM121\n");
                        else
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 U$stepValue F${global.SpeedValue}\nM121\n");
                        API_Manager().sendrr_reply();
                      },
                      onRotateARPressed: () async {
                        if (MovesWithoutEndstop)
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 U-$stepValue H2 F${global.SpeedValue}\nM121\n");
                        else
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 U-$stepValue F${global.SpeedValue}\nM121\n");
                        API_Manager().sendrr_reply();
                      },
                      onRotateCRPressed: () async {
                        if (MovesWithoutEndstop)
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 C$stepValue H2 F${global.SpeedValue}\nM121\n");
                        else
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 C$stepValue F${global.SpeedValue}\nM121\n");
                        API_Manager().sendrr_reply();
                      },
                      onRotateCLPressed: () async {
                        if (MovesWithoutEndstop)
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 C-$stepValue H2 F${global.SpeedValue}\nM121\n");
                        else
                          await API_Manager().sendGcodeCommand(
                              "M120\nG91\nG1 C-$stepValue F${global.SpeedValue}\nM121\n");
                        API_Manager().sendrr_reply();
                      },
                    ),
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: ListView(
                      children: [
                        global.MyMachineN02Config.HasLockOnEnclosure == 1
                            ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: NeumorphicButton(
                                    style: const NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: _isDoorCountdown ? null:(() async {
                                      if(global.AdminLogged){
                                        _startDoorCountdown();
                                        await API_Manager()
                                            .sendGcodeCommand('M42 P5 S1');
                                            await Future.delayed(Duration(seconds: 1));
                                            await API_Manager()
                                            .sendGcodeCommand('M42 P5 S0.5');
                                            await Future.delayed(Duration(seconds: 5));
                                            await API_Manager()
                                            .sendGcodeCommand('M42 P5 S1');
                                            await API_Manager()
                                            .sendGcodeCommand('M42 P5 S0');
                                            
                                      }
                                      else if((global.machineObjectModel.result?.spindles?[0].current??0) > 0) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("La broche doit être éteinte pour ouvrir la porte"),
                                            );
                                          },
                                        );
                                      }
                                      else if( await API_Manager().canUnlockDoorSafely() == true ){
                                        await API_Manager()
                                            .sendGcodeCommand('M98 P"opendoor.g"');
                                            _startDoorCountdown();
                                      }
                                      
                                      
                                    }),
                                    
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(_isDoorCountdown ? "Portes dévérouillées" : "Porte"),
                                        SizedBox(
                                          height: 34,
                                          width: 34,
                                          child: AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 200),
                                            child: _isDoorCountdown
                                                ? Stack(
                                                    key: const ValueKey('loader'),
                                                    alignment: Alignment.center,
                                                    children: [
                                                      CircularProgressIndicator(
                                                        strokeWidth: 3,
                                                        value: _doorRemaining / _doorSeconds, // 1 -> 0
                                                        color: Colors.green,
                                                      ),
                                                      Text(
                                                        '$_doorRemaining',
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ],
                                                  )
                                                : Icon(
                                                    Icons.sensor_door_rounded,
                                                    key: const ValueKey('icon'),
                                                    color: isDoorOpenSignal ? Colors.green : Colors.black,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: NeumorphicButton(
                              style: const NeumorphicStyle(
                                color: Color(0xFFF0F0F3),
                              ),
                              onPressed: global.machineObjectModel.result?.move
                                                  ?.axes
                                                  ?.elementAt(0)!
                                                  .machinePosition ==
                                              0.001 &&
                                          global.machineObjectModel.result?.move
                                                  ?.axes
                                                  ?.elementAt(1)!
                                                  .machinePosition ==
                                              550.0 &&
                                          global.machineObjectModel.result?.move
                                                  ?.axes
                                                  ?.elementAt(2)!
                                                  .machinePosition ==
                                              189.0 ||
                                      global.machineObjectModel.result?.state
                                              ?.status ==
                                          "processing"
                                  ? null
                                  : () {
                                      API_Manager().sendGcodeCommand(
                                          'M98 P"degagerTete.g"');
                                    },
                              child: const Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Dégager Tête."),
                                  Icon(Icons.north_west)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: NeumorphicButton(
                              style: const NeumorphicStyle(
                                color: Color(0xFFF0F0F3),
                              ),
                              onPressed: global.machineObjectModel.result?.move
                                                  ?.axes
                                                  ?.elementAt(0)!
                                                  .machinePosition ==
                                              0.001 &&
                                          global.machineObjectModel.result?.move
                                                  ?.axes
                                                  ?.elementAt(1)!
                                                  .machinePosition ==
                                              550.0 &&
                                          global.machineObjectModel.result?.move
                                                  ?.axes
                                                  ?.elementAt(2)!
                                                  .machinePosition ==
                                              189.0 ||
                                      global.machineObjectModel.result?.state
                                              ?.status ==
                                          "processing"
                                  ? null
                                  : () {
                                      API_Manager().sendGcodeCommand(
                                          'M98 P"front.g"');
                                    },
                              child: const Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Front."),
                                  Icon(Icons.south)
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        global.MyMachineN02Config.HasFanOnEnclosure == 1
                            ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: NeumorphicButton(
                                    style: const NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: () {
                                      if ((global.machineObjectModel.result
                                                  ?.fans?[4]!.actualValue ??
                                              0) >
                                          0)
                                        API_Manager()
                                            .sendGcodeCommand("M106 P4 S0")
                                            .then((value) {
                                          setState(() {});
                                        });
                                      else
                                        API_Manager()
                                            .sendGcodeCommand("M106 P4 S255")
                                            .then((value) {
                                          setState(() {});
                                        });
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Ventil."),
                                        Icon(Icons.air_sharp)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        global.MyMachineN02Config.HasLedOnEnclosure == 1
                            ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: NeumorphicButton(
                                    style: const NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: (() {
                                      if (((global.machineObjectModel.result?.state?.gpOut?[4]?.pwm) ?? 0)>0){
                                        API_Manager()
                                          .sendGcodeCommand("M42 P4 S0");
                                      }
                                      else
                                      API_Manager()
                                          .sendGcodeCommand("M42 P4 S1");
                                    }),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Eclaira."),
                                        Icon(Icons.light)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        global.MyMachineN02Config.HasHeatBed == 1
                            ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: NeumorphicButton(
                                    style: const NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: () {
                                      setTemperaturePopUp(context, "bed");
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Bed"),
                                        Text(global.machineObjectModel.result
                                                ?.heat?.heaters?[0].current
                                                .toString() ??
                                            "..." +
                                                "/ ${(global.machineObjectModel.result?.heat?.heaters?[0].standby) ?? 0}"),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    )),
              ],
            ),
          ),
          Flexible(
              flex: 3,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  //scrollDirection: Axis.horizontal,
                  children: [
                    global.AdminLogged == true
                        ? Container(
                            child: NeumorphicButton(
                              margin: const EdgeInsets.all(15),
                              style: NeumorphicStyle(
                                depth: MovesWithoutEndstop == true
                                    ? -5
                                    : 5, //SpindleFanIsOn?-10:10,
                                color: const Color(0xFFF0F0F3),
                              ),
                              onPressed: () {
                                setState(() {
                                  MovesWithoutEndstop = !MovesWithoutEndstop;
                                });
                              },
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(
                                      Icons.not_interested,
                                      color: Color(0xFF707585),
                                    ),
                                    const FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          'Fin de Courses',
                                          style: TextStyle(
                                              color: Color(0xFF707585)),
                                        ))
                                  ]),
                            ),
                          )
                        : Container(),
                    global.AdminLogged == true
                        ? Container(
                            child: NeumorphicButton(
                              margin: const EdgeInsets.all(15),
                              style: NeumorphicStyle(
                                color: const Color(0xFFF0F0F3),
                              ),
                              onPressed: () {
                                setState(() {
                                  API_Manager().sendGcodeCommand(
                                      "G53 G1 Y${global.objectModelMove.result!.axes![1].max} F${global.SpeedValue}");
                                });
                              },
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(
                                      Icons.arrow_drop_up,
                                      color: Color(0xFF707585),
                                    ),
                                    const FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          'Y max',
                                          style: TextStyle(
                                              color: Color(0xFF707585)),
                                        ))
                                  ]),
                            ),
                          )
                        : Container(),
                    global.AdminLogged == true
                        ? Container(
                            child: NeumorphicButton(
                              margin: const EdgeInsets.all(15),
                              style: NeumorphicStyle(
                                color: const Color(0xFFF0F0F3),
                              ),
                              onPressed: () {
                                setState(() {
                                  API_Manager().sendGcodeCommand(
                                      "G53 G1 Y0 F${global.SpeedValue}");
                                });
                              },
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: Color(0xFF707585),
                                    ),
                                    const FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          'Y Zero',
                                          style: TextStyle(
                                              color: Color(0xFF707585)),
                                        ))
                                  ]),
                            ),
                          )
                        : Container(),
                    global.AdminLogged == true
                        ? Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    "Accel: ${global.objectModelMove.result?.axes?[1].acceleration}"),
                                NeumorphicButton(
                                  margin: const EdgeInsets.all(5),
                                  style: NeumorphicStyle(
                                    color: const Color(0xFFF0F0F3),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      var accel = global.objectModelMove.result
                                          ?.axes?[1].acceleration;
                                      accel = accel! + 10;
                                      API_Manager().sendGcodeCommand(
                                          "M201 Y${accel} \n");
                                    });
                                  },
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          color: Color(0xFF707585),
                                        ),
                                        const FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              'Acceleration',
                                              style: TextStyle(
                                                  color: Color(0xFF707585)),
                                            ))
                                      ]),
                                ),
                                NeumorphicButton(
                                  margin: const EdgeInsets.all(5),
                                  style: NeumorphicStyle(
                                    color: const Color(0xFFF0F0F3),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (global.Accel > 10)
                                        global.Accel = global.Accel - 10;
                                      API_Manager().sendGcodeCommand(
                                          "M201 Y${global.Accel} \n");
                                    });
                                  },
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(
                                          Icons.remove,
                                          color: Color(0xFF707585),
                                        ),
                                        const FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              'Acceleration',
                                              style: TextStyle(
                                                  color: Color(0xFF707585)),
                                            ))
                                      ]),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    global.AdminLogged == true
                        ? Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Speed: ${global.SpeedValue}"),
                                NeumorphicButton(
                                  margin: const EdgeInsets.all(5),
                                  style: NeumorphicStyle(
                                    color: const Color(0xFFF0F0F3),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      global.SpeedValue =
                                          global.SpeedValue + 100;
                                      API_Manager().sendGcodeCommand(
                                          "M203 Y${global.SpeedValue} \n");
                                    });
                                  },
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          color: Color(0xFF707585),
                                        ),
                                        const FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              'Vit. max',
                                              style: TextStyle(
                                                  color: Color(0xFF707585)),
                                            ))
                                      ]),
                                ),
                                NeumorphicButton(
                                  margin: const EdgeInsets.all(5),
                                  style: NeumorphicStyle(
                                    color: const Color(0xFFF0F0F3),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (global.SpeedValue > 100)
                                        global.SpeedValue =
                                            global.SpeedValue - 100;
                                      API_Manager().sendGcodeCommand(
                                          "M203 Y${global.SpeedValue} \n");
                                    });
                                  },
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(
                                          Icons.remove,
                                          color: Color(0xFF707585),
                                        ),
                                        const FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              'Vit. max',
                                              style: TextStyle(
                                                  color: Color(0xFF707585)),
                                            ))
                                      ]),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    global.AdminLogged == true
                        ? Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Jerk: " + global.Jerk.toStringAsFixed(1)),
                                NeumorphicButton(
                                  margin: const EdgeInsets.all(5),
                                  style: NeumorphicStyle(
                                    color: const Color(0xFFF0F0F3),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (global.Jerk >= 50)
                                        global.Jerk = global.Jerk + 50;
                                      else
                                        global.Jerk = global.Jerk + 1;

                                      API_Manager().sendGcodeCommand("M566 X" +
                                          global.Jerk.toStringAsFixed(1) +
                                          " Y" +
                                          global.Jerk.toStringAsFixed(1) +
                                          "\n");
                                    });
                                  },
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          color: Color(0xFF707585),
                                        ),
                                        const FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              'Vit. max',
                                              style: TextStyle(
                                                  color: Color(0xFF707585)),
                                            ))
                                      ]),
                                ),
                                NeumorphicButton(
                                  margin: const EdgeInsets.all(5),
                                  style: NeumorphicStyle(
                                    color: const Color(0xFFF0F0F3),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (global.Jerk <= 50) {
                                        if (global.Jerk > 1)
                                          global.Jerk = global.Jerk - 1;
                                      } else
                                        global.Jerk = global.Jerk - 50;

                                      API_Manager().sendGcodeCommand("M566 X" +
                                          global.Jerk.toStringAsFixed(1) +
                                          " Y" +
                                          global.Jerk.toStringAsFixed(1) +
                                          "\n");
                                    });
                                  },
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(
                                          Icons.remove,
                                          color: Color(0xFF707585),
                                        ),
                                        const FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              'Vit. max',
                                              style: TextStyle(
                                                  color: Color(0xFF707585)),
                                            ))
                                      ]),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    const Spacer(),
                    Container(
                      width: 200,
                      child: ArretUrgence(
                        notifyParent: () {},
                      ),
                    ),
                  ],
                ),
              ))
          
        ],
      ),
    );
    throw UnimplementedError();
  }
}
