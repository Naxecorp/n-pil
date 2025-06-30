import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../globals_var.dart' as global;
import '../service/API/API_Manager.dart';

class ResponsiveImageGrid extends StatefulWidget {
  const ResponsiveImageGrid({super.key});

  @override
  State<ResponsiveImageGrid> createState() => _ResponsiveImageGridState();
}

class _ResponsiveImageGridState extends State<ResponsiveImageGrid> {
  final ValueNotifier<bool> isPalpeurTriggered = ValueNotifier(false);
  Timer? _palpeurUpdateTimer;

  @override
  void initState() {
    super.initState();
    _palpeurUpdateTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      final sensorValue = global.machineObjectModel.result?.sensors?.probes?[0].value?[0] ?? 0;
      isPalpeurTriggered.value = sensorValue > 900;
    });
  }

  @override
  void dispose() {
    _palpeurUpdateTimer?.cancel();
    isPalpeurTriggered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 200;
        final maxHeight = constraints.maxHeight;

        return Center(
          child: Container(
            width: isWide ? 900 : constraints.maxWidth,
            height: maxHeight,
            padding: const EdgeInsets.all(12.0),
            child: isWide
                ? Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: Center(
                            child: ValueListenableBuilder<bool>(
                              valueListenable: isPalpeurTriggered,
                              builder: (context, triggered, _) {
                                return SvgPicture.asset(
                                  triggered
                                      ? "assets/Palpeur triggered.svg"
                                      : "assets/Palpeur untriggered.svg",
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.contain,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: buildRightSide(context),
                      ),
                    ],
                  )
                : buildNarrowColumn(),
          ),
        );
      },
    );
  }

  Widget buildRightSide(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: NeumorphicButton(
                    style: const NeumorphicStyle(color: Color(0xFFF0F0F3)),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: Text('Palpage outil 1'),
                          content: Row(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 16),
                              Expanded(child: Text('Durée max 60s')),
                            ],
                          ),
                        ),
                      );
                      await API_Manager().sendGcodeCommand('M98 P"palper1.g"');
                      await API_Manager().waitUntilMachineIsStill(
                        stableDuration: Duration(seconds: 3),
                        maxWait: Duration(seconds: 60),
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.looks_one_outlined, color: Color(0xFF707585)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: NeumorphicButton(
                    style: const NeumorphicStyle(color: Color(0xFFF0F0F3)),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: Text('Palpage outil 2'),
                          content: Row(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 16),
                              Expanded(child: Text('Durée max 60s')),
                            ],
                          ),
                        ),
                      );
                      await API_Manager().sendGcodeCommand('M98 P"palper2.g"');
                      await API_Manager().waitUntilMachineIsStill(
                        stableDuration: Duration(seconds: 3),
                        maxWait: Duration(seconds: 60),
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.looks_two_outlined, color: Color(0xFF707585)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: NeumorphicButton(
                    style: const NeumorphicStyle(color: Color(0xFFF0F0F3)),
                    child: const Center(child: Text("Vers palpeur")),
                    onPressed: () async {
                      ValueNotifier<List<double>> currentPos = ValueNotifier([0.0, 0.0]);
                      final targetX = global.MyMachineN02Config.Palpeur?.PosX ?? 0.0;
                      final targetY = global.MyMachineN02Config.Palpeur?.PosY ?? 0.0;

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return ValueListenableBuilder<List<double>>(
                                valueListenable: currentPos,
                                builder: (context, value, _) {
                                  return AlertDialog(
                                    title: const Text('Déplacement en cours'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CircularProgressIndicator(),
                                        const SizedBox(height: 16),
                                        Text('🟢 Position cible : X=${targetX.toStringAsFixed(2)}, Y=${targetY.toStringAsFixed(2)}'),
                                        const SizedBox(height: 8),
                                        Text('📍 Position actuelle : X=${value[0].toStringAsFixed(2)}, Y=${value[1].toStringAsFixed(2)}'),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );

                      bool running = true;
                      Timer.periodic(const Duration(milliseconds: 250), (timer) {
                        final axes = global.machineObjectModel.result?.move?.axes;
                        if (!running || axes == null || axes.length < 2) return;
                        final posX = double.tryParse(axes[0].machinePosition?.toString() ?? '') ?? 0.0;
                        final posY = double.tryParse(axes[1].machinePosition?.toString() ?? '') ?? 0.0;
                        currentPos.value = [posX, posY];
                      });

                      bool success = await API_Manager().moveToPositionAndConfirm(
                        x: targetX,
                        y: targetY,
                        z: 189,
                      );

                      running = false;
                      Navigator.of(context).pop();

                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erreur : la machine n’a pas atteint la position.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: NeumorphicButton(
                    style: const NeumorphicStyle(color: Color(0xFFF0F0F3)),
                    child: const Center(
                      child: Text("Palpage direct", maxLines: 2, overflow: TextOverflow.fade, softWrap: true, textAlign: TextAlign.center),
                    ),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          content: Row(
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(width: 20),
                              Expanded(child: Text("Palpage en cours...")),
                            ],
                          ),
                        ),
                      );
                      bool MachineSuccessToBeStable = false;
                      try {
                        await API_Manager().sendGcodeCommand("G38.2 Z-200 F100");
                        MachineSuccessToBeStable = await API_Manager().waitUntilMachineIsStill(
                          stableDuration: Duration(seconds: 3),
                          maxWait: Duration(seconds: 50),
                        );
                        if (MachineSuccessToBeStable) await API_Manager().sendGcodeCommand("G10 L20 P1 Z${global.MyMachineN02Config.Palpeur?.Height ?? 33}");
                        if (MachineSuccessToBeStable) await API_Manager().sendGcodeCommand("G91 \n G54 \n G91 \n G1 Z5 F3700 \n G90");
                        if (MachineSuccessToBeStable) await API_Manager().waitUntilMachineIsStill(maxWait: Duration(seconds: 30));
                      } catch (e) {
                        print("Erreur pendant le palpage : \$e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("❌ Palpage erreur \$e"), duration: Duration(seconds: 2)),
                        );
                      } finally {
                        Navigator.of(context).pop();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ Palpage terminé"), duration: Duration(seconds: 2)),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: NeumorphicButton(
                    style: const NeumorphicStyle(color: Color(0xFFF0F0F3)),
                    child: const Center(child: Text("Répéta.")),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: Text('Test de répétabilité'),
                          content: Row(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 16),
                              Expanded(child: Text('Durée estimée : 2 minutes')),
                            ],
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Démarrage du fichier repet.g.'),
                            backgroundColor: Color.fromARGB(255, 34, 34, 34),
                          ),
                        );
                      await API_Manager().sendGcodeCommand('M98 P"repet.g"');
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('On attend que la machine soit immobile pendant 5 secondes'),
                            backgroundColor: Color.fromARGB(255, 34, 34, 34),
                          ),
                        );
                      await API_Manager().waitUntilMachineIsStill(
                        stableDuration: Duration(seconds: 5),
                        maxWait: Duration(minutes: 2),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildNarrowColumn() {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: ValueListenableBuilder<bool>(
            valueListenable: isPalpeurTriggered,
            builder: (context, triggered, _) {
              return SvgPicture.asset(
                triggered ? "assets/Palpeur triggered.svg" : "assets/Palpeur untriggered.svg",
                fit: BoxFit.contain,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(child: Container(color: Colors.grey[400])),
              const SizedBox(width: 8),
              Expanded(child: Container(color: Colors.grey[400])),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(child: Container(color: Colors.grey[500])),
              const SizedBox(width: 8),
              Expanded(child: Container(color: Colors.grey[500])),
              const SizedBox(width: 8),
              Expanded(child: Container(color: Colors.grey[500])),
            ],
          ),
        ),
      ],
    );
  }
}
