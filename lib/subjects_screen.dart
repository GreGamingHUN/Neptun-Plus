import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:neptunplus_app/api_calls.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  List periodTermsList = [];
  String selectedValue = '';
  String? selectedPeriodId = '';
  List subjectsList = [];

  Future<dynamic> getPeriodTermsData() async {
    List tmp = await apiCalls.getPeriodTerms();
    if (periodTermsList.isEmpty) {
      for (var i = 0; i < tmp.length; i++) {
        periodTermsList.add(tmp[i]);
      }
    }
    print(periodTermsList);
    return periodTermsList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPeriodTermsData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Tárgyak',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    child: DropdownButtonFormField2(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Félév',
                        style: TextStyle(fontSize: 14),
                      ),
                      items: periodTermsList
                          .map((item) => DropdownMenuItem<String>(
                                value: item['Id'].toString(),
                                child: Text(
                                  item['TermName'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Válassz ki egy félévet';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          print(periodTermsList);
                          print(value);
                          selectedPeriodId = value;
                        });
                      },
                      onSaved: (value) {
                        selectedValue = value.toString();
                      },
                      buttonStyleData: const ButtonStyleData(
                        width: 80,
                        height: 50,
                        padding: EdgeInsets.only(left: 20, right: 10),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SubjectCardsContainer(
                  periodId: selectedPeriodId,
                ),
              )
            ],
          );
        } else if (snapshot.hasError) {
          return const Text('Valami elbaszodott');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class SubjectCardsContainer extends StatefulWidget {
  final String? periodId;
  SubjectCardsContainer({this.periodId}) : super(key: ValueKey(periodId));

  @override
  State<SubjectCardsContainer> createState() => _SubjectCardsContainerState();
}

class _SubjectCardsContainerState extends State<SubjectCardsContainer> {
  List subjectList = [];
  Future<dynamic> getAddedSubjectsData(periodId) async {
    subjectList = await apiCalls.getAddedSubjects(periodId);
    return subjectList;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.periodId == null || widget.periodId == '') {
      return const Text('asd');
    }
    return FutureBuilder(
      future: getAddedSubjectsData(widget.periodId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(subjectList);
          return ListView.builder(
            itemCount: subjectList.length,
            itemBuilder: (context, index) {
              return Text(subjectList[index]['SubjectName']);
            },
          );
        } else if (snapshot.hasError) {
          return const Text('jani nem jo');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class SubjectCard extends StatefulWidget {
  const SubjectCard({super.key});

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  @override
  Widget build(BuildContext context) {
    return const Text('cum');
  }
}
