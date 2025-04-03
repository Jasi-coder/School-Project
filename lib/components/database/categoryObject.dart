class CategoryObject{
  final int? id;
  final int month_id;
  final int? categoriesID;
  final double amount;
  final int default_category_id;

  CategoryObject({required this.categoriesID, required this.default_category_id,required this.month_id, required this.id, required this.amount});

  factory CategoryObject.fromMap(Map<String, dynamic> map) {
    return CategoryObject(
        id: map['id'],
        default_category_id: map['default_category_id'],
        month_id: map['month_id'],
        amount: map['amount'],
        categoriesID: map['category_id']);
  }


}