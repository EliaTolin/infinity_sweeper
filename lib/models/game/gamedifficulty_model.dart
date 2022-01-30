enum Difficulty { easy, medium, hard }

class GameDifficulty {
  late int numMines;
  late int numRow;
  late int numCol;
  late Difficulty difficulty;

  GameDifficulty.easy() {
    numMines = 10;
    numRow = numCol = 9;
    difficulty = Difficulty.easy;
  }
  GameDifficulty.medium() {
    numMines = 40;
    numRow = numCol = 16;
    difficulty = Difficulty.medium;
  }

  GameDifficulty.hard() {
    numMines = 150;
    numRow = numCol = 30;
    difficulty = Difficulty.hard;
  }

  Difficulty getDifficulty() => difficulty;
}
