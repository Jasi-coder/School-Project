class Monthdata {
  final int? month_id;
  final int year;
  final int default_month_id;
  final String name;
  final String image_path;

  Monthdata(
      {required this.name,
      required this.image_path,
      this.month_id,
      required this.year,
      required this.default_month_id});

  Map<String, dynamic> toMap() {
    return {
      'month_id': month_id,
      'year': year,
      'default_month_id': default_month_id,
      'name': name,
      'image_path': image_path
    };
  }

  factory Monthdata.fromMap(Map<String, dynamic> map) {
    return Monthdata(
        month_id: map['month_id'],
        year: map['year'],
        default_month_id: map['default_month_id'],
        name: map['name'],
        image_path: map['image_path']);
  }
}
