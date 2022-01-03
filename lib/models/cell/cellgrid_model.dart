import 'cell_model.dart';

class MinesGrid {
  //For solver
  static int countNeighborMine = 0;
  static int countNeighborFlag = 1;
  static int countNeighborUnprobed = 2;
  late int numMines;
  //number of columns
  late int numColumns;
  //number of rows
  late int numRows;
  //The cells grid is rappresent by List of List of CellModel
  List<List<CellModel>> gridCells = [];

  MinesGrid(this.numRows, this.numColumns, this.numMines);

  CellModel getCell(int row, int col) => gridCells[row][col];

  List<CellModel> getNeighbors(CellModel square) {
    List<CellModel> neighborSquares = [];
    int row, col;
    for (int i = -1; i < 2; i++) {
      row = square.x + i;
      if (row >= 0 && row < numRows) {
        for (int j = -1; j < 2; j++) {
          col = square.y + j;
          if (col >= 0 && col < numColumns && !(i == 0 && j == 0)) {
            neighborSquares.add(gridCells[row][col]);
          }
        }
      }
    }
    return neighborSquares;
  }

  int countNeighor(CellModel cell, int countKey) {
    int count = 0;
    for (CellModel neighborSquare in getNeighbors(cell)) {
      if ((countKey == countNeighborMine && neighborSquare.isMine) ||
          (countKey == countNeighborFlag && neighborSquare.isFlagged) ||
          (countKey == countNeighborUnprobed && neighborSquare.isEnabled)) {
        count++;
      }
    }
    return count;
  }

  void initizialize() {
    for (List<CellModel> list in gridCells) {
      for (var element in list) {
        element.show = false;
        element.mine = false;
        element.resetValue();
        element.enabled = true;
        element.flag = false;
      }
    }
  }
}
