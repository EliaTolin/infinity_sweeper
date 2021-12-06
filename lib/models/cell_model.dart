class CellModel {
  final int _x;
  final int _y;
  late int _value;
  late bool _mine;
  late bool _flag;
  late bool _show;
  CellModel(this._x, this._y) {
    _value = 0;
    _mine = false;
    _show = false;
    _flag = false;
  }

  int get x => _x;
  int get y => _y;
  int get value => _value;
  bool get isMine => _mine;
  bool get isFlaged => _flag;
  bool get isShowed => _show;
  void incValue() => {_value++};
  set mine(bool value) => {_mine = value};
  set flag(bool value) => {_flag = value};
  set show(bool value) => {_show = value};
}
