import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:infinity_sweeper/models/cell/cell_model.dart';
import 'package:infinity_sweeper/models/cell/cellgrid_model.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';
import 'package:infinity_sweeper/models/game/gamestate_model.dart';
import 'package:infinity_sweeper/utils/spwcsp_solver.dart';

class GameLogicController extends GetxController {
  Rx<MinesGrid> cellGrid = (null as MinesGrid).obs;
  GameState state = GameState.idle.obs as GameState;
  var numFlag = 0.obs;
  late Difficulty difficulty;
  List<int> minesPosition = [];
  List<int> cellNotShowedPosition = [];

  void initizialize(GameDifficulty gameDifficulty) {
    state = GameState.idle;
    cellGrid = MinesGrid(gameDifficulty.numRow, gameDifficulty.numCol,
        gameDifficulty.numMines) as Rx<MinesGrid>;
    numFlag = gameDifficulty.numMines as RxInt;
    difficulty = gameDifficulty.difficulty;
  }

  void generateCellGrid() {
    cellGrid.value.gridCells.clear();
    for (int x = 0; x < cellGrid.value.numRows; x++) {
      List<CellModel> row = [];
      for (int y = 0; y < cellGrid.value.numColumns; y++) {
        row.add(CellModel(x, y, x * cellGrid.value.numColumns + y));
      }
      cellGrid.value.gridCells.add(row);
    }
  }

  void generateMap(CellModel clickedCell) {
    SPwCSPSolver solver = SPwCSPSolver.getSolver();
    bool isSolvable = false;
    final int numRows = cellGrid.value.numRows;
    final int numColomns = cellGrid.value.numColumns;
    while (!isSolvable) {
      int placedMineNum = 0;
      int randRow, randCol;
      cellGrid.value.initizialize();
      // initialize the map except for first clicked button
      clickedCell.enabled = false;
      // randomly place mines
      while (placedMineNum < cellGrid.value.numMines) {
        randRow = (Random().nextInt(numRows));
        randCol = (Random().nextInt(numColomns));
        if (!(randRow >= clickedCell.x - 1 &&
                randRow <= clickedCell.x + 1 &&
                randCol >= clickedCell.y - 1 &&
                randCol <= clickedCell.y + 1) &&
            !(cellGrid.value.getCell(randRow, randCol).isMine)) {
          //make sure not to place mines around or at the clicked square which causes guessing
          cellGrid.value.gridCells[randRow][randCol].mine = true;
          placedMineNum++;
        }
      }

      // check whether is solvable without guessing
      isSolvable = solver.isSolvable(cellGrid.value, clickedCell.index);

      // clear solver's operation
      for (int row = 0; row < numRows; row++) {
        for (int col = 0; col < numColomns; col++) {
          if (!(row == clickedCell.x && col == clickedCell.y)) {
            cellGrid.value.gridCells[row][col].enabled = (true);
            cellGrid.value.gridCells[row][col].flag = (false);
          }
        }
      }
    }
    _addValueCell();
    _saveAllPosition();
  }

  void _saveAllPosition() {
    minesPosition.clear();
    cellNotShowedPosition.clear();
    List<int> tmpMines = [];
    for (List<CellModel> list in cellGrid.value.gridCells) {
      for (var element in list) {
        if (!element.isShowed) {
          cellNotShowedPosition.add(element.index);
        }
        if (element.isMine) {
          tmpMines.add(element.index);
        }
      }
    }
    minesPosition = tmpMines;
  }

  void _addValueCell() {
    for (int x = 0; x < cellGrid.value.numRows; x++) {
      for (int y = 0; y < cellGrid.value.numColumns; y++) {
        CellModel cell = cellGrid.value.gridCells[x][y];
        if (cell.isMine) {
          int startX = (cell.x - 1) < 0 ? 0 : cell.x - 1;
          int endX = (cell.x + 1) > cellGrid.value.numRows - 1
              ? cellGrid.value.numRows - 1
              : cell.x + 1;

          int startY = (cell.y - 1) < 0 ? 0 : cell.y - 1;
          int endY = (cell.y + 1) > cellGrid.value.numColumns - 1
              ? cellGrid.value.numColumns - 1
              : cell.y + 1;

          for (int j = startX; j <= endX; j++) {
            for (int k = startY; k <= endY; k++) {
              if (!cellGrid.value.gridCells[j][k].isMine) {
                cellGrid.value.gridCells[j][k].incValue();
              }
            }
          }
        }
      }
    }
  }

  void setFlag(CellModel cell) {
    if (cell.isShowed) return;
    int x = cell.x;
    int y = cell.y;
    if (cell.isFlagged) {
      numFlag++;
      cellGrid.value.gridCells[x][y].flag = false;
    } else {
      numFlag--;
      cellGrid.value.gridCells[x][y].flag = true;
      if (state == GameState.started) {
        checkWin();
      }
    }
  }

  // **** ATTENTION! ****
  // *** ONLY FOR DEBUG ***
  // void flagNotShowed() {
  //   for (List<CellModel> list in cellGrid.value.gridCells) {
  //     for (var element in list) {
  //       if (element.value == 0) {
  //         element.flag = true;
  //       }
  //     }
  //   }
  //   notifyListeners();
  // }
  // *******************

  void checkWin() {
    List sortedList = cellNotShowedPosition..sort();
    if (listEquals(sortedList, minesPosition)) {
      finishGame(GameState.victory);
    }
  }

  void finishGame(GameState stateFinish) {
    state = stateFinish;
    if (state == GameState.lose) {
      for (List<CellModel> list in cellGrid.value.gridCells) {
        for (var element in list) {
          element.show = true;
        }
      }
    }
  }

  void showCell(CellModel cell) {
    if (!cell.isFlagged) {
      cell.show = true;
      cellNotShowedPosition.remove(cell.index);
    }
  }

  void _openEmptyCell(CellModel cell) {
    //Show value
    if (cell.x > cellGrid.value.numRows ||
        cell.y > cellGrid.value.numColumns ||
        cell.x < 0 ||
        cell.y < 0 ||
        cell.isShowed) return;
    showCell(cell);
    if (cell.value == 0) {
      int startX = (cell.x - 1) < 0 ? 0 : cell.x - 1;
      int endX = (cell.x + 1) > cellGrid.value.numRows - 1
          ? cellGrid.value.numRows - 1
          : cell.x + 1;

      int startY = (cell.y - 1) < 0 ? 0 : cell.y - 1;
      int endY = (cell.y + 1) > cellGrid.value.numColumns - 1
          ? cellGrid.value.numColumns - 1
          : cell.y + 1;

      for (int j = startX; j <= endX; j++) {
        for (int k = startY; k <= endY; k++) {
          if (cellGrid.value.gridCells[j][k].value != 0) {
            showCell(cellGrid.value.getCell(j, k));
          }
          if (!cellGrid.value.gridCells[j][k].isMine &&
              !cellGrid.value.gridCells[j][k].isShowed &&
              cellGrid.value.gridCells[j][k].value == 0) {
            _openEmptyCell(cellGrid.value.getCell(j, k));
          }
        }
      }
    }
  }

  void computeCell(CellModel cell) {
    if (state == GameState.victory || state == GameState.lose) {
      return;
    }
    //Prevent open bomb first time
    if (state == GameState.idle) {
      generateMap(cell);
      //set the new state of game
      state = GameState.started;
    }
    //Check if lose
    if (cell.isMine) {
      finishGame(GameState.lose);
      return;
    }
    //openEmptyCell
    _openEmptyCell(cell);
    //Check if win
    checkWin();
  }
}
