import 'dart:developer';
import 'package:ewg_maker_checker/data/encryption.dart';
import 'package:ewg_maker_checker/models/response_model.dart';
import 'package:ewg_maker_checker/providers/api_provider.dart';
import 'package:ewg_maker_checker/providers/routes_provider.dart';
import 'package:ewg_maker_checker/providers/single_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/client_details_provider.dart';

class DataTableWidget extends StatelessWidget {

  Color getColor1(Set<MaterialState> states) {
    return Colors.purple.shade100;
  }

  Color getColor2(Set<MaterialState> states) {
    return Colors.white60;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ClientDetailsProvider, RoutesProvider,
        SingleProfileProvider>(
      builder: (context,
          ClientDetailsProvider clientDetailsProvider,
          RoutesProvider routesProvider,
          SingleProfileProvider singleProfileProvider,
          child) {
        if (clientDetailsProvider.clientDetails == null) {
          clientDetailsProvider.fetchClientDetails(context);
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (clientDetailsProvider.clientDetails!.isEmpty) {
          return Center(
            child: Text('No client details found.'),
          );
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 20,
                dataRowHeight: 50,
                columns: [
                  DataColumn(label: Text('Form ID')),
                  DataColumn(label: Text('Mobile No')),
                  DataColumn(label: Text('Email ID')),
                  DataColumn(label: Text('PAN')),
                  DataColumn(label: Text('UCC')),
                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Middle Name')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('Gender')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('View Client')),
                ],
                rows: clientDetailsProvider.clientDetails!.map((clientDetail) {
                  final index = clientDetailsProvider.clientDetails?.toList().indexOf(clientDetail);
                  return DataRow(
                    color: index! % 2 == 0
                    ? MaterialStateProperty.resolveWith(getColor1)
                    : MaterialStateProperty.resolveWith(getColor2),
                    cells: [
                      DataCell(Text(clientDetail.formID.toString())),
                      DataCell(Text(clientDetail.mobileNo ?? '-')),
                      DataCell(Text(clientDetail.emailID ?? '-')),
                      DataCell(Text(clientDetail.pAN ?? '-')),
                      DataCell(Text(clientDetail.uCC ?? '-')),
                      DataCell(Text(clientDetail.firstName ?? '-')),
                      DataCell(Text(clientDetail.middleName ?? '-')),
                      DataCell(Text(clientDetail.lastName ?? '-')),
                      DataCell(Text(clientDetail.gender ?? '-')),
                      DataCell(Text(clientDetail.description ?? '-')),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.arrow_forward_rounded),
                          onPressed: () async {
                            // Handle button press
                            print(
                                'View Client pressed for ${clientDetail.formID}');
                            routesProvider.setSelectedRoute("/makerChecker");

                            /// This code is making a POST request to an API endpoint using the
                            /// `ApiProvider` class and the `postRequest` method. The `endpoint` parameter
                            /// specifies the endpoint to which the request is being made, and the `body`
                            /// parameter is a map containing the data to be sent with the request. The
                            /// `encryptString` function is used to encrypt the `clientDetail.formID` value
                            /// before sending it as part of the request body. The `await` keyword is used
                            /// to wait for the response from the API before continuing with the execution
                            /// of the code. The response from the API is stored in a `ResponseModel` object
                            /// named `responseModel`.
                            ResponseModel responseModel =
                                await Provider.of<ApiProvider>(context,
                                        listen: false)
                                    .postRequest(
                                        endpoint:
                                            'api/RM/Get_ClientDetailsForChecker',
                                        body: {
                                  "FormNo":
                                      encryptString("${clientDetail.formID}")
                                }).then((response) async {
                              /// This code block is checking the `statusCode` of the `response` received
                              /// from a POST request made to an API endpoint. If the `statusCode` is not
                              /// equal to `"0"`, it means that there was an error in the request and the
                              /// code displays an `AlertDialog` with the error message. If the `statusCode`
                              /// is equal to `"0"`, it means that the request was successful and the code
                              /// clears the data in the `SingleProfileProvider`, populates it with the data
                              /// of a single client from the response, separates the details of the client
                              /// data, and sets the form number in the `SingleProfileProvider`.
                              if (response.statusCode != "0") {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                          "${response.message!.toUpperCase()}",
                                          style: TextStyle(
                                              fontFamily: 'SemiBold',
                                              color: Color(0xff461257)),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Ok",
                                                style: TextStyle(
                                                    color: Color(0xff461257)),
                                              ))
                                        ],
                                      );
                                    });
                              } else {
                                log(response.toJson().toString());

                                // CLEARING THE DATA
                                singleProfileProvider.clearData();

                                // Populating the new data
                                /// These lines of code are populating the data of a single client and
                                /// setting it in the `SingleProfileProvider` for further use.
                                singleProfileProvider.setClientData(response
                                    .data!['clientDetailsForCheckerMaker'][0]);
                                singleProfileProvider.separateDetailsInClientData(
                                    response.data!['clientDetailsForCheckerMaker']
                                        [0]);
                                print("CLIENT DATA SEPARATED: " +
                                    singleProfileProvider.clientDataSeparated
                                        .toString());
                                print(singleProfileProvider.clientData);
                                singleProfileProvider
                                    .setFormNo(clientDetail.formID.toString());
                              }
                              return response;
                            });
                          },
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }
}

