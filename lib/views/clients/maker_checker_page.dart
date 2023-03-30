import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ewg_maker_checker/providers/single_profile_provider.dart';
import 'package:ewg_maker_checker/views/clients/widgets/pdf_expansion_tile.dart';
import 'package:ewg_maker_checker/views/clients/widgets/photo_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MakerCheckerPage extends StatefulWidget {
  const MakerCheckerPage({super.key});

  @override
  State<MakerCheckerPage> createState() => _MakerCheckerPageState();
}

class _MakerCheckerPageState extends State<MakerCheckerPage> {
  TextEditingController _searchController = TextEditingController();
  int tabIndex = 0;
  List<Map<String, dynamic>> clientDetails = [];

  String _image = "Signature";  

  @override
  Widget build(BuildContext context) {
    return Consumer<SingleProfileProvider>(
      builder: (context, SingleProfileProvider singleProfileProvider, _) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              // HEADER
              Container(
                padding: EdgeInsets.only(left: 32, right: 32, top: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Maker / Checker", style: TextStyle(color: Color(0xff461257), fontFamily: 'SemiBold', fontSize: 30),),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Search Clients",
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
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffF3EEF8),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                  )
                ),
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // BASIC INFO TAB
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  tabIndex = 0;
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 220,
                                decoration: BoxDecoration(
                                  color: tabIndex == 0 ? Color(0xffF3EEF8) : Color(0xffE6DFF0),
                                  borderRadius: BorderRadius.only(bottomRight: tabIndex == 1 ? Radius.circular(15) : Radius.circular(0))
                                ),
                                child: Row(                        
                                  children: [
                                    Container(
                                      width: 5,
                                      color: Color(0xff461257),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                                      child: Text("Basic Info", style: TextStyle(color: Color(0xff461257)),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // FATCA DETAILS TAB
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  tabIndex = 1;
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 220,                      
                                decoration: BoxDecoration(
                                  color: tabIndex == 1 ? Color(0xffF3EEF8) : Color(0xffE6DFF0),
                                  borderRadius: BorderRadius.only(
                                    topRight: tabIndex == 0 ? Radius.circular(15) : Radius.circular(0),
                                    bottomRight: tabIndex == 2 ? Radius.circular(15) : Radius.circular(0),
                                  )
                                ),
                                child: Row(                        
                                  children: [
                                    Container(
                                      width: 5,
                                      color: Color(0xff461257),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                                      child: Text("FATCA Details", style: TextStyle(color: Color(0xff461257)),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // CONTACT DETAILS TAB
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  tabIndex = 2;
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 220,
                                decoration: BoxDecoration(
                                  color: tabIndex == 2 ? Color(0xffF3EEF8) : Color(0xffE6DFF0),
                                  borderRadius: BorderRadius.only(
                                    topRight: tabIndex == 1 ? Radius.circular(15) : Radius.circular(0),
                                    bottomRight: tabIndex == 3 ? Radius.circular(15) : Radius.circular(0),
                                  )
                                ),
                                child: Row(                        
                                  children: [
                                    Container(
                                      width: 5,
                                      color: Color(0xff461257),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                                      child: Text("Contact Details", style: TextStyle(color: Color(0xff461257)),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // BANK DETAILS TAB
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  tabIndex = 3;
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 220,
                                decoration: BoxDecoration(
                                  color: tabIndex == 3 ? Color(0xffF3EEF8) : Color(0xffE6DFF0),
                                  borderRadius: BorderRadius.only(
                                    topRight: tabIndex == 2 ? Radius.circular(15) : Radius.circular(0),
                                    bottomRight: tabIndex == 4 ? Radius.circular(15) : Radius.circular(0),
                                  )
                                ),
                                child: Row(                        
                                  children: [
                                    Container(
                                      width: 5,
                                      color: Color(0xff461257),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                                      child: Text("Bank Details", style: TextStyle(color: Color(0xff461257)),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // NOMINEE DETAILS TAB
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  tabIndex = 4;
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 220,
                                decoration: BoxDecoration(
                                  color: tabIndex == 4 ? Color(0xffF3EEF8) : Color(0xffE6DFF0),
                                  borderRadius: BorderRadius.only(
                                    topRight: tabIndex == 3 ? Radius.circular(15) : Radius.circular(0),
                                    bottomRight: tabIndex == 5 ? Radius.circular(15) : Radius.circular(0),
                                  )
                                ),
                                child: Row(                        
                                  children: [
                                    Container(
                                      width: 5,
                                      color: Color(0xff461257),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                                      child: Text("Nominee Details", style: TextStyle(color: Color(0xff461257)),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // OTHER DETAILS TAB
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  tabIndex = 5;
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 220,
                                decoration: BoxDecoration(
                                  color: tabIndex == 5 ? Color(0xffF3EEF8) : Color(0xffE6DFF0),
                                  borderRadius: BorderRadius.only(
                                    topRight: tabIndex == 4 ? Radius.circular(15) : Radius.circular(0),
                                  )
                                ),
                                child: Row(                        
                                  children: [
                                    Container(
                                      width: 5,
                                      color: Color(0xff461257),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                                      child: Text("Other Details", style: TextStyle(color: Color(0xff461257)),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // CENTER COLUMN DATA
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      height: 600,
                      width: 400,
                      child: ListView.builder(
                        itemCount: singleProfileProvider.clientDataSeparated[tabIndex].length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(left: 20),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                // The Type of Data => Name of the keys of the map
                                Container(
                                  width: 150,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, 
                                    mainAxisAlignment: MainAxisAlignment.start,                                 
                                    children: [
                                      Text(
                                        singleProfileProvider.clientDataSeparated[tabIndex].keys.toList()[index],
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Text(":   "),
                                ),
                                // The Actual Data => Data of the values of the map
                                Container(
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,                                  
                                    children: [
                                      Text(
                                        singleProfileProvider.clientDataSeparated[tabIndex][singleProfileProvider.clientDataSeparated[tabIndex].keys.toList()[index]].toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: Colors.black, fontFamily: 'SemiBold'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                    ),
                    Spacer(),
                    // PHOTO COLUMN
                    Container(
                      height: 600,
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      decoration: BoxDecoration(
                        color: Color(0xffE6DFF0),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        )
                      ),
                      child: SingleChildScrollView(
                        child: Column(                        
                          children: [
                            Container(
                              margin: EdgeInsets.all(16),
                              child: Text(
                                "Image Verification",
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Color(0xff461257), fontFamily: 'SemiBold', fontSize: 20),
                              ),
                            ),
                            PhotoExpanstionTile(title: "Signature", imageUrl: singleProfileProvider.clientData['Sign Link']),
                            SizedBox(height: 20,),
                            PhotoExpanstionTile(title: "Cheque", imageUrl: singleProfileProvider.clientData['Cheque Link']),
                            SizedBox(height: 20,),
                            PhotoExpanstionTile(title: "Selfie", imageUrl: singleProfileProvider.clientData['Selfie Link']),
                            SizedBox(height: 20,),
                            PdfExpansionTile(title: "Esign PDF", pdfUrl: singleProfileProvider.clientData['Esign PDF']),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}