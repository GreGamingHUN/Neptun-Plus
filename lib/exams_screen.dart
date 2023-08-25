import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neptunplus_flutter/neptun_connection.dart';

class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: FutureBuilder(
                  future: getPeriodTermsList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List? periodTermsList = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField2(
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onChanged: (value) => print(value),
                            items: periodTermsList!
                                .map((item) => DropdownMenuItem(
                                      child: Text(item['TermName']),
                                      value: item['Id'],
                                    ))
                                .toList()),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

Future<List> getPeriodTermsList() async {
  List periodTermsList = List.empty();
  try {
    periodTermsList = await getPeriodTerms();
  } on NeptunErrorMessage catch (e) {
    Fluttertoast.showToast(msg: 'Neptun hiba: ${e.errorMessage}');
  }
  return periodTermsList;
}
