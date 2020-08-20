import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_expr_1/vectors.dart';
void main() {
  test('one', () {
    Vector v1 = Vector(1, 2, 3);
    expect(-v1, Vector(-1, -2, -3));
    expect(v1.toString(), "1.0i+2.0j+3.0k");
    expect((-v1).toString(), "-1.0i-2.0j-3.0k");

    Vector v2 = Vector(4, 5, 6);
    expect(v1 + v2, Vector(5, 7, 9));
    expect(v1 - v2, Vector(-3, -3, -3));
    expect(v2 - v1, Vector(3, 3, 3));
  });

  test('formatting', () {
    Vector v = Vector(1000.48888, 100.008, 1.49999);
    expect(v.uiString(), '(1000.49,100.01,1.50)');
  });

  test('averaging', () {
    Averager avg = Averager();
    avg.accumulate(Vector(1, 1, 1));
    expect(avg.last, Vector(1, 1, 1));
    avg.accumulate(Vector(2, 0, 5));
    expect(avg.last, Vector(2, 0, 5));
    expect(avg.average, Vector(1.5, 0.5, 3.0));
  });
}