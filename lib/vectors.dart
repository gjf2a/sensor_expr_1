

import 'package:intl/intl.dart';

class Vector {
  double _x, _y, _z;
  NumberFormat _format = NumberFormat(".00", "en_US");

  Vector(this._x, this._y, this._z);

  Vector operator + (Vector other) => Vector(_x + other._x, _y + other._y, _z + other._z);
  Vector operator - (Vector other) => Vector(_x - other._x, _y - other._y, _z - other._z);
  Vector operator - () => Vector(-_x, -_y, -_z);
  Vector operator * (double scalar) => Vector(_x * scalar, _y * scalar, _z * scalar);
  Vector operator / (double scalar) => this * (1.0 / scalar);

  bool operator ==(o) => o is Vector && _x == o._x && _y == o._y && _z == o._z;

  String toString() => '${_x}i${_innerVal(_y)}j${_innerVal(_z)}k';

  String uiString() => '(${_format.format(_x)},${_format.format(_y)},${_format.format(_z)})';
}

String _innerVal(double d) => d < 0 ? "$d" : "+$d";

class Averager {
  Vector _total = Vector(0, 0, 0);
  Vector _last = Vector(0, 0, 0);
  double _count = 0;

  void accumulate(Vector v) {
    _last = v;
    _total += v;
    _count += 1.0;
  }

  void reset() {
    _total = Vector(0, 0, 0);
    _count = 0;
  }

  Vector get average => _count == 0 ? Vector(0, 0, 0) : _total / _count;

  Vector get last => _last;
}