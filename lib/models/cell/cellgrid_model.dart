import 'cell_model.dart';

class CellGrid {
  static int countNeighborMine = 0;
  static int countNeighborFlag = 1;
  static int countNeighborUnprobed = 2;
  late int numMines;
  late int sizeGrid;
  List<List<CellModel>> grid = [];
  CellGrid(this.sizeGrid, this.numMines);

  CellModel getCell(int row, int col) {
    return grid[row][col];
  }

  List<CellModel> getNeighbors(CellModel square) {
    List<CellModel> neighborSquares = [];
    int row, col;
    for (int i = -1; i < 2; i++) {
      row = square.x + i;
      if (row >= 0 && row < sizeGrid) {
        for (int j = -1; j < 2; j++) {
          col = square.y + j;
          if (col >= 0 && col < sizeGrid && !(i == 0 && j == 0)) {
            neighborSquares.add(grid[row][col]);
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
    for (List<CellModel> list in grid) {
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
