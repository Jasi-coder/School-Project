import 'package:flutter/material.dart';
import 'package:capture_costs_for_household/components/cathegori_capture_cost.dart';
import 'package:capture_costs_for_household/components/database/database_helper.dart';

import 'database/current_selected_attribute.dart';
import 'menu_page.dart';

class MonthInview extends StatefulWidget {
  const MonthInview({
    super.key,
  });

  @override
  State<MonthInview> createState() => _MonthInviewState();
}

class _MonthInviewState extends State<MonthInview> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  int _month_id = 0;
  List<CurrentSelectedAttribute> _currentData = [];
  String currentAsset =
      "lib/images/accounting.png"; // ich setzte hier am Anfang ein default asset, da es ansonsten Probleme gibt
  String currentMonth = "";

  @override
  void initState() {
    super.initState();

    _loadMothsCategories();
  }

  Future<void> _loadMothsCategories() async {
    final month = await _databaseHelper.selectedMonth();
    final List monthData;

    setState(() {
      _currentData = month;
    });

    var mId = month[0].value;
    if (month[0].value != null) {
      monthData = await _databaseHelper.getDefaultMonthByMonthId(mId!);
      if (monthData[0] != null) {
        setState(() {
          currentAsset = monthData[0]["image_path"];
          currentMonth = monthData[0]["name"];
          _month_id = monthData[0]["month_id"];
        });
      }
    }
  }

  Future<int> _insertCurrentCategoryID(int categoryId) async {
    final result = await _databaseHelper
        .insertInCurrentSelectedAttributeCategory(categoryId);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 165, 202, 215),
      appBar: AppBar(
        title: const Text("KOSTEN ERFASSEN"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Menupage(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.dark_mode),
          ),
          const Padding(
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
                color: const Color.fromARGB(255, 19, 46, 165),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentMonth,
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Image.asset(
                    currentAsset,
                    height: screenSize.height * 0.06, //50,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.02,
          ),
          Container(
            padding: const EdgeInsets.all(25),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 150, 165, 229),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "lib/images/healthy-drink.png",
                  height: screenSize.height * 0.06, //50,
                ),
                const Text(
                  "LEBENSMITTEL",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    _insertCurrentCategoryID(1);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CaptureCostForKathegori(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.03,
          ),
          Container(
            padding: const EdgeInsets.all(25),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 150, 165, 229),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "lib/images/gas-station.png",
                  height: screenSize.height * 0.06, //50,
                ),
                const Text(
                  "TANKEN (SPRIT)",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    _insertCurrentCategoryID(2);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CaptureCostForKathegori(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.03,
          ),
          Container(
            padding: const EdgeInsets.all(25),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 150, 165, 229),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "lib/images/clothes-hanger (3).png",
                  height: screenSize.height * 0.06, //50,
                ),
                const Text(
                  "KLEIDUNGEN",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    _insertCurrentCategoryID(3);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CaptureCostForKathegori(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.03,
          ),
          Container(
            padding: const EdgeInsets.all(25),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 150, 165, 229),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "lib/images/box (2).png",
                  height: screenSize.height * 0.06, //50,
                ),
                const Text(
                  "SONSTIGES",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    _insertCurrentCategoryID(4);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CaptureCostForKathegori(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
