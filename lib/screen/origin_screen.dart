import 'dart:async';
import 'package:flutter/services.dart';
import 'package:nweb/dashBoardWidgets/palpeur_layout.dart';
import 'package:nweb/main.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/nwc-settings/nwc-settings.dart';
import 'package:nweb/service/nwc-settings/offset.dart';
import '../widgetUtils/window.dart';
import '../globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../menus/side_menu.dart';


TextEditingController ManualGcodeComand = TextEditingController();

class Offset extends StatefulWidget {
  final VoidCallback? onClickOnSet;
  final TextEditingController? decalX;
  final TextEditingController? decalY;
  final TextEditingController? decalZ;
  final String? offsetName;
  Offset(
      {super.key,
      this.onClickOnSet,
      this.decalX,
      this.decalY,
      this.decalZ,
      this.offsetName});

  @override
  State<Offset> createState() =>
      _OffsetState(onClickOnSet, decalX, decalY, decalZ, offsetName);
}

class _OffsetState extends State<Offset> {
  final VoidCallback? _onClickOnSet;
  final TextEditingController? _decalX;
  final TextEditingController? _decalY;
  final TextEditingController? _decalZ;
  final String? _offsetName;
  _OffsetState(this._onClickOnSet, this._decalX, this._decalY, this._decalZ,
      this._offsetName);

  @override
  void dispose() {
    super.dispose();
  }

  int? valueOfDataTable = 5;

  @override
  void initState() {
    global.checkAndShowDialog(context);
    Future.delayed(const Duration(seconds: 2), () {
      if (global.MyMachineN02Config.HasFanOnEnclosure == 1)
        global.checkCaissonOpen(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text("${_offsetName} :"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "X",
                      style: TextStyle(
                          color: Color(0xFF707585),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                    // color: Colors.greenAccent,
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'-?[0-9]+[.]{0,1}[0-9]*')),
                        TextInputFormatter.withFunction(
                          (oldValue, newValue) => newValue.copyWith(
                            text: newValue.text.replaceAll('.', '.'),
                          ),
                        ),
                      ], // saisie de nombres uniquement
                      controller: _decalX,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          gapPadding: 5.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Y",
                      style: TextStyle(
                          color: Color(0xFF707585),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                    //color: Colors.greenAccent,
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'-?[0-9]+[.]{0,1}[0-9]*')),
                        TextInputFormatter.withFunction(
                          (oldValue, newValue) => newValue.copyWith(
                            text: newValue.text.replaceAll('.', '.'),
                          ),
                        ),
                      ], // saisie de nombres uniquement
                      controller: _decalY,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          gapPadding: 5.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Z",
                      style: TextStyle(
                          color: Color(0xFF707585),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                    //color: Colors.greenAccent,
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'-?[0-9]+[.]{0,1}[0-9]*')),
                        TextInputFormatter.withFunction(
                          (oldValue, newValue) => newValue.copyWith(
                            text: newValue.text.replaceAll('.', '.'),
                          ),
                        ),
                      ], // saisie de nombres uniquement
                      controller: _decalZ,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          gapPadding: 5.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        width: MediaQuery.of(context).size.width * 0.13,
                        child: NeumorphicButton(
                          onPressed: () {
                            return _onClickOnSet!();
                          },
                          style: const NeumorphicStyle(
                            color: Color(0xFFF0F0F3),
                          ),
                          child: const Text(
                            "Sauvegarder",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF707585),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        width: MediaQuery.of(context).size.width * 0.13,
                        child: NeumorphicButton(
                          onPressed: () async {
                            String? userPosX = global
                                    .machineObjectModel.result?.move?.axes
                                    ?.elementAt(0)!
                                    .userPosition!
                                    .toString() ??
                                "0";
                            String? userPosY = global
                                    .machineObjectModel.result?.move?.axes
                                    ?.elementAt(1)!
                                    .userPosition!
                                    .toString() ??
                                "0";
                            String? userPosZ = global
                                    .machineObjectModel.result?.move?.axes
                                    ?.elementAt(2)
                                    .userPosition
                                    .toString() ??
                                "0";
                            await API_Manager()
                                .sendGcodeCommand(
                                    "G10 L20 P1 X${double.parse(userPosX) + double.parse(_decalX!.text)} Y${double.parse(userPosY) + double.parse(_decalY!.text)} Z${double.parse(userPosZ) + double.parse(_decalZ!.text)}")
                                .then(
                                  (value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Positions utilisateur modifiées'),
                                      duration: Duration(milliseconds: 1000),
                                    ),
                                  ),
                                );
                          },
                          style: const NeumorphicStyle(
                            color: Color(0xFFF0F0F3),
                          ),
                          child: const Text(
                            "Appliquer",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF707585),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 150,
              )
            ],
          ),
        ],
      ),
    );
    throw UnimplementedError();
  }
}

class OriginScreen extends StatefulWidget {
  OriginScreen({super.key, required this.notifyParent});

  final VoidCallback notifyParent;

  @override
  State<OriginScreen> createState() => OriginScreenState(notifyParent);
}

class OriginScreenState extends State<OriginScreen> {
  OriginScreenState(this.notifyParent);

  final Function() notifyParent;

  double ZSaved = 0;

  @override
  void initState() {
    super.initState();
    pageToShow = 6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(
        onAnyTap: () {
          setState(() {});
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF20917F)),
        backgroundColor: Color(0xFFF0F0F3),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                flex: 2,
                child: Container(
                    child: Image(image: AssetImage("assets/iconnaxe.png")))),
            Flexible(
              flex: 10,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                      width: 300,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: ManualGcodeComand,
                            decoration: InputDecoration(
                              hintText: "Gcode",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gapPadding: 5.0,
                              ),
                            ),
                            onSubmitted: (Commande) {
                              setState(() {
                                global.commandHistory.add(Commande);
                                ManualGcodeComand.clear();
                                API_Manager().sendGcodeCommand(Commande).then(
                                    (value) => API_Manager().sendrr_reply());
                              });
                            },
                          ),
                          PopupMenuButton<String>(
                            tooltip: "Historique",
                            icon: Icon(Icons.arrow_drop_down),
                            onSelected: (String value) {
                              setState(() {
                                ManualGcodeComand.text = value;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return global.commandHistory
                                  .map<PopupMenuItem<String>>((String value) {
                                return PopupMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      global.Title,
                      style: TextStyle(color: Color(0xFF707585)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Window(
                      title1: "Mesure Hauteur",
                      title2: " fraise",
                      child: ResponsiveImageGrid()
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Window(
                        title1: "Palpage",
                        title2: " Pièce",
                        child: ButtonLayout()),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Window(
                title1: "Offset",
                title2: " outils",
                child: Column(
                  children: [
                    Flexible(
                      flex: 4,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: ListView.builder(
                        itemCount:
                            global.MyMachineN02Config.Offset?.length ?? 1,
                        itemBuilder: (BuildContext context, int index) {
                          TextEditingController controllerPosX =
                              TextEditingController();
                          TextEditingController controllerPosY =
                              TextEditingController();
                          TextEditingController controllerPosZ =
                              TextEditingController();
                          if (global.MyMachineN02Config.Offset != null &&
                              index <
                                  global.MyMachineN02Config.Offset!.length) {
                            controllerPosX.text = global
                                    .MyMachineN02Config.Offset![index].DecalX
                                    ?.toString() ??
                                '';
                            controllerPosY.text = global
                                    .MyMachineN02Config.Offset![index].DecalY
                                    ?.toString() ??
                                '';
                            controllerPosZ.text = global
                                    .MyMachineN02Config.Offset![index].DecalZ
                                    ?.toString() ??
                                '';
                          }
                          return Offset(
                            decalX: controllerPosX,
                            decalY: controllerPosY,
                            decalZ: controllerPosZ,
                            offsetName:
                                global.MyMachineN02Config.Offset![index].Name,
                            onClickOnSet: () {
                              global.MyMachineN02Config.Offset?[index] =
                                  Offsets(
                                Name: global
                                    .MyMachineN02Config.Offset![index].Name,
                                DecalX: double.tryParse(controllerPosX!.text),
                                DecalY: double.tryParse(controllerPosY!.text),
                                DecalZ: double.tryParse(controllerPosZ!.text),
                              );
                              API_Manager().upLoadAFile(
                                "0:/sys/nwc-settings.json",
                                global.MyMachineN02Config.toJson()
                                    .length
                                    .toString(),
                                Uint8List.fromList(machineN02ConfigToJson(
                                        global.MyMachineN02Config)
                                    .codeUnits),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    '${global.MyMachineN02Config.Offset![index].Name} enregistrée'),
                                duration: const Duration(milliseconds: 1000),
                              ));
                            },
                          );
                        },
                      ),
                    ),
                    
                    Flexible(
                      flex: 4,
                      child: Container(
                        height: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Window(
                title1: "Tableau",
                title2: " outils",
                child: Column(
                  children: [
                    Flexible(
                      flex: 4,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    // Flexible(
                    //   flex: 5,
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           RichText(
                    //             text: const TextSpan(
                    //               text: "Outil actuel : ",
                    //               style: TextStyle(color: Colors.black),
                    //               children: <TextSpan>[
                    //                 TextSpan(
                    //                   text: "1",
                    //                   style: TextStyle(
                    //                       fontWeight: FontWeight.bold),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(height: 10.0),
                    //       const Divider(
                    //         height: 20,
                    //         thickness: 0.8,
                    //         color: Colors.grey,
                    //         indent: 20,
                    //         endIndent: 20,
                    //       ),
                    //       const SizedBox(height: 10.0),
                    //       Expanded(
                    //         child: SingleChildScrollView(
                    //           scrollDirection: Axis.horizontal,
                    //           child: DataTable(
                    //             columns: const [
                    //               DataColumn(label: Text('N°')),
                    //               DataColumn(label: Text('Nom de l\'outil')),
                    //               DataColumn(label: Text('Longueur')),
                    //               DataColumn(label: Text('Diamètre')),
                    //               DataColumn(label: Text('Actions')),
                    //             ],
                    //             rows: List<DataRow>.generate(
                    //                 global.magasinOutil.outil?.length ?? 0,
                    //                 (index) {
                    //               return DataRow(
                    //                 cells: [
                    //                   DataCell(Text("${index + 1}")),
                    //                   DataCell(Text(global.magasinOutil
                    //                           .outil?[index].name ??
                    //                       "0")),
                    //                   DataCell(Text(
                    //                       '${global.magasinOutil.outil?[index].diametre ?? 0} mm')),
                    //                   DataCell(Text(
                    //                       '${global.magasinOutil.outil?[index].hauteur ?? 0} mm')),
                    //                   DataCell(
                    //                     Row(
                    //                       children: [
                    //                         IconButton(
                    //                           onPressed: () {
                    //                             API_Manager().sendGcodeCommand(
                    //                                 "T${index + 1}");
                    //                           },
                    //                           icon: const Icon(
                    //                               Icons.swap_vert_rounded),
                    //                           iconSize: 24.0,
                    //                           color: Colors.blue,
                    //                         ),
                    //                         const Padding(
                    //                           padding: EdgeInsets.all(2.0),
                    //                         ),
                    //                         IconButton(
                    //                           onPressed: () {},
                    //                           icon: const Icon(Icons.edit),
                    //                           iconSize: 24.0,
                    //                           color: Colors.orange,
                    //                         ),
                    //                         const Padding(
                    //                           padding: EdgeInsets.all(2.0),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               );
                    //             }),
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Flexible(child: Container(child :Center(child: Text("Tableau d'outil à venir"),)),flex: 5,),
                    SizedBox(height: 40,),
                    Align(alignment: AlignmentGeometry.centerLeft, child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Aller chercher :",style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20 ),),
                    )),
                    SizedBox(height: 20,),
                    Flexible(flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      NeumorphicButton(child: Text("T1",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25 ),),onPressed: ()async {
                        API_Manager().sendGcodeCommand("T1");
                        showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => AlertDialog(
                          content: Row(
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(width: 20),
                              Expanded(child: Text("Changement d'outil en cours")),
                            ],
                          ),
                        ),
                      );
                      bool MachineSuccessToBeStable = false;
                      try {
                        MachineSuccessToBeStable = await API_Manager().waitUntilMachineIsStill(
                          stableDuration: Duration(seconds: 3),
                          maxWait: Duration(minutes: 4),
                        );
                      } catch (e) {
                        print("Erreur pendant le changement d'outil : \$e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("❌ Erreur pendant le changement d'outil : \$e"), duration: Duration(seconds: 2)),
                        );
                      } finally {
                        Navigator.of(context).pop();
                        if ((global.machineObjectModel.result?.sensors?.gpIn?[1]?.value ??0) ==0){
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                            content: Row(
                              children: const [
                                Expanded(child: Text("❌ L'outil n'est pas correctement mis en place ! Vérifiez !")),
                              ],
                            ),
                          ),
                        );
                      } 
                      else {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                            content: Row(
                              children: const [
                                Expanded(child: Text("✅ L'outil est correctement mis en place")),
                              ],
                            ),
                          ),
                        );
                      }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ changement d'outil terminé"), duration: Duration(seconds: 2)),
                      );
                      
                      },),
                      NeumorphicButton(child: Text("T2",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25 ),),onPressed: ()async {
                        API_Manager().sendGcodeCommand("T2");
                        showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => AlertDialog(
                          content: Row(
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(width: 20),
                              Expanded(child: Text("Changement d'outil en cours")),
                            ],
                          ),
                        ),
                      );
                      bool MachineSuccessToBeStable = false;
                      try {
                        MachineSuccessToBeStable = await API_Manager().waitUntilMachineIsStill(
                          stableDuration: Duration(seconds: 3),
                          maxWait: Duration(minutes: 4),
                        );
                      } catch (e) {
                        print("Erreur pendant le changement d'outil : \$e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("❌ Erreur pendant le changement d'outil : \$e"), duration: Duration(seconds: 2)),
                        );
                      } finally {
                        Navigator.of(context).pop();
                        if ((global.machineObjectModel.result?.sensors?.gpIn?[1]?.value ??0) ==0){
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                            content: Row(
                              children: const [
                                Expanded(child: Text("❌ L'outil n'est pas correctement mis en place ! Vérifiez !")),
                              ],
                            ),
                          ),
                        );
                      } 
                      else {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                            content: Row(
                              children: const [
                                Expanded(child: Text("✅ L'outil est correctement mis en place")),
                              ],
                            ),
                          ),
                        );
                      }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ changement d'outil terminé"), duration: Duration(seconds: 2)),
                      );
                      
                      },),
                      NeumorphicButton(child: Text("T3",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25 ),),onPressed: ()async {
                        API_Manager().sendGcodeCommand("T3");
                        showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => AlertDialog(
                          content: Row(
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(width: 20),
                              Expanded(child: Text("Changement d'outil en cours")),
                            ],
                          ),
                        ),
                      );
                      bool MachineSuccessToBeStable = false;
                      try {
                        MachineSuccessToBeStable = await API_Manager().waitUntilMachineIsStill(
                          stableDuration: Duration(seconds: 3),
                          maxWait: Duration(minutes: 4),
                        );
                      } catch (e) {
                        print("Erreur pendant le changement d'outil : \$e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("❌ Erreur pendant le changement d'outil : \$e"), duration: Duration(seconds: 2)),
                        );
                      } finally {
                        Navigator.of(context).pop();
                        if ((global.machineObjectModel.result?.sensors?.gpIn?[1]?.value ??0) ==0){
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                            content: Row(
                              children: const [
                                Expanded(child: Text("❌ L'outil n'est pas correctement mis en place ! Vérifiez !")),
                              ],
                            ),
                          ),
                        );
                      } 
                      else {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                            content: Row(
                              children: const [
                                Expanded(child: Text("✅ L'outil est correctement mis en place")),
                              ],
                            ),
                          ),
                        );
                      }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ changement d'outil terminé"), duration: Duration(seconds: 2)),
                      );
                      
                      },),
                      NeumorphicButton(child: Text("T4",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25 ),),onPressed: ()async {
                        API_Manager().sendGcodeCommand("T4");
                        showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => AlertDialog(
                          content: Row(
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(width: 20),
                              Expanded(child: Text("Changement d'outil en cours")),
                            ],
                          ),
                        ),
                      );
                      bool MachineSuccessToBeStable = false;
                      try {
                        MachineSuccessToBeStable = await API_Manager().waitUntilMachineIsStill(
                          stableDuration: Duration(seconds: 3),
                          maxWait: Duration(minutes: 4),
                        );
                      } catch (e) {
                        print("Erreur pendant le changement d'outil : \$e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("❌ Erreur pendant le changement d'outil : \$e"), duration: Duration(seconds: 2)),
                        );
                      } finally {
                        Navigator.of(context).pop();
                        if ((global.machineObjectModel.result?.sensors?.gpIn?[1]?.value ??0) ==0){
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                            content: Row(
                              children: const [
                                Expanded(child: Text("❌ L'outil n'est pas correctement mis en place ! Vérifiez !")),
                              ],
                            ),
                          ),
                        );
                      } 
                      else {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                            content: Row(
                              children: const [
                                Expanded(child: Text("✅ L'outil est correctement mis en place")),
                              ],
                            ),
                          ),
                        );
                      }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ changement d'outil terminé"), duration: Duration(seconds: 2)),
                      );
                      
                      },),
                      NeumorphicButton(child: Text("T5",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25 ),),onPressed: ()async {
                        API_Manager().sendGcodeCommand("T5");
                        showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => AlertDialog(
                          content: Row(
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(width: 20),
                              Expanded(child: Text("Changement d'outil en cours")),
                            ],
                          ),
                        ),
                      );
                      bool MachineSuccessToBeStable = false;
                      try {
                        MachineSuccessToBeStable = await API_Manager().waitUntilMachineIsStill(
                          stableDuration: Duration(seconds: 3),
                          maxWait: Duration(minutes: 4),
                        );
                      } catch (e) {
                        print("Erreur pendant le changement d'outil : \$e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("❌ Erreur pendant le changement d'outil : \$e"), duration: Duration(seconds: 2)),
                        );
                      } finally {
                        Navigator.of(context).pop();
                        if ((global.machineObjectModel.result?.sensors?.gpIn?[1]?.value ??0) ==0){
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                            content: Row(
                              children: const [
                                Expanded(child: Text("❌ L'outil n'est pas correctement mis en place ! Vérifiez !")),
                              ],
                            ),
                          ),
                        );
                      } 
                      else {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => AlertDialog(
                            content: Row(
                              children: const [
                                Expanded(child: Text("✅ L'outil est correctement mis en place")),
                              ],
                            ),
                          ),
                        );
                      }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ changement d'outil terminé"), duration: Duration(seconds: 2)),
                      );
                      
                      },),
                      
                    ],),),
                    Flexible(
                      flex: 4,
                      child: Container(
                        height: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonLayout extends StatelessWidget {
  const ButtonLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(100.0),
      child: Stack(
        children: [
          // Bouton en haut à gauche
          Positioned(
            top: 20,
            left: 20,
            child: NeumorphicButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Mesure en cours..."),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                              "Ce message disparaîtra au bout de quelques secondes"),
                          SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            API_Manager().sendGcodeCommand("M112");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(color: Colors.white),
                          ),
                          child: const Text(
                            'Arrêt immédiat',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
                API_Manager()
                    .sendGcodeCommand('M98 P"palperAHG.g"')
                    .then((value) {
                  var times = 0;
                  Timer.periodic(
                    const Duration(milliseconds: 100),
                    (timer) {
                      times++;
                      API_Manager().sendrr_reply().then((response) {
                        if (response.contains("end of ") || times > 300) {
                          times = 0;
                          timer.cancel();
                          Navigator.of(context).pop();
                        }
                      });
                    },
                  );
                });
              },
              child: const Text('HG'),
            ),
          ),

          // Bouton en haut à droite
          Positioned(
            top: 20,
            right: 20,
            child: NeumorphicButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Mesure en cours..."),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                              "Ce message disparaîtra au bout de quelques secondes"),
                          SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            API_Manager().sendGcodeCommand("M112");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(color: Colors.white),
                          ),
                          child: const Text(
                            'Arrêt immédiat',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
                API_Manager()
                    .sendGcodeCommand('M98 P"palperAHD.g"')
                    .then((value) {
                  var times = 0;
                  Timer.periodic(
                    const Duration(milliseconds: 100),
                    (timer) {
                      times++;
                      API_Manager().sendrr_reply().then((response) {
                        if (response.contains("end of ") || times > 300) {
                          times = 0;
                          timer.cancel();
                          Navigator.of(context).pop();
                        }
                      });
                    },
                  );
                });
              },
              child: const Text('HD'),
            ),
          ),

          // Bouton en bas à gauche
          Positioned(
            bottom: 20,
            left: 20,
            child: NeumorphicButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Mesure en cours..."),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                              "Ce message disparaîtra au bout de quelques secondes"),
                          SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            API_Manager().sendGcodeCommand("M112");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(color: Colors.white),
                          ),
                          child: const Text(
                            'Arrêt immédiat',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
                API_Manager()
                    .sendGcodeCommand('M98 P"palperABG.g"')
                    .then((value) {
                  var times = 0;
                  Timer.periodic(
                    const Duration(milliseconds: 100),
                    (timer) {
                      times++;
                      API_Manager().sendrr_reply().then((response) {
                        if (response.contains("end of ") || times > 300) {
                          times = 0;
                          timer.cancel();
                          Navigator.of(context).pop();
                        }
                      });
                    },
                  );
                });
              },
              child: const Text('BG'),
            ),
          ),

          // Bouton en bas à droite
          Positioned(
            bottom: 20,
            right: 20,
            child: NeumorphicButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Mesure en cours..."),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                              "Ce message disparaîtra au bout de quelques secondes"),
                          SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            API_Manager().sendGcodeCommand("M112");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(color: Colors.white),
                          ),
                          child: const Text(
                            'Arrêt immédiat',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
                API_Manager()
                    .sendGcodeCommand('M98 P"palperABD.g"')
                    .then((value) {
                  var times = 0;
                  Timer.periodic(
                    const Duration(milliseconds: 100),
                    (timer) {
                      times++;
                      API_Manager().sendrr_reply().then((response) {
                        if (response.contains("end of ") || times > 300) {
                          times = 0;
                          timer.cancel();
                          Navigator.of(context).pop();
                        }
                      });
                    },
                  );
                });
              },
              child: const Text('BD'),
            ),
          ),

          // Bouton central
          Center(
            child: NeumorphicButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Mesure en cours..."),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                              "Ce message disparaîtra au bout de quelques secondes"),
                          SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            API_Manager().sendGcodeCommand("M112");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(color: Colors.white),
                          ),
                          child: const Text(
                            'Arrêt immédiat',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
                API_Manager()
                    .sendGcodeCommand('M98 P"palperCentre.g"')
                    .then((value) {
                  var times = 0;
                  Timer.periodic(
                    const Duration(milliseconds: 100),
                    (timer) {
                      times++;
                      API_Manager().sendrr_reply().then((response) {
                        if (response.contains("end of ") || times > 300) {
                          times = 0;
                          timer.cancel();
                          Navigator.of(context).pop();
                        }
                      });
                    },
                  );
                });
              },
              child: const Text('Centre'),
            ),
          ),
        ],
      ),
    );
  }
}
