import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ewg_maker_checker/providers/client_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_table.dart';


class ClientDetailsPage extends StatefulWidget {
  const ClientDetailsPage({Key? key}) : super(key: key);

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {
  TextEditingController _searchController2 = TextEditingController();
  List<String> _flags = ["All", "AllActive", "Pending", "Rejected", "Approved"];
  String flag = "Pending";

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientDetailsProvider>(
      builder: (context, ClientDetailsProvider clientDetailsProvider, _) {
        return Container(
          padding: const EdgeInsets.only(top: 32.0),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 32.0, right: 32.0),
            child: SingleChildScrollView(child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Roles Management",
                      style: TextStyle(
                          color: Color(0xff461257),
                          fontFamily: 'SemiBold',
                          fontSize: 30),
                    ),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _searchController2,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Search Clients",
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          suffixIcon: Icon(
                            Icons.search_rounded,
                            color: Color(0xff461257),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff461257), width: 1.5),
                              borderRadius: BorderRadius.circular(7)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff461257), width: 1.5),
                              borderRadius: BorderRadius.circular(7)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff461257), width: 1.5),
                              borderRadius: BorderRadius.circular(7)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff461257), width: 1.5),
                              borderRadius: BorderRadius.circular(7)),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // OutlinedButton(
                      //     onPressed: () {},
                      //     child: Text(
                      //       'All Clients',
                      //     ),
                      //   style: OutlinedButton.styleFrom(
                      //     padding: EdgeInsets.all(20.0),
                      //     side: BorderSide(color: Color(0xff461257), width: 1)
                      //   ),
                      // ),
                      DropdownButton2<String>(
                        value: flag,
                        underline: Container(),
                        buttonPadding: EdgeInsets.symmetric(horizontal: 12),
                        buttonDecoration: BoxDecoration(
                          border: Border.all(color: Color(0xff461257,), width: 2),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        style: TextStyle(fontSize: 16),
                        items: _flags.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 16, fontFamily: 'SemiBold'),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          /// `log("DROPDOWN VALUE ====> ");` is logging the selected value
                          /// from the dropdown menu to the console for debugging purposes.
                          log("DROPDOWN VALUE ====> $newValue");
                          setState(() {
                            flag = newValue!;
                          });

                          /// `clientDetailsProvider.fetchClientDetails(context, flag);` is calling a
                          /// method `fetchClientDetails` on the `clientDetailsProvider` object with two
                          /// arguments: `context` and `flag`. This method is likely responsible for
                          /// fetching client details data from an API or database based on the selected
                          /// `flag` value and updating the state of the `clientDetailsProvider` object
                          /// with the fetched data. The `setState` method is also called to update the
                          /// state of the widget with the new `flag` value.
                          clientDetailsProvider.fetchClientDetails(context, flag);
                        },
                      ),
                      Expanded(
                        child: SizedBox(
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: ElevatedButton(
                            onPressed: (){},
                            child: Text(
                              "Filters",
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(20.0),
                            backgroundColor: Color(0xff461257)
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (){},
                        child: Text(
                            "Create New Role",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(20.0),
                            backgroundColor: Color(0xff461257)
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  /*constraints:BoxConstraints(
                    maxHeight: double.maxFinite,
                  ),*/
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1,color: Color(0xff461257),),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child:
                  DataTableWidget(flag: flag,),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ));
      }
    );
  }
}
