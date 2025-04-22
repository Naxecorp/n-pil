import 'package:flutter/material.dart';
import 'op_gravure_text.dart';

class TextGcodeUI extends StatefulWidget {
  const TextGcodeUI({super.key});

  @override
  State<TextGcodeUI> createState() => _TextGcodeUIState();
}

class _TextGcodeUIState extends State<TextGcodeUI> {
  final TextEditingController textController = TextEditingController(text: "ABC");
  String orientation = 'horizontal';
  double letterHeight = 10.0;
  double bitDiameter = 1.0;
  double engravingDepth = -0.5;
  double originX = 0.0;
  double originY = 0.0;
  double arcRadius = 30.0;
  List<String> gcode = [];

  Future<void> generateGcode() async {
    final result = await generateTextFromPltAlphabet(
      text: textController.text,
      scale: letterHeight / 100.0, // Exemple d'échelle (ajustable selon ton PLT)
      engravingDepth: engravingDepth.abs(),
      letterSpacing: letterHeight * 2.5,
    );
    setState(() => gcode = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gravure Texte (.PLT) → G-code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Texte à graver'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: buildSlider('Hauteur', letterHeight, 5, 50, (v) => setState(() => letterHeight = v))),
                const SizedBox(width: 10),
                Expanded(child: buildSlider('Fraise Ø', bitDiameter, 0.1, 5, (v) => setState(() => bitDiameter = v))),
              ],
            ),
            buildSlider('Profondeur Z', engravingDepth, -5, 0, (v) => setState(() => engravingDepth = v)),
            Row(
              children: [
                Expanded(child: buildSlider('Origine X', originX, -100, 100, (v) => setState(() => originX = v))),
                const SizedBox(width: 10),
                Expanded(child: buildSlider('Origine Y', originY, -100, 100, (v) => setState(() => originY = v))),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: generateGcode,
              child: const Text('Générer le G-code'),
            ),
            const SizedBox(height: 10),
            if (gcode.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black87,
                child: SelectableText(
                  gcode.join('\n'),
                  style: const TextStyle(fontFamily: 'monospace', color: Colors.greenAccent),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label : ${value.toStringAsFixed(2)}'),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) * 10).round(),
          label: value.toStringAsFixed(2),
          onChanged: onChanged,
        )
      ],
    );
  }
}
