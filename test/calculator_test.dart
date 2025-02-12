import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Calculator Tests', () {
    test('Addition Test', () {
      expect(2 + 3, 5);
    });

    test('Subtraction Test', () {
      expect(5 - 2, 3);
    });

    test('Multiplication Test', () {
      expect(3 * 4, 12);
    });

    test('Division Test', () {
      expect(10 / 2, 5);
    });

    test('Division by Zero Test', () {
      expect(10 / 0, double.infinity);
    });
  });
}
