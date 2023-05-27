class Task {
  int id;
  String isIncome;
  String title;
  String category;
  int amount;
  DateTime date;

  Task({this.isIncome, this.title, this.category, this.amount, this.date});

  Task.withId(
      {this.id,
      this.isIncome,
      this.title,
      this.category,
      this.amount,
      this.date});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = id;
    }
    map['isIncome'] = isIncome;
    map['title'] = title;
    map['category'] = category;
    map['amount'] = amount;
    map['date'] = date.toIso8601String();

    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
      id: map['id'],
      isIncome: map['isIncome'],
      title: map['title'],
      category: map['category'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }
}
