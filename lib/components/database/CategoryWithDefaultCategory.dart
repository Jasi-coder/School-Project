class CategoryWithDefaultCategory{
  final int? id;
  final int? default_category_id;
  final int? month_id;
  final String? categoryName;

  CategoryWithDefaultCategory(
      {required this.id, this.default_category_id, this.month_id, this.categoryName});

  factory CategoryWithDefaultCategory.fromMap(Map<String, dynamic> map) {
    return CategoryWithDefaultCategory(
        id: map['id'],
        default_category_id: map['default_category_id'],
        month_id: map['month_id'],
        categoryName: map['name']
    );
  }
}