import 'dart:math';

class SudokuMath {
  static List<List<int>> generateSudokuBoard() {
    final List<List<int>> board =
        List.generate(9, (_) => List<int>.filled(9, 0));
    final Random random = Random();
    _solveSudoku(board, random);
    _removeNumbers(board, random);
    return board;
  }

  static void _removeNumbers(List<List<int>> board, Random random) {
    const removeCount = 40; // Adjust this number for difficulty
    for (var i = 0; i < removeCount; i++) {
      int x, y;
      do {
        x = random.nextInt(9);
        y = random.nextInt(9);
      } while (board[x][y] == 0);
      board[x][y] = 0;
    }
  }

  static bool _solveSudoku(List<List<int>> board, Random random) {
    final List<int> emptyCell = _getEmptyCell(board);
    final int row = emptyCell[0];
    final int col = emptyCell[1];

    if (row == -1) {
      return true; // Puzzle solved
    }

    final List<int> nums = _shuffleNumbers();
    for (final num in nums) {
      if (_isValid(board, row, col, num)) {
        board[row][col] = num;
        if (_solveSudoku(board, random)) {
          return true;
        }
        board[row][col] = 0; // Backtrack
      }
    }
    return false; // No solution found
  }

  static List<int> _getEmptyCell(List<List<int>> board) {
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        if (board[i][j] == 0) {
          return [i, j]; // Return row and col of empty cell
        }
      }
    }
    return [-1, -1]; // Return [-1, -1] if no empty cell found
  }

  static List<int> _shuffleNumbers() {
    final List<int> nums = List.generate(9, (index) => index + 1);
    nums.shuffle();
    return nums;
  }

  static bool solveSudoku(List<List<int>> board) {
    final Random random = Random();
    return _solveSudoku(board, random);
  }

  static bool _isValid(List<List<int>> board, int row, int col, int num) {
    for (var i = 0; i < 9; i++) {
      if (board[row][i] == num || board[i][col] == num) {
        return false;
      }
    }
    final int startRow = (row ~/ 3) * 3;
    final int startCol = (col ~/ 3) * 3;
    for (var i = startRow; i < startRow + 3; i++) {
      for (var j = startCol; j < startCol + 3; j++) {
        if (board[i][j] == num) {
          return false;
        }
      }
    }
    return true;
  }

  static bool isSudokuCompleted(List<List<int>> board) {
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        if (board[i][j] == 0) {
          return false;
        }
      }
    }
    return isSudokuValid(board);
  }

  static bool isSudokuValid(List<List<int>> board) {
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        if (board[i][j] != 0 && !_isValid(board, i, j, board[i][j])) {
          return false; // If any cell violates Sudoku rules, return false
        }
      }
    }
    return true;
  }
}
