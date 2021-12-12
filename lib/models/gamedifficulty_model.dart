enum Difficulty { easy, medium, difficult }

class GameDifficulty {
  late int numMines;
  late int sizeGrid;
  late Difficulty difficulty;

  GameDifficulty.easy() {
    numMines = 1;
    sizeGrid = 9;
    difficulty = Difficulty.easy;
  }
  GameDifficulty.medium() {
    numMines = 40;
    sizeGrid = 16;
    difficulty = Difficulty.medium;
  }
  GameDifficulty.difficulty() {
    numMines = 243;
    sizeGrid = 30;
    difficulty = Difficulty.difficult;
  }

  Difficulty getDifficulty() => difficulty;
}
