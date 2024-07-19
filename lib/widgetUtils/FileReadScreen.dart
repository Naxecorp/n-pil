import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../globals_var.dart' as global;

class FileReadScreen extends StatefulWidget {
  @override
  _FileReadScreenState createState() => _FileReadScreenState();
}

class _FileReadScreenState extends State<FileReadScreen> {
  final List<String> _fileLines = [];
  String _filePath = '';
  int _currentStartLine = 0;
  int _linesPerPage = 20; // Valeur par défaut
  int _cursorByte = -1; // -1 signifie pas de curseur
  int _cursorLine = -1; // La ligne correspondant au curseur
  bool _isLoading = false;
  int _totalLines = 0;
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeFile();
    // _startCursorIncrement(); // Retirer cette ligne, l'incrémentation est déjà gérée dans main.dart
    global.cursorNotifier.addListener(_onCursorChanged); // Ajouter un listener pour les changements de cursor
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    global.cursorNotifier.removeListener(_onCursorChanged); // Retirer le listener
    super.dispose();
  }

  void _onCursorChanged() {
    setState(() {
      _cursorByte = global.cursorNotifier.value;
    });
    if (_cursorLine != -1 && (_cursorLine % _linesPerPage) >= (_linesPerPage - 5)) {
        _loadNextPage();
      } else {
        _loadLines(scrollToCursor: true);
      }
  }

  Future<void> _initializeFile() async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/job.g';
    setState(() {
      _filePath = filePath;
    });
    await _loadTotalLines();
    await _loadLines();
  }

  Future<void> _loadTotalLines() async {
    try {
      final file = File(_filePath);
      if (await file.exists()) {
        final stream = file.openRead();
        final lines = stream
            .transform(utf8.decoder)
            .transform(LineSplitter());

        int totalLines = 0;
        await for (var line in lines) {
          totalLines++;
        }
        setState(() {
          _totalLines = totalLines;
        });
      }
    } catch (e) {
      setState(() {
        _totalLines = 0;
      });
    }
  }

  Future<void> _loadLines({bool scrollToCursor = false}) async {
     setState(() {
       _isLoading = true;
     });
    try {
      final file = File(_filePath);
      if (await file.exists()) {
        final stream = file.openRead();
        final lines = stream
            .transform(utf8.decoder)
            .transform(LineSplitter());

        int currentLine = 0;
        int byteCount = 0;
        List<String> newLines = [];
        await for (var line in lines) {
          final lineByteCount = utf8.encode(line).length + 1; // +1 pour le caractère de nouvelle ligne
          if (_cursorByte != -1 && byteCount <= _cursorByte && _cursorByte < byteCount + lineByteCount) {
            setState(() {
              _cursorLine = currentLine;
              if (scrollToCursor) {
                _currentStartLine = (currentLine ~/ _linesPerPage) * _linesPerPage; // Aller directement à la page contenant la ligne du curseur
              }
            });
          }
          if (currentLine >= _currentStartLine && currentLine < _currentStartLine + _linesPerPage) {
            newLines.add(line);
          }
          if (newLines.length >= _linesPerPage) {
            break;
          }
          byteCount += lineByteCount;
          currentLine++;
        }
        setState(() {
          _fileLines.clear();
          _fileLines.addAll(newLines);
        });
      } else {
        setState(() {
          _fileLines.clear();
          _fileLines.add('Le fichier job.g n\'existe pas dans le répertoire temporaire.');
        });
      }
    } catch (e) {
      setState(() {
        _fileLines.clear();
        _fileLines.add('Erreur lors de la lecture du fichier: $e');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      if (scrollToCursor && _scrollController.hasClients) {
        _scrollToTop();
      }
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 30),
      curve: Curves.easeOut,
    );
  }

  void _loadNextPage() {
    setState(() {
      _currentStartLine += _linesPerPage;
    });
    _loadLines(scrollToCursor: true);
  }

  void _loadPreviousPage() {
    setState(() {
      _currentStartLine = (_currentStartLine - _linesPerPage).clamp(0, _currentStartLine);
    });
    _loadLines();
  }

  void _updateLinesPerPage(String value) {
    final newLinesPerPage = int.tryParse(value);
    if (newLinesPerPage != null && newLinesPerPage > 0) {
      setState(() {
        _linesPerPage = newLinesPerPage;
        _currentStartLine = 0; // Recommencer à la première ligne
      });
      _loadLines();
    }
  }

  void _updateCursorByte(String value) {
    final newCursorByte = int.tryParse(value);
    if (newCursorByte != null && newCursorByte >= 0) {
      setState(() {
        _cursorByte = newCursorByte;
        _cursorLine = -1; // Réinitialiser la ligne du curseur
      });
      _loadLines(scrollToCursor: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (_totalLines / _linesPerPage).ceil();
    final currentPage = (_currentStartLine / _linesPerPage).ceil() + 1;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _fileLines.asMap().entries.map((entry) {
                        int idx = entry.key;
                        String line = entry.value;
                        bool isCursorLine = _currentStartLine + idx == _cursorLine;
                        return Container(
                          color: isCursorLine ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                          child: Text(line),
                        );
                      }).toList(),
                    ),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: null, // _currentStartLine > 0 ? _loadPreviousPage : null,
                child: Text('Page Précédente'),
              ),
              Text('Page $currentPage / $totalPages'),
              ElevatedButton(
                onPressed: null, // _loadNextPage,
                child: Text('Page Suivante'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
