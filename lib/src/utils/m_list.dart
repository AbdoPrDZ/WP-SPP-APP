/// Extension for List
extension MList<T> on List<T> {
  /// Get element at index, if index is out of range, it will return null
  ///
  /// Usage:
  /// ```dart
  /// final list = [1, 2, 3, 4, 5];
  ///
  /// print("0: " + list.getOrNull(0));
  /// print("5: " + list.getOrNull(5));
  /// ```
  ///
  /// Output:
  /// ```log
  /// 0: 1
  /// 5: null
  /// ```
  T? getOrNull(int index) {
    if (index >= length) {
      return null;
    }

    return this[index];
  }

  /// Get element at index, if index is negative, it will be treated as index from the end of the list
  ///
  /// Usage:
  /// ```dart
  /// final list = [1, 2, 3, 4, 5];
  ///
  /// print("-1: " + list[-1]);
  /// print("-2: " + list[-2]);
  /// ```
  ///
  /// Output:
  /// ```log
  /// -1: 5
  /// -2: 4
  /// ```
  T operator [](int index) {
    if (index < 0) {
      index = length + index;
    }

    return this[index];
  }
}
