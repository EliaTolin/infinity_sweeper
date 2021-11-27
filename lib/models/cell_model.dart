class CellModel {
  final int _x;
  final int _y;
  late int _value;
  late bool _mine;
  late bool _flag;

  CellModel(this._x, this._y) {
    _value = 0;
  }

  int get x => _x;
  int get y => _y;
  int get value => _value;
  bool get isMine => _mine;
  bool get isFlaged => _flag;

  void incValue() => {_value++};
  set mine(bool value) => {_mine = value};
  set flagged(bool value) => {_flag = value};
}
