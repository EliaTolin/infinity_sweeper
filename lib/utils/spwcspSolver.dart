import 'dart:collection';
import 'package:infinity_sweeper/models/cell/cell_model.dart';
import 'package:infinity_sweeper/models/cell/cellgrid_model.dart';

class SPwCSPSolver {
  SPwCSPSolver();

  static SPwCSPSolver getSolver() {
    return SPwCSPSolver();
  }

  bool isSolvable(MinesGrid minesGrid, int clickedSquareIndex) {
    int gridRow = minesGrid.numRows;
    int gridColumn = minesGrid.numColumns;
    int mineNumber = minesGrid.numMines;
    bool mapUpdated = false;
    int totalFlagCount = 0;
    int totalProbedCellsCount = 1; // include the first clicked one

    HashSet<int> frontierCells = HashSet<int>();
    // set of squares which can provide information to probe other squares
    frontierCells.add(clickedSquareIndex);
    while (!(mineNumber == totalFlagCount ||
        gridColumn * gridRow - totalProbedCellsCount == mineNumber)) {
      mapUpdated = false;
      List<int> keyList = frontierCells.toList();
      for (int key in keyList) {
        int row = key ~/ gridColumn;
        int col = key % gridColumn;
        CellModel square = minesGrid.getCell(row, col);
        int unprobedCount =
            minesGrid.countNeighor(square, MinesGrid.countNeighborUnprobed);
        int mineCount =
            minesGrid.countNeighor(square, MinesGrid.countNeighborMine);
        int flagCount =
            minesGrid.countNeighor(square, MinesGrid.countNeighborFlag);
        if (mineCount == unprobedCount + flagCount || mineCount == flagCount) {
          frontierCells.remove(key);
          for (CellModel neighbor in minesGrid.getNeighbors(square)) {
            if (neighbor.isEnabled) {
              neighbor.enabled = false;
              if (mineCount != flagCount) {
                neighbor.flag = true;
                totalFlagCount++;
              } else {
                frontierCells.add(neighbor.x * gridColumn + neighbor.y);
                totalProbedCellsCount++;
              }
            }
          }
          mapUpdated = true;
          break;
        }
      }

      if (mapUpdated) {
        // if SP sucesses, keep using it since it's faster than CSP
        continue;
      }

      //if SP fails, use CSP
      HashSet<Constraints> constraintsSet = HashSet<Constraints>();
      // generate constraints from info provided by frontier squares
      for (int key in keyList) {
        int row = key ~/ gridColumn;
        int col = key % gridColumn;
        CellModel cell = minesGrid.getCell(row, col);
        int mineCount =
            minesGrid.countNeighor(cell, MinesGrid.countNeighborMine);
        int flagCount =
            minesGrid.countNeighor(cell, MinesGrid.countNeighborFlag);
        Constraints cellConstraints =
            Constraints(number: (mineCount - flagCount));
        for (CellModel neighbor in minesGrid.getNeighbors(cell)) {
          if (neighbor.isEnabled) {
            int index = neighbor.x * gridColumn + neighbor.y;
            cellConstraints.add(index);
          }
        }
        if (cellConstraints.isNotEmpty) {
          constraintsSet.add(cellConstraints);
        }
      }
      // decompose constraints according to their overlaps and differences
      bool constraintsSetUpdated = true;
      while (constraintsSetUpdated) {
        constraintsSetUpdated = false;
        List<Constraints> constraintsList = constraintsSet.toList();
        for (Constraints constraints1 in constraintsList) {
          for (Constraints constraints2 in constraintsList) {
            if (!constraints1.equals(constraints2)) {
              // if constraints1 is included in constraints2
              if (isProperSubset(constraints1, constraints2)) {
                Constraints diffConstraints = Constraints();
                for (int entry2 in constraints2) {
                  if (!constraints1.contains(entry2)) {
                    diffConstraints.add(entry2);
                  }
                }
                // decompose the constraint
                int diffMineNumber = (constraints2.getMinesNumber() -
                    constraints1.getMinesNumber());
                diffConstraints.setMinesNumber(diffMineNumber);
                constraintsSetUpdated = constraintsSet.add(diffConstraints);
                constraintsSet.remove(constraints2);
              }
            }
          }
        }
      }

      // solve variables if All-Free-Neighbor or All-Mine-Neighbor
      for (Constraints constraints in constraintsSet) {
        int mines = constraints.getMinesNumber();
        if (mines == 0 || mines == constraints.size()) {
          for (int squareIndex in constraints) {
            int row = squareIndex ~/ gridColumn;
            int col = squareIndex % gridColumn;
            CellModel square = minesGrid.getCell(row, col);
            if (square.isEnabled) {
              square.enabled = (false);
              if (mines == 0) {
                // if AFN
                frontierCells.add(squareIndex);
                totalProbedCellsCount++;
              } else {
                // if AMN
                square.flag = (true);
                totalFlagCount++;
              }
            }
          }
          mapUpdated = true;
        }
      }
      if (!mapUpdated) {
        // if both SP and CSP fail, return unsolvable
        return false;
      }
    }
    return true;
  }

  bool isProperSubset(Set<dynamic> set1, Set<dynamic> set2) {
    if (set1.length > set2.length) {
      return false;
    }
    bool properSubset = true;
    for (dynamic entry1 in set1) {
      if (!set2.contains(entry1)) {
        properSubset = false;
        break;
      }
    }
    return properSubset;
  }
}

extension on List {
  bool equals(List list) {
    if (length != list.length) return false;
    return every((item) => list.contains(item));
  }
}

class Constraints implements Set<dynamic> {
  int minesNumber = 0;
  List<int> cellsIndices = [];

  Constraints({int number = 0}) {
    minesNumber = number;
  }

  int getMinesNumber() {
    return minesNumber;
  }

  void setMinesNumber(int number) {
    minesNumber = number;
  }

  // int getHashCode() {
  //   int hash = 7;
  //   print(cellsIndices.hashCode);
  //   print(cellsIndices.hashCode.hashCode);

  //   hash = 47 * hash + (cellsIndices.hashCode).hashCode;
  //   hash = 47 * hash + minesNumber.hashCode;
  //   return hash;
  // }

  bool equals(Object obj) {
    if (runtimeType != obj.runtimeType) {
      return false;
    }
    final Constraints other = obj as Constraints;
    if (minesNumber != other.minesNumber) {
      return false;
    }
    if (!cellsIndices.equals(other.cellsIndices)) {
      return false;
    }
    return true;
  }

  int size() {
    return cellsIndices.length;
  }

  @override
  bool contains(dynamic o) {
    return cellsIndices.contains(o);
  }

  List toArray() {
    return cellsIndices.toList();
  }

  @override
  bool remove(dynamic o) {
    return cellsIndices.remove(o);
  }

  @override
  void clear() {
    cellsIndices.clear();
  }

  @override
  void addAll(Iterable elements) {}

  @override
  bool any(bool Function(dynamic element) test) {
    throw UnimplementedError();
  }

  @override
  Set<R> cast<R>() {
    throw UnimplementedError();
  }

  @override
  bool containsAll(Iterable<Object?> other) {
    throw UnimplementedError();
  }

  @override
  Set difference(Set<Object?> other) {
    throw UnimplementedError();
  }

  @override
  elementAt(int index) {
    cellsIndices.elementAt(index);
  }

  @override
  bool every(bool Function(dynamic element) test) {
    throw UnimplementedError();
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(dynamic element) toElements) {
    throw UnimplementedError();
  }

  @override
  get first => cellsIndices.first;

  @override
  firstWhere(bool Function(dynamic element) test, {Function()? orElse}) {
    throw UnimplementedError();
  }

  @override
  T fold<T>(
      T initialValue, T Function(T previousValue, dynamic element) combine) {
    throw UnimplementedError();
  }

  @override
  Iterable followedBy(Iterable other) {
    throw UnimplementedError();
  }

  @override
  void forEach(void Function(dynamic element) action) {}

  @override
  Set intersection(Set<Object?> other) {
    throw UnimplementedError();
  }

  @override
  bool get isNotEmpty => cellsIndices.isNotEmpty;

  @override
  String join([String separator = ""]) {
    throw UnimplementedError();
  }

  @override
  get last => cellsIndices.last;

  @override
  lastWhere(bool Function(dynamic element) test, {Function()? orElse}) {
    throw UnimplementedError();
  }

  @override
  int get length => cellsIndices.length;

  @override
  lookup(Object? object) {
    throw UnimplementedError();
  }

  @override
  Iterable<T> map<T>(T Function(dynamic e) toElement) {
    throw UnimplementedError();
  }

  @override
  reduce(Function(dynamic value, dynamic element) combine) {
    throw UnimplementedError();
  }

  @override
  void removeAll(Iterable<Object?> elements) {}

  @override
  void removeWhere(bool Function(dynamic element) test) {}

  @override
  void retainAll(Iterable<Object?> elements) {}

  @override
  void retainWhere(bool Function(dynamic element) test) {}

  @override
  get single => throw UnimplementedError();

  @override
  singleWhere(bool Function(dynamic element) test, {Function()? orElse}) {
    throw UnimplementedError();
  }

  @override
  Iterable skip(int count) {
    throw UnimplementedError();
  }

  @override
  Iterable skipWhile(bool Function(dynamic value) test) {
    throw UnimplementedError();
  }

  @override
  Iterable take(int count) {
    throw UnimplementedError();
  }

  @override
  Iterable takeWhile(bool Function(dynamic value) test) {
    throw UnimplementedError();
  }

  @override
  List toList({bool growable = true}) {
    throw UnimplementedError();
  }

  @override
  Set toSet() {
    throw UnimplementedError();
  }

  @override
  Set union(Set other) {
    throw UnimplementedError();
  }

  @override
  Iterable where(bool Function(dynamic element) test) {
    throw UnimplementedError();
  }

  @override
  Iterable<T> whereType<T>() {
    throw UnimplementedError();
  }

  @override
  bool add(value) {
    cellsIndices.add(value);
    return true;
  }

  @override
  bool get isEmpty => cellsIndices.isEmpty;

  @override
  Iterator get iterator => cellsIndices.iterator;
}
