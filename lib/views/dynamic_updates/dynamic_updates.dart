import 'package:flutter/material.dart';

class DynamicUpdatesPage extends StatefulWidget {
  const DynamicUpdatesPage({super.key});

  @override
  State<DynamicUpdatesPage> createState() => _DynamicUpdatesPageState();
}

class _DynamicUpdatesPageState extends State<DynamicUpdatesPage> {
  List<String> dynamicUpdatesCategories = [
    "Mutual Funds", "Fixed Deposits", "Insurance", "IPO", "SGB", "Bonds", "AIF",
    "NCD", "PMS", "Dashboard", "Client Dashboard", "RM Dashboard"
  ];
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(child: Column(
        children: [
          // HEADER
          Container(
            padding: EdgeInsets.only(left: 32, right: 32, top: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Dynamic Updates", style: TextStyle(color: Color(0xff461257), fontFamily: 'SemiBold', fontSize: 30),),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey[300]),
                      suffixIcon: Icon(Icons.search_rounded, color: Color(0xff461257),),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff461257), width: 1.5), 
                        borderRadius: BorderRadius.circular(7)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff461257), width: 1.5), 
                        borderRadius: BorderRadius.circular(7)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff461257), width: 1.5), 
                        borderRadius: BorderRadius.circular(7)
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff461257), width: 1.5), 
                        borderRadius: BorderRadius.circular(7)
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // BODY
          Container(
            margin: EdgeInsets.all(32),
            padding: EdgeInsets.all(32),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.3,
            decoration: BoxDecoration(
              color: Color(0xffE6DFF0),
              borderRadius: BorderRadius.circular(10)
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20
              ), 
              itemCount: dynamicUpdatesCategories.length,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width / 4.2,
                  height: MediaQuery.of(context).size.height / 6,
                  decoration: BoxDecoration(
                    color: Color(0xffC0ADCB),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(dynamicUpdatesCategories[index], style: TextStyle(color: Color(0xff461357), fontSize: 20, fontFamily: 'Bold'),),
                  ),
                );
              }
            ),
          )
        ],
      ),
    ));
  }
}