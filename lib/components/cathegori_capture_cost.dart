import 'package:capture_costs_for_household/components/add_value_to_list.dart';
import 'package:capture_costs_for_household/components/database/entry.dart';
import 'package:capture_costs_for_household/components/database/monthDataWithCategory.dart';
import 'package:flutter/material.dart';
import 'package:capture_costs_for_household/components/database/database_helper.dart';

import 'month_inview_page.dart';

class CaptureCostForKathegori extends StatefulWidget {
  final MonthDataWithCategory? category;

  const CaptureCostForKathegori({super.key, this.category});

  @override
  State<CaptureCostForKathegori> createState() =>
      _CaptureCostForKathegoriState();
}

class _CaptureCostForKathegoriState extends State<CaptureCostForKathegori> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();

  final _editEntryController = TextEditingController();

  List<dynamic> _entries = [];
  double _totalCosts = 0;
  int currentCategoryId = 0;
  int currentMonthId = 0;
  String currentCategoryName = "";

  @override
  void initState() {
    super.initState();

    _loadCategoryData();
  }

  Future<void> _loadCategoryData() async {
    final currentCategory = await _databaseHelper.selectedCategory();
    if (currentCategory[0] != null) {
      setState(() {
        currentCategoryId = currentCategory[1].value;
        currentMonthId = currentCategory[0].value;
        _loadCategoryName();
        _loadEntries();
      });
    }
  }

  Future<void> _loadCategoryName() async {
    final categoryName =
        await _databaseHelper.getDefaultCategoriesByDefaultCategoryId(
            currentCategoryId, currentMonthId);

    if (categoryName[0] != null) {
      if (categoryName[0]["name"] != null) {
        setState(() {
          currentCategoryName = categoryName[0]["name"];
        });
      }
    }
  }

  Future<void> _loadEntries() async {
    final allEntries = await _databaseHelper.getEntryByMonthId(
        currentMonthId, currentCategoryId);
    final totalCosts = await _databaseHelper.getEntrySumOfPrices(
        currentMonthId, currentCategoryId);

    setState(() {
      _entries = allEntries;
      if (totalCosts[0]["sum_of_prices"] != null) {
        _totalCosts = totalCosts[0]["sum_of_prices"];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 165, 202, 215),
      appBar: AppBar(
        title: Text(currentCategoryName),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MonthInview(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 210, 241, 148),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      "Gesamtkosten   $_totalCosts  €",
                      style: const TextStyle(fontSize: 22),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.04, // 15,
          ),
          SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Container(
              height: screenSize.height * 0.6,
              // 500,
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return Card(
                    color: const Color.fromARGB(255, 199, 188, 188),
                    child: ListTile(
                      title: Text(
                        "${entry["amount"]} €",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: SizedBox(
                        width: screenSize.width * 0.15, // 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: Tooltip(
                                message: 'Betrag ändern',
                                child: IconButton(
                                  hoverColor:
                                      const Color.fromARGB(255, 122, 236, 126),
                                  onPressed: () =>
                                      _dialogBuilderEditValue(context, entry),
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.05, //3,
                            ),
                            Expanded(
                              child: Tooltip(
                                message: 'Betrag löschen',
                                child: IconButton(
                                    hoverColor: const Color.fromARGB(
                                        248, 248, 123, 101),
                                    onPressed: () => _dialogBuilderDeleteValue(
                                        context, entry["id"]),

                                    // brauche hier enin delete entry
                                    icon: const Icon(Icons.delete)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _databaseHelper
              .insertInCurrentSelectedAttributeCategory(currentCategoryId);
          await _databaseHelper
              .insertInCurrentSelectedAttributeMonths(currentMonthId);
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddItem(),
              ),
            );
          }
          _loadEntries();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _dialogBuilderEditValue(BuildContext context, entry) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: const Text('Betrag abändern'),
            content: TextField(
              controller: _editEntryController,
              decoration: InputDecoration(
                hintText: (entry["amount"]).toString(),
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 122, 236, 126),
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text(
                      'BESTÄTIGEN',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _databaseHelper.updateEntry(Entry(
                            id: entry["id"],
                            categoriesID: entry["category_id"],
                            amount: double.parse(_editEntryController.text),
                            month_id: entry["month_id"]));
                      }
                      await _loadEntries();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(248, 248, 123, 101),
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text(
                      'ABBRECHEN ',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<void> _showDeleteDialog(BuildContext context, int index) async {
  //   final confirm = await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       title: const Text(
  //         "Notiz löschen",
  //         style: TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       content: const Text(
  //         "Bist du sicher das du diese Notiz löschen möchtest?",
  //         style: TextStyle(
  //           color: Colors.black54,
  //           fontSize: 16,
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, false),
  //           child: Text(
  //             "Abbrechen",
  //             style: TextStyle(
  //                 color: Colors.grey[600], fontWeight: FontWeight.w600),
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, true),
  //           child: const Text(
  //             "Löschen",
  //             style: TextStyle(
  //                 color: Colors.redAccent, fontWeight: FontWeight.w600),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  //   if (confirm == true) {
  //     await _databaseHelper.deleteEntry(index);
  //     //Navigator.pop(context);
  //   }
  // }

  Future<void> _dialogBuilderDeleteValue(BuildContext context, int index) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Möchten sie diesen Eintrag wirklich löschen?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 122, 236, 126),
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text(
                    'BESTÄTIGEN',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    _deleteEntry(index);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(248, 248, 123, 101),
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text(
                    'ABBRECHEN ',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEntry(int index) async {
    await _databaseHelper.deleteEntry(index);
    await _loadEntries();
  }
}
