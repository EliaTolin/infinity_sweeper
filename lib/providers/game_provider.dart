import 'dart:math';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/models/cell/cell_model.dart';
import 'package:infinity_sweeper/models/cell/cellgrid_model.dart';
import 'package:infinity_sweeper/models/game/gamedifficulty_model.dart';
import 'package:infinity_sweeper/models/game/gamestate_model.dart';
import 'package:infinity_sweeper/utils/spwcspSolver.dart';

class GameModelProvider extends ChangeNotifier {
  MinesGrid? cellGrid;
  late GameState state;
  late int numFlag;
  late Difficulty difficulty;
  void initizialize(GameDifficulty gameDifficulty) {
    state = GameState.idle;
    cellGrid = MinesGrid(
        gameDifficulty.numRow, gameDifficulty.numCol, gameDifficulty.numMines);
    numFlag = gameDifficulty.numMines;
    difficulty = gameDifficulty.difficulty;
  }

  void generateCellGrid() {
    cellGrid!.gridCells.clear();
    if (cellGrid == null) throw Exception("cellGrid == null");
    for (int x = 0; x < cellGrid!.numRows; x++) {
      List<CellModel> row = [];
      for (int y = 0; y < cellGrid!.numColumns; y++) {
        row.add(CellModel(x, y));
      }
      cellGrid!.gridCells.add(row);
    }
    notifyListeners();
  }

  void generateMap(CellModel clickedCell) {
    SPwCSPSolver solver = SPwCSPSolver.getSolver();
    bool isSolvable = false;
    final int numRows = cellGrid!.numRows;
    final int numColomns = cellGrid!.numColumns;
    while (!isSolvable) {
      int placedMineNum = 0;
      int randRow, randCol;
      cellGrid!.initizialize();
      // initialize the map except for first clicked button
      clickedCell.enabled = false;
      // randomly place mines
      while (placedMineNum < cellGrid!.numMines) {
        randRow = (Random().nextInt(numRows));
        randCol = (Random().nextInt(numColomns));
        if (!(randRow >= clickedCell.x - 1 &&
                randRow <= clickedCell.x + 1 &&
                randCol >= clickedCell.y - 1 &&
                randCol <= clickedCell.y + 1) &&
            !(cellGrid!.getCell(randRow, randCol).isMine)) {
          //make sure not to place mines around or at the clicked square which causes guessing
          cellGrid!.gridCells[randRow][randCol].mine = true;
          placedMineNum++;
        }
      }
      // check whether is solvable without guessing
      isSolvable =
          solver.isSolvable(cellGrid!, clickedCell.x * numRows + clickedCell.y);

      // clear solver's operation
      for (int row = 0; row < numRows; row++) {
        for (int col = 0; col < numColomns; col++) {
          if (!(row == clickedCell.x && col == clickedCell.y)) {
            cellGrid!.gridCells[row][col].enabled = (true);
            cellGrid!.gridCells[row][col].flag = (false);
          }
        }
      }
    }
    _addValueCell();
  }

  void _addValueCell() {
    for (int x = 0; x < cellGrid!.numRows; x++) {
      for (int y = 0; y < cellGrid!.numColumns; y++) {
        CellModel cell = cellGrid!.gridCells[x][y];
        if (cell.isMine) {
          int startX = (cell.x - 1) < 0 ? 0 : cell.x - 1;
          int endX = (cell.x + 1) > cellGrid!.numRows - 1
              ? cellGrid!.numRows - 1
              : cell.x + 1;

          int startY = (cell.y - 1) < 0 ? 0 : cell.y - 1;
          int endY = (cell.y + 1) > cellGrid!.numColumns - 1
              ? cellGrid!.numColumns - 1
              : cell.y + 1;

          for (int j = startX; j <= endX; j++) {
            for (int k = startY; k <= endY; k++) {
              if (!cellGrid!.gridCells[j][k].isMine) {
                cellGrid!.gridCells[j][k].incValue();
              }
            }
          }
        }
      }
    }
  }

  void setFlag(int x, int y) {
    cellGrid!.gridCells[x][y].isFlagged ? numFlag++ : numFlag--;
    cellGrid!.gridCells[x][y].flag = !cellGrid!.gridCells[x][y].isFlagged;
    notifyListeners();
  }

  void checkWin() {
    for (List<CellModel> list in cellGrid!.gridCells) {
      for (var element in list) {
        //non si ha vinto finche ci sono bombe non flaggate
        //Salvo la posizione delle bombe e delle bandiere e controllo
        //che non ci siano caselle coperte
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
      for (List<CellModel> list in cellGrid!.gridCells) {
        for (var element in list) {
          element.show = true;
        }
      }
    }
  }

  void computeCell(int x, int y) {
    //Get cell
    CellModel cell = cellGrid!.gridCells[x][y];
    //Prevent open bomb first time
    if (state == GameState.idle) {
      generateMap(cellGrid!.getCell(x, y));
      //set the new state of game
      state = GameState.started;
    }
    //Show value
    if (cell.x > cellGrid!.numRows ||
        cell.y > cellGrid!.numColumns ||
        cell.x < 0 ||
        cell.y < 0 ||
        cell.isShowed) return;
    cell.show = true;
    if (cell.value == 0) {
      int startX = (cell.x - 1) < 0 ? 0 : cell.x - 1;
      int endX = (cell.x + 1) > cellGrid!.numRows - 1
          ? cellGrid!.numRows - 1
          : cell.x + 1;

      int startY = (cell.y - 1) < 0 ? 0 : cell.y - 1;
      int endY = (cell.y + 1) > cellGrid!.numColumns - 1
          ? cellGrid!.numColumns - 1
          : cell.y + 1;

      for (int j = startX; j <= endX; j++) {
        for (int k = startY; k <= endY; k++) {
          if (cellGrid!.gridCells[j][k].value != 0)
            cellGrid!.gridCells[j][k].show = true;
          if (!cellGrid!.gridCells[j][k].isMine &&
              !cellGrid!.gridCells[j][k].isShowed &&
              cellGrid!.gridCells[j][k].value == 0) computeCell(j, k);
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
