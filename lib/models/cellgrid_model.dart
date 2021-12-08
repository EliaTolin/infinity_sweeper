import 'package:infinity_sweeper/models/cell_model.dart';

class CellGrid {
  late int numMines;
  late int sizeGrid;
  List<List<CellModel>> grid = [];
  CellGrid(this.numMines, this.sizeGrid);
}
