class CustomDate {
  DateTime date;

  CustomDate({required this.date});

  @override
  String toString() {
    String finalString = '${date.year}-${date.month}-${date.day}';
    return finalString;
  }
}
