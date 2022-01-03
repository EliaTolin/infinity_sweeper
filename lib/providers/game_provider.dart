import 'dart:math';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/models/cell/cell_model.dart';
import 'package:infinity_sweeper/models/cell/cellgrid_model.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';
import 'package:infinity_sweeper/models/game/gamestate_model.dart';
import 'package:infinity_sweeper/models/game/solver_model.dart';

class GameModelProvider extends ChangeNotifier {
  CellGrid? cellGrid;
  late GameState state;
  late int numFlag;
  late Difficulty difficulty;
  void initizialize(GameDifficulty gameDifficulty) {
    state = GameState.idle;
    cellGrid = CellGrid(gameDifficulty.sizeGrid, gameDifficulty.numMines);
    numFlag = gameDifficulty.numMines;
    difficulty = gameDifficulty.difficulty;
  }

  void generateCellGrid() {
    cellGrid!.grid.clear();
    if (cellGrid == null) throw Exception("cellGrid == null");
    for (int x = 0; x < cellGrid!.sizeGrid; x++) {
      List<CellModel> row = [];
      for (int y = 0; y < cellGrid!.sizeGrid; y++) {
        row.add(CellModel(x, y));
      }
      cellGrid!.grid.add(row);
    }
    notifyListeners();
  }

  void generateMap(CellModel clickedCell) {
    SPwCSPSolver solver = SPwCSPSolver.getSolver();
    bool isSolvable = false;
    final int rowLenght = cellGrid!.grid.length;
    final int colLenght = cellGrid!.grid[0].length;
    while (!isSolvable) {
      int placedMineNum = 0;
      int randRow, randCol;
      cellGrid!.initizialize();
      // initialize the map except for first clicked button
      clickedCell.enabled = false;
      // randomly place mines
      while (placedMineNum < cellGrid!.numMines) {
        randRow = (Random().nextInt(rowLenght));
        randCol = (Random().nextInt(colLenght));
        if (!(randRow >= clickedCell.x - 1 &&
                randRow <= clickedCell.x + 1 &&
                randCol >= clickedCell.y - 1 &&
                randCol <= clickedCell.y + 1) &&
            !(cellGrid!.getCell(randRow, randCol).isMine)) {
          //make sure not to place mines around or at the clicked square which causes guessing
          cellGrid!.grid[randRow][randCol].mine = true;
          placedMineNum++;
        }
      }
      // check whether is solvable without guessing
      isSolvable = solver.isSolvable(
          cellGrid!, clickedCell.x * rowLenght + clickedCell.y);

      // clear solver's operation
      for (int row = 0; row < rowLenght; row++) {
        for (int col = 0; col < colLenght; col++) {
          if (!(row == clickedCell.x && col == clickedCell.y)) {
            cellGrid!.grid[row][col].enabled = (true);
            cellGrid!.grid[row][col].flag = (false);
          }
        }
      }
    }
    _addValueCell();
  }

  void _addValueCell() {
    final int length = cellGrid!.grid[0].length;
    for (int x = 0; x < length; x++) {
      for (int y = 0; y < length; y++) {
        CellModel cell = cellGrid!.grid[x][y];
        if (cell.isMine) {
          int startX = (cell.x - 1) < 0 ? 0 : cell.x - 1;
          int endX = (cell.x + 1) > length - 1 ? length - 1 : cell.x + 1;

          int startY = (cell.y - 1) < 0 ? 0 : cell.y - 1;
          int endY = (cell.y + 1) > length - 1 ? length - 1 : cell.y + 1;

          for (int j = startX; j <= endX; j++) {
            for (int k = startY; k <= endY; k++) {
              if (!cellGrid!.grid[j][k].isMine) {
                cellGrid!.grid[j][k].incValue();
              }
            }
          }
        }
      }
    }
  }

  void setFlag(int x, int y) {
    cellGrid!.grid[x][y].isFlagged ? numFlag++ : numFlag--;
    cellGrid!.grid[x][y].flag = !cellGrid!.grid[x][y].isFlagged;
    notifyListeners();
  }

  void checkWin() {
    for (List<CellModel> list in cellGrid!.grid) {
      for (var element in list) {
        if (!element.isMine && (!element.isShowed || element.isFlagged)) {
          return;
        }
      }
    }
    finishGame(GameState.victory);
  }

  void finishGame(GameState stateFinish) {
    state = stateFinish;
    if (state == GameState.lose) {
      for (List<CellModel> list in cellGrid!.grid) {
        for (var element in list) {
          element.show = true;
        }
      }
    }
  }

  void computeCell(int x, int y) {
    //Get cell
    CellModel cell = cellGrid!.grid[x][y];
    //Prevent open bomb first time
    if (state == GameState.idle) {
      generateMap(cellGrid!.getCell(x, y));
      //set the new state of game
      state = GameState.started;
    }
    //Show value
    int size = cellGrid!.grid[0].length;
    if (cell.x > size ||
        cell.y > size ||
        cell.x < 0 ||
        cell.y < 0 ||
        cell.isShowed) return;
    cell.show = true;
    if (cell.value == 0) {
      int startX = (cell.x - 1) < 0 ? 0 : cell.x - 1;
      int endX = (cell.x + 1) > size - 1 ? size - 1 : cell.x + 1;

      int startY = (cell.y - 1) < 0 ? 0 : cell.y - 1;
      int endY = (cell.y + 1) > size - 1 ? size - 1 : cell.y + 1;

      for (int j = startX; j <= endX; j++) {
        for (int k = startY; k <= endY; k++) {
          if (cellGrid!.grid[j][k].value != 0) cellGrid!.grid[j][k].show = true;
          if (!cellGrid!.grid[j][k].isMine &&
              !cellGrid!.grid[j][k].isShowed &&
              cellGrid!.grid[j][k].value == 0) computeCell(j, k);
        }
      }
    }
    //Check if lose
    if (cell.isMine) {
      finishGame(GameState.lose);
      notifyListeners();
      return;
    }
    //Check if win
    checkWin();
    notifyListeners();
  }
}
