import 'package:flutter/material.dart';

class FloatingKeyboard extends StatefulWidget {
  final List<String> keys;
  final void Function(String key) onKeyPressed;
  final VoidCallback onClose;
  final Offset initialPosition;

  const FloatingKeyboard({
    Key? key,
    required this.keys,
    required this.onKeyPressed,
    required this.onClose,
    this.initialPosition = const Offset(20, 400),
  }) : super(key: key);

  @override
  State<FloatingKeyboard> createState() => _FloatingKeyboardState();
}

class _FloatingKeyboardState extends State<FloatingKeyboard> {
  late Offset position;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: _buildKeyboard(),
        childWhenDragging: Container(),
        onDragEnd: (details) {
          setState(() {
            position = details.offset;
          });
        },
        child: _buildKeyboard(),
      ),
    );
  }

  Widget _buildKeyboard() {
    // On ajoute ici les boutons spéciaux
    final List<String> allKeys = [
      ...widget.keys,
      '⌫', // Touche effacer
      '⏎', // Touche entrée
    ];

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 320,
        height: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Barre supérieure
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Clavier',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: widget.onClose,
                  )
                ],
              ),
            ),
            // Grille de touches
            Expanded(
              child: GridView.count(
                crossAxisCount: 5,
                children: allKeys.map((keyLabel) {
                  return InkWell(
                    onTap: () {
                      widget.onKeyPressed(keyLabel);
                    },
                    child: Center(
                      child: Text(
                        keyLabel,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
