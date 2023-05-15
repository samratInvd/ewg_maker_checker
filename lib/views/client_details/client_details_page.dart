import 'package:flutter/material.dart';
import 'data_table.dart';


class ClientDetailsPage extends StatefulWidget {
  const ClientDetailsPage({Key? key}) : super(key: key);

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {
  TextEditingController _searchController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
          child: Column(
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
                    OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          'All Clients',
                        ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(20.0),
                        side: BorderSide(color: Color(0xff461257), width: 1)
                      ),
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
                child: DataTableWidget(),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
