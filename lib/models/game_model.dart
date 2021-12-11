import 'dart:math';
import 'package:flutter/material.dart';
import 'package:infinity_sweeper/models/cell_model.dart';
import 'package:infinity_sweeper/models/cellgrid_model.dart';
import 'package:infinity_sweeper/models/gamestate_model.dart';

class GameModel extends ChangeNotifier {
  CellGrid? cellGrid;
  late GameState state;

  void initizialize(final int _sizeGrid, final int _numMines) {
    state = GameState.idle;
    cellGrid = CellGrid(_sizeGrid, _numMines);
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
    _addMines();
    _addValueCell();
    notifyListeners();
  }

  void _addMines() {
    final int length = cellGrid!.grid[0].length;
    final int maxLength = length * length;
    var numRandomList = [];

    for (int i = 0; i < cellGrid!.numMines; i++) {
      int randomNumber = 0;
      do {
        randomNumber = Random().nextInt(maxLength);
      } while (numRandomList.contains(randomNumber));
      numRandomList.add(randomNumber);
      int x = randomNumber ~/ length;
      int y = (randomNumber % length).toInt();
      cellGrid!.grid[x][y].mine = true;
    }
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
    cellGrid!.grid[x][y].flag = true;
    notifyListeners();
  }

  void checkWin() {
    for (List<CellModel> list in cellGrid!.grid) {
      for (var element in list) {
        if (!element.isMine && !element.isShowed) {
          return;
        }
      }
    }
    state = GameState.victory;
  }

  void computeCell(int x, int y) {
    //Get cell
    CellModel cell = cellGrid!.grid[x][y];
    //Prevent open bomb first time
    if (state == GameState.idle) {
      if (cell.isMine) {
        bool isMine = true;
        //if it's still a bomb, I regenerate.
        while (isMine) {
          generateCellGrid();
          cell = cellGrid!.grid[x][y];
          isMine = cell.isMine ? true : false;
        }
        return;
      }
      //set the new state of game
      state = GameState.started;
    }
    //Check if lose
    if (cell.isMine) {
      state = GameState.lose;
      return;
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
          if (!cellGrid!.grid[j][k].isMine &&
              !cellGrid!.grid[j][k].isShowed &&
              cellGrid!.grid[j][k].value == 0) computeCell(j, k);
        }
      }
    }
    //Count the showed cell?
    //to do;
    //Check if win
    checkWin();
    notifyListeners();
  }
}
