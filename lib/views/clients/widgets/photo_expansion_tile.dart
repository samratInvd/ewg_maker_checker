import 'package:flutter/material.dart';

class PhotoExpanstionTile extends StatefulWidget {
  final String title;
  final String imageUrl;
  const PhotoExpanstionTile({super.key, required this.title, required this.imageUrl});

  @override
  State<PhotoExpanstionTile> createState() => _PhotoExpanstionTileState();
}

class _PhotoExpanstionTileState extends State<PhotoExpanstionTile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.21,
        // height: 300, 
        // padding: EdgeInsets.all(8),                             
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: ExpansionTile(
          title: Text(widget.title, style: TextStyle(color: Color(0xff461257), fontSize: 18, fontFamily: 'SemiBold'),),
          children: [
            Container(
              height: 290,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
              ),
              child: Column(
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context, 
                          builder: (context) {
                            return AlertDialog(
                              content: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(widget.imageUrl),
                                    fit: BoxFit.contain
                                  )
                                ),
                              ),
                              actions: [
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    color: Color(0xff461257),
                                    onPressed: () => Navigator.pop(context),
                                    child: Center(child: Text("Close", style: TextStyle(color: Colors.white, fontFamily: 'SemiBold', fontSize: 20),),),
                                  ),
                                )
                              ],
                            );
                          }
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        height: 200, 
                        decoration: BoxDecoration(
                          color: Color(0xffF6F5FA),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(widget.imageUrl),                                              
                            fit: BoxFit.contain
                          )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.09,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          color: Color(0xff461257),
                          onPressed: () {},
                          child: Center(child: Text("Resend", style: TextStyle(color: Colors.white, fontFamily: 'SemiBold'),)),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.09,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          color: Color(0xff461257),
                          onPressed: () {},
                          child: Center(child: Text("Approve", style: TextStyle(color: Colors.white, fontFamily: 'SemiBold'),)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // SizedBox(height: 10,),                                  
          ],
        ),
      ),
    );
  }
}