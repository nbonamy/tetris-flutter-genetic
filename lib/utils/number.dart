import 'dart:math';

class NumberUtils {
  static double toPrecision(double number, int fractionDigits) {
    double mod = pow(10, fractionDigits.toDouble()).toDouble();
    return ((number * mod).round().toDouble() / mod);
  }
}
