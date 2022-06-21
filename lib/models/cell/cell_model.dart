class CellModel {
  final int _x;
  final int _y;
  final int _index;
  late int _value;
  late bool _mine;
  late bool _flag;
  late bool _show;
  late bool _enabled;
  late bool _loseCell;

  CellModel(this._x, this._y, this._index) {
    _value = 0;
    _mine = false;
    _show = false;
    _flag = false;
    _enabled = true;
    _loseCell = false;
  }

  int get x => _x;
  int get y => _y;
  int get value => _value;
  int get index => _index;
  bool get isMine => _mine;
  bool get isFlagged => _flag;
  bool get isEnabled => _enabled;
  bool get isShowed => _show;
  bool get isLosedCell => _loseCell;

  void incValue() => {_value++};
  void resetValue() => {_value = 0};
  set mine(bool value) => {_mine = value};
  set flag(bool value) => {_flag = value};
  set show(bool value) => {_show = value};
  set enabled(bool value) => {_enabled = value};
  set losed(bool value) => {_loseCell = value};
}
