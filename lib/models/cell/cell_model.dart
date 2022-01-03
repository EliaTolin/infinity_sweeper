class CellModel {
  final int _x;
  final int _y;
  late int _value;
  late bool _mine;
  late bool _flag;
  late bool _show;
  late bool _enabled;

  CellModel(this._x, this._y) {
    _value = 0;
    _mine = false;
    _show = false;
    _flag = false;
    _enabled = true;
  }

  int get x => _x;
  int get y => _y;
  int get value => _value;
  bool get isMine => _mine;
  bool get isFlagged => _flag;
  bool get isEnabled => _enabled;
  bool get isShowed => _show;
  void incValue() => {_value++};
  void resetValue() => {_value = 0};
  set mine(bool value) => {_mine = value};
  set flag(bool value) => {_flag = value};
  set show(bool value) => {_show = value};
  set enabled(bool value) => {_enabled = value};
}
