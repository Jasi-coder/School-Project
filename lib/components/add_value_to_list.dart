import 'package:capture_costs_for_household/components/cathegori_capture_cost.dart';
import 'package:flutter/material.dart';

import 'database/database_helper.dart';
import 'database/entry.dart';

class AddItem extends StatefulWidget {
  final Entry? entry;

  const AddItem({super.key, this.entry});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final _entryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int categoryId = 0;
  int monthId = 0;
  int default_category = 0;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _entryController.text = (widget.entry!.amount).toString();
    }
    getCategory();
  }

  Future<void> _loadEntries() async {
    final monthEnries =
        await _databaseHelper.getEntryByMonthId(monthId, categoryId);
  }

  Future<void> getCategory() async {
    final categoryData = await _databaseHelper.selectedCategory();
    if (categoryData[0] != null) {
      setState(() {
        categoryId = categoryData[1].value;
        monthId = categoryData[0].value;
      });
    }
    final categoryName = await _databaseHelper
        .getDefaultCategoriesByDefaultCategoryId(categoryId, monthId);
    if (categoryName[0] != null) {
      setState(() {
        default_category = categoryName[0]["default_category_id"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Betrag hinzufügen'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _entryController,
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.02, //20,
              ),
              ElevatedButton(
                onPressed: () async {
                  _saveEntry();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CaptureCostForKathegori(),
                    ),
                  );
                },
                child: const Text('Hinzufügen'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      final entry = Entry(
          categoriesID: categoryId,
          amount: double.parse(_entryController.text),
          month_id: monthId);

      if (widget.entry == null) {
        await _databaseHelper.insertEntry(entry);
      }
    }
  }
}
