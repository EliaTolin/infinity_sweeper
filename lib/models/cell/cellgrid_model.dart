import 'cell_model.dart';

class CellGrid {
  late int numMines;
  late int sizeGrid;
  List<List<CellModel>> grid = [];
  CellGrid(this.sizeGrid, this.numMines);
}
