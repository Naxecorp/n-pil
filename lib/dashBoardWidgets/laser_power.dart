import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:nweb/service/API/API_Manager.dart';

class LaserToolPower extends StatefulWidget {
  const LaserToolPower({super.key, this.child});

  final Widget? child;

  @override
  State<LaserToolPower> createState() => LaserToolPowerState();
}

class LaserToolPowerState extends State<LaserToolPower> {
  TextEditingController LaserValueController = TextEditingController();

  


  @override
  Widget build(BuildContext context) {
    //global.machineObjectModel.result?.move?.axes?.elementAt(0)!.machinePosition?.toStringAsFixed(2) ?? "...",
    return Center(
      child: Container(
          color: const Color(0xFFF0F0F3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: NeumorphicButton(
                          margin: const EdgeInsets.all(20),
                          style: NeumorphicStyle(
                            //depth: global.machineObjectModel.result!.spindles![0]!.current!>0?5:-5,//SpindleFanIsOn?-10:10,
                            color: const Color(0xFFF0F0F3),
                          ),
                          onPressed: () async {
                            await API_Manager().sendGcodeCommand('M98 P"laserOn.g"');
                            await API_Manager().sendrr_replyEveryIforD(800,3000);
                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.lightbulb,
                                  color: Color(0xFF707585),
                                ),
                                const FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      'On',
                                      style: TextStyle(color: Color(0xFF707585)),
                                    ))
                              ]),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: NeumorphicButton(
                          margin: const EdgeInsets.all(20),
                          style: NeumorphicStyle(
                            //depth: global.machineObjectModel.result!.spindles![0]!.current!>0?5:-5,//SpindleFanIsOn?-10:10,
                            color: const Color(0xFFF0F0F3),
                          ),
                          onPressed: () async {
                            await API_Manager().sendGcodeCommand('M98 P"laserOff.g"');
                            await API_Manager().sendrr_replyEveryIforD(800,3000);
                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.lightbulb_outlined,
                                  color: Color(0xFF707585),
                                ),
                                Text(
                                  'Off',
                                  style: TextStyle(color: Color(0xFF707585)),
                                )
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            ],
          )),
    );
    throw UnimplementedError();
  }
}
