import 'package:capture_costs_for_household/components/database/monthData.dart';
import 'package:flutter/material.dart';
import 'package:capture_costs_for_household/components/add_new_month_view.dart';
import 'package:capture_costs_for_household/components/button.dart';
import 'package:capture_costs_for_household/components/database/database_helper.dart';
import 'package:capture_costs_for_household/components/month_inview_page.dart';
import 'package:capture_costs_for_household/components/notizen.dart';

class Menupage extends StatefulWidget {
  const Menupage({super.key});

  @override
  State<Menupage> createState() => _MenupageState();
}

class _MenupageState extends State<Menupage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Monthdata> _months = [];

  @override
  void initState() {
    super.initState();
    _loadMoths();
  }

  Future<int> _insertCurrentMonthAndCategory(int monthId) async {
    final result =
        await _databaseHelper.insertInCurrentSelectedAttributeMonths(monthId);
    return result;
  }

  Future<void> _loadMoths() async {
    final monthsWithAllData = await _databaseHelper.getDefaultMonthsByMonths();

    setState(() {
      _months = monthsWithAllData;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 165, 202, 215),
      appBar: AppBar(
        title: const Text("H A U S H A L T"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu),
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
                color: const Color.fromARGB(255, 241, 193, 148),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 1.0),
                  child: SizedBox(
                    width: screenSize.width * 0.55, //210,
                    height: screenSize.height * 0.045, //40,
                    child: const Column(
                      children: [
                        Text(
                          "Monatsübersicht",
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  // height: screenSize.height * 0.08, //70,
                  width: screenSize.width * 0.2, //80,
                  child: Column(
                    children: [
                      Image.asset(
                        "lib/images/calculation.png",
                        height: screenSize.height * 0.08, // 70,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.01, //10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 213, 241, 148),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 SizedBox(
                  width: screenSize.width * 0.65,//260,
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Neue Monatskachel erstellen hier über den Button",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 176, 221, 72),
                      borderRadius: BorderRadius.circular(40)),
                  child: IconButton(
                    padding: const EdgeInsets.all(10),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddNewMonthView(),
                        ),
                      );
                      await _loadMoths();
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
           SizedBox(
            height: screenSize.height * 0.01, //10,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              "Bestehende Monatskacheln durch klick öffnen :",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
           SizedBox(
            height: screenSize.height * 0.01, //10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _months.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final month = _months[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  padding: const EdgeInsets.all(8),
                  width: 160,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 61, 91, 212),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      _insertCurrentMonthAndCategory(month.month_id!);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MonthInview(),
                        ),
                      );

                      await _loadMoths();
                    },
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 61, 91, 212),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              month.name,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${month.default_month_id}.${month.year}",
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                             SizedBox(
                              height: screenSize.height * 0.01, //10,
                            ),
                            Image.asset(
                              month.image_path,
                              height: 100,
                            ),
                          ],
                        )),
                  ),
                );
              },
            ),
          ),
           SizedBox(
            height: screenSize.height * 0.01, //10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 213, 241, 148),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Wichtige Notizen erfassen",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                       SizedBox(
                        height: screenSize.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MyButton(
                              mytext: "zu meinen Notizen",
                              event: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NotizenSeite()),
                                );
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  "lib/images/budget (1).png",
                  height: 80,
                ),
              ],
            ),
          ),
           SizedBox(
            height: screenSize.height * 0.02,
          ),
        ],
      ),
    );
  }
}
