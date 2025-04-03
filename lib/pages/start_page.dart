import 'package:flutter/material.dart';
import 'package:capture_costs_for_household/components/button.dart';
import 'package:capture_costs_for_household/components/menu_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 178, 255),
      body: SafeArea(

          child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "KOSTENERFASSUNG",
                style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
           SizedBox(height: screenSize.height * 0.012),
          Center(child: Image.asset("lib/images/budget.png", height: 300)),
           SizedBox(height: screenSize.height * 0.012),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 70.0),
            child: Text(
              "Kosten erfassen für den Haushalt!",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
           SizedBox(
            height: screenSize.height * 0.02,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 70.0),
            child: Text(
              "Mit dieser App können sie Kosten für den Haushalt erfassen. Die App ermöglicht die Erfassung für verschiedene Kathegorien wie Lebensmittel, Getränke etc.",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
          ),
           SizedBox(height: screenSize.height * 0.05),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: MyButton(
                mytext: "Zur Übersicht",
                event: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Menupage(),
                    ),
                  );
                }),
          ),
        ],
      )),
    );
  }
}
