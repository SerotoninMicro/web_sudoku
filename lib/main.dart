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
                child: SudokuBoard(board: _sudokuBoard, onCellTap: _editCell),
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

  void _editCell(int rowIndex, int colIndex, int newValue) {
    setState(() {
      _sudokuBoard[rowIndex][colIndex] = newValue;
    });
  }
}

class SudokuBoard extends StatefulWidget {
  final List<List<int>> board;
  final Function(int, int, int) onCellTap;

  const SudokuBoard({super.key, required this.board, required this.onCellTap});

  @override
  // ignore: library_private_types_in_public_api
  _SudokuBoardState createState() => _SudokuBoardState();
}

class _SudokuBoardState extends State<SudokuBoard> {
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
                  if (widget.board[rowIndex][colIndex] == 0) {
                    widget.onCellTap(rowIndex, colIndex, 1);
                  }
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                  ),
                  child: Center(
                    child: Text(
                      widget.board[rowIndex][colIndex] == 0
                          ? ''
                          : widget.board[rowIndex][colIndex].toString(),
                      style: GoogleFonts.vt323(
                        textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            letterSpacing: .5),
                      ),
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
