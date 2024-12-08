enum DateCompare {
  at,
  before,
  after;

  @override
  String toString() => {
        at: 'at',
        before: 'before',
        after: 'after',
      }[this]!;
}
