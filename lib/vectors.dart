import 'package:intl/intl.dart';

class Value3D {
  double _x, _y, _z;
  NumberFormat _format = NumberFormat(".00", "en_US");

  Value3D(this._x, this._y, this._z);

  Value3D operator + (Value3D other) => Value3D(_x + other._x, _y + other._y, _z + other._z);
  Value3D operator - (Value3D other) => Value3D(_x - other._x, _y - other._y, _z - other._z);
  Value3D operator - () => Value3D(-_x, -_y, -_z);
  Value3D operator * (double scalar) => Value3D(_x * scalar, _y * scalar, _z * scalar);
  Value3D operator / (double scalar) => this * (1.0 / scalar);

  Value3D mean(Value3D other) => (this + other) / 2;

  bool operator ==(o) => o is Value3D && _x == o._x && _y == o._y && _z == o._z;
  bool approxEq(Value3D other, double tolerance) =>
      closeTo(_x, other._x, tolerance)
      && closeTo(_y, other._y, tolerance)
      && closeTo(_z, other._z, tolerance);

  String toString() => '($_x,$_y,$_z)';

  String uiString() => '(${_format.format(_x)},${_format.format(_y)},${_format.format(_z)})';
}

bool closeTo(double a, double b, double tolerance) => (a - b).abs() < tolerance;

class Averager {
  Value3D _total = Value3D(0, 0, 0);
  Value3D _last = Value3D(0, 0, 0);
  double _count = 0;

  void accumulate(Value3D v) {
    _last = v;
    _total += v;
    _count += 1.0;
  }

  void reset() {
    _total = Value3D(0, 0, 0);
    _count = 0;
  }

  Value3D get average => _count == 0 ? Value3D(0, 0, 0) : _total / _count;

  Value3D get last => _last;
}

class TimeStamped3D {
  double _stamp_sec;
  Value3D _value;

  TimeStamped3D(this._value, this._stamp_sec);

  TimeStamped3D.zeros() {
    _value = Value3D(0, 0, 0);
    _stamp_sec = 0;
  }

  bool operator ==(o) => o is TimeStamped3D && value == o.value && stamp_sec == o.stamp_sec;

  bool approxEq(TimeStamped3D other, double tolerance) =>
      value.approxEq(other.value, tolerance)
      && closeTo(stamp_sec, other.stamp_sec, tolerance);

  String toString() => '$value;${stamp_sec}s';

  TimeStamped3D operator + (TimeStamped3D later) =>
    TimeStamped3D(_value + later.value, later._stamp_sec);

  TimeStamped3D interpolate(TimeStamped3D later) =>
      TimeStamped3D(_value.mean(later.value) * (later._stamp_sec - _stamp_sec), later._stamp_sec);

  Value3D get value => _value;
  double get stamp_sec => _stamp_sec;
}

class Estimator {
  TimeStamped3D _position, _velocity, _acceleration, _prevAcceleration;
  int _numReadings = 0;

  Estimator() {
    _position = TimeStamped3D.zeros();
    _velocity = TimeStamped3D.zeros();
    _acceleration = TimeStamped3D.zeros();
    _prevAcceleration = TimeStamped3D.zeros();
  }

  bool get ready => _numReadings >= 3;
  TimeStamped3D get position => _position;
  TimeStamped3D get velocity => _velocity;
  int get numReadings => _numReadings;

  void add(TimeStamped3D accelerometerReading) {
    if (_numReadings == 0) {
      _prevAcceleration = accelerometerReading;
    } else if (_numReadings == 1) {
      _acceleration = accelerometerReading;
      _velocity = _prevAcceleration.interpolate(_acceleration);
    } else {
      var velocityUpdate = _acceleration.interpolate(accelerometerReading);
      var newVelocity = _velocity + velocityUpdate;
      var positionUpdate = _velocity.interpolate(newVelocity);
      _prevAcceleration = _acceleration;
      _acceleration = accelerometerReading;
      _velocity = newVelocity;
      _position += positionUpdate;
    }
    _numReadings += 1;
  }
}