import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sudokuMath.dart';

void main() {
  runApp(const SudokuGame());
}

class SudokuGame extends StatefulWidget {
  const SudokuGame({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SudokuGameState createState() => _SudokuGameState();
}

class _SudokuGameState extends State<SudokuGame> {
  late List<List<int>> _sudokuBoard;

  @override
  void initState() {
    super.initState();
    _sudokuBoard = SudokuMath.generateSudokuBoard();
  }

  void _refreshSudoku() {
    setState(() {
      List<List<int>> newBoard;
      do {
        newBoard = SudokuMath.generateSudokuBoard();
      } while (_areBoardsEqual(newBoard, _sudokuBoard));
      _sudokuBoard = newBoard;
    });
  }

  bool _areBoardsEqual(List<List<int>> board1, List<List<int>> board2) {
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        if (board1[i][j] != board2[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  void _solveSudoku() {
    setState(() {
      if (SudokuMath.solveSudoku(_sudokuBoard)) {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {});
        });
      } else {
        if (kDebugMode) {
          print("No solution found!");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = SudokuMath.isSudokuCompleted(_sudokuBoard);
    final bool isValid = SudokuMath.isSudokuValid(_sudokuBoard);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Welcome to Sudoku Game',
            style: GoogleFonts.vt323(
              textStyle:
                  const TextStyle(color: Colors.white, letterSpacing: .5),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SudokuBoard(board: _sudokuBoard),
              ),
              if (isCompleted && isValid)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'You won the Sudoku!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: _refreshSudoku,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  'Refresh',
                  style: GoogleFonts.vt323(
                    textStyle:
                        const TextStyle(color: Colors.white, letterSpacing: .5),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _solveSudoku,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  'Solve',
                  style: GoogleFonts.vt323(
                    textStyle:
                        const TextStyle(color: Colors.white, letterSpacing: .5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SudokuBoard extends StatefulWidget {
  final List<List<int>> board;

  const SudokuBoard({super.key, required this.board});

  @override
  // ignore: library_private_types_in_public_api
  _SudokuBoardState createState() => _SudokuBoardState();
}

class _SudokuBoardState extends State<SudokuBoard> {
  late List<List<int>> _currentBoard;

  @override
  void initState() {
    super.initState();
    _currentBoard = List.generate(9, (_) => List<int>.filled(9, 0));
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        _currentBoard[i][j] = widget.board[i][j];
      }
    }
  }

  Future<void> _editCell(
      BuildContext context, int rowIndex, int colIndex) async {
    final int? newValue = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Cell'),
          content: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            onChanged: (String value) {
              setState(() {
                _currentBoard[rowIndex][colIndex] = int.tryParse(value) ?? 0;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop<int>(_currentBoard[rowIndex][colIndex]);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    if (newValue != null) {
      setState(() {
        _currentBoard[rowIndex][colIndex] = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.black,
      child: ListView.builder(
        itemCount: 9,
        itemBuilder: (context, rowIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(9, (colIndex) {
              return InkWell(
                onTap: () {
                  _editCell(context, rowIndex, colIndex);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                  ),
                  child: Center(
                    child: Text(
                      _currentBoard[rowIndex][colIndex] == 0
                          ? ''
                          : _currentBoard[rowIndex][colIndex].toString(),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
