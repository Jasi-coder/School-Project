import 'package:flutter/material.dart';
import 'package:capture_costs_for_household/components/database/database_helper.dart';
import 'package:capture_costs_for_household/components/database/months.dart';
import 'package:capture_costs_for_household/components/menu_page.dart';

class AddNewMonthView extends StatefulWidget {
  final Months? month;

  const AddNewMonthView({super.key, this.month});

  @override
  State<AddNewMonthView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddNewMonthView> {
  final DatabaseHelper _databaseHelperMonths = DatabaseHelper();
  final _dropdownFormKey = GlobalKey<FormState>();
  final _enterYearController = TextEditingController();
  final _enterMonthDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.month != null) {
      _enterYearController.text = widget.month!.year as String;
      _enterMonthDateController.text = widget.month!.default_month_id as String;
    }
  }

  List<String> months = [
    '01 - Januar',
    '02 - Februar',
    '03 - März',
    '04 - April',
    '05 - Mai',
    '06 - Juni',
    '07 - Juli',
    '08 - August',
    '09 - September',
    '10 - Oktober',
    '11 - November',
    '12 - Dezember'
  ];
  String? _selectedMonth = null;
  bool displayMonthList = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            widget.month == null
                ? 'Neuen Monat hinzufügen'
                : 'Monat bearbeiten bearbeiten',
            style: const TextStyle(fontSize: 25),
          ),
        ),
        body: Form(
          key: _dropdownFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                        "Bitte geben Sie das Jahr an (Beispiel: 2024,...)",
                        style: TextStyle(fontSize: 17)),
                    SizedBox(
                      height: screenSize.height * 0.01,
                    ),
                    SizedBox(
                      width: screenSize.width * 0.6,
                      height: screenSize.height * 0.065,
                      child: TextFormField(
                        controller: _enterYearController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Jahr",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.black, width: 4),
                          ),
                        ),
                        validator: (value) =>
                            value == '' ? "Gib ein Jahr ein!" : null,
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.04,
                    ),
                    const Text(
                        "Bitte geben Sie den Monat als Zahl an (Beispiel: 01 (für Januar),...)",
                        style: TextStyle(fontSize: 17)),
                    SizedBox(
                      height: screenSize.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            inputField(),
                            displayMonthList
                                ? selectionField()
                                : const SizedBox(),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        if (_dropdownFormKey.currentState!.validate()) {
                          _saveMonth();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Menupage(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF50C878),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "Speichern",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget inputField() {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width * 0.6,
      height: screenSize.height * 0.065,

      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _enterMonthDateController,
        decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  displayMonthList = !displayMonthList;
                });
              },
              child: const Icon(
                Icons.arrow_drop_down,
                size: 36,
              ),
            )),
      ),
    );
  }

  Widget selectionField() {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.2,
      width: screenSize.width * 0.6,
      decoration: BoxDecoration(
          // border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ]),
      child: ListView.builder(
          itemCount: months.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final month = months[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _enterMonthDateController.text = month;
                });
              },
              child: ListTile(
                title: Text(months[index]),
              ),
            );
          }),
    );
  }

  DropdownMenuItem<String> buildMenuItems(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );

  Future<void> _saveMonth() async {
    final month = Months(
      //month_id: widget.month?.month_id,
      year: int.parse(_enterYearController.text),
      default_month_id:
          int.parse((_enterMonthDateController.text).split('-')[0]),
    );
    if (widget.month == null) {
      await _databaseHelperMonths.insertMonth(month);
      await _databaseHelperMonths.createAllCategories();
    }
  }
}
