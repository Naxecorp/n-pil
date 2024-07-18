import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Variable globale pour la position du curseur
int currentCursorPosition = 0;

class AutoScrollTextFile extends StatefulWidget {
  @override
  _AutoScrollTextFileState createState() => _AutoScrollTextFileState();
}

class _AutoScrollTextFileState extends State<AutoScrollTextFile> {
  late TextEditingController _textController;
  late ScrollController _scrollController;
  File? _file;
  int _currentLine = 0;
  List<String> _currentBatch = [];
  final int _batchSize = 40;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _scrollController = ScrollController();
    _initializeFile();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _initializeFile() async {
    final directory = await getTemporaryDirectory();
    _file = File('${directory.path}/job.g');
    _loadInitialLines();
  }

  Future<void> _loadInitialLines() async {
    if (_file == null) return;
    if (await _file!.exists()) {
      _currentBatch = await _readLinesFromFile(_currentLine, _batchSize);
      setState(() {
        _textController.text = _currentBatch.join('\n');
      });
    } else {
      Timer(Duration(seconds: 3), _loadInitialLines);
    }
  }

  Future<List<String>> _readLinesFromFile(int startLine, int numLines) async {
    List<String> lines = [];
    int currentLine = 0;
    await for (var line in _file!
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())) {
      if (currentLine >= startLine && currentLine < startLine + numLines) {
        lines.add(line);
      }
      if (lines.length == numLines) {
        break;
      }
      currentLine++;
    }
    return lines;
  }

  void _scrollListener() {
    final cursorPosition = _textController.selection.baseOffset;
    currentCursorPosition = cursorPosition;
    if (cursorPosition != -1 &&
        cursorPosition >=
            (_textController.text.length - _currentBatch.last.length)) {
      if (!_isLoading && _currentLine + _batchSize < _file!.lengthSync()) {
        _loadMoreLines();
      }
    }
  }

  Future<void> _loadMoreLines() async {
    setState(() {
      _isLoading = true;
    });

    _currentLine += _batchSize;
    List<String> newBatch = await _readLinesFromFile(_currentLine, _batchSize);

    if (newBatch.isNotEmpty) {
      setState(() {
        _currentBatch = newBatch;
        _textController.text = _currentBatch.join('\n');
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildRichText(),
      ),
    );
  }

  Widget _buildRichText() {
    List<TextSpan> textSpans = [];
    int charCount = 0;
    for (int i = 0; i < _currentBatch.length; i++) {
      String line = _currentBatch[i];
      bool isHighlighted = charCount <= currentCursorPosition &&
          currentCursorPosition < charCount + line.length;
      textSpans.add(
        TextSpan(
          text: line + '\n',
          style: TextStyle(
            backgroundColor: isHighlighted ? Colors.blue : Colors.transparent,
            color: Colors.black,
            fontFamily: 'monospace',
          ),
        ),
      );
      charCount += line.length + 1;
    }

    return RichText(
      text: TextSpan(children: textSpans),
    );
  }
}
