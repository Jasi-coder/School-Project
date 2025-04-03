class MonthDataWithCategory{
  final int year;
  final int default_month_id;
  final int id;
  final int default_category_id;
  final int month_id;

  MonthDataWithCategory(
      {required this.year,
      required this.default_month_id,
      required this.id,
      required this.default_category_id,
      required this.month_id});

  Map<String, dynamic> toMap() {
    return{
      'year':year,
      'default_category_id':default_category_id,
      'default_month_id': default_month_id,
      'id': id,
      'month_id': month_id
    };
  }

  factory MonthDataWithCategory.fromMap(Map<String, dynamic> map) {
    return MonthDataWithCategory(
        year: map['year'],
        default_category_id: map['default_category_id'],
        default_month_id: map['default_month_id'],
        id: map['id'],
        month_id: map['month_id']);
  }
}