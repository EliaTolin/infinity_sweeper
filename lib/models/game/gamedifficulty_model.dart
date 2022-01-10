enum Difficulty { easy, medium, difficult }

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

  GameDifficulty.difficulty() {
    numMines = 150;
    numRow = numCol = 30;
    difficulty = Difficulty.difficult;
  }

  Difficulty getDifficulty() => difficulty;
}
