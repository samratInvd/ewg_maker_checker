import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/get_client_details_model.dart';
import '../../providers/client_details_provider.dart';

/*class MyDataTable extends StatefulWidget {
  @override
  _MyDataTableState createState() => _MyDataTableState();
}

class _MyDataTableState extends State<MyDataTable> {
  List<Map<String, dynamic>> _dataList = [
    {"name": "John Doe", "age": 35},
    {"name": "Jane Smith", "age": 42},
    {"name": "Bob Johnson", "age": 28},
  ];


  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Age')),
        DataColumn(label: Text(' ')),
      ],
      rows: _dataList.map((data) => DataRow(
          cells: [
            DataCell(Text(data['name'])),
            DataCell(Text(data['age'].toString())),
            DataCell(IconButton(
              icon: Icon(Icons.arrow_forward_rounded),
              onPressed: () {
                // Handle button press
                print('Edit button pressed for ${data['name']}');
              },
            )),
          ]
      )).toList(),
    );
  }
}*/

class DataTableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClientDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.clientDetails == null) {
            provider.fetchClientDetails();
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.clientDetails!.isEmpty) {
            return Center(
              child: Text('No client details found.'),
            );
          } else {
            return DataTable(
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
              ],
              rows: provider.clientDetails!.map((clientDetail) {
                return DataRow(
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
                    DataCell(IconButton(
                      icon: Icon(Icons.arrow_forward_rounded),
                      onPressed: () {
                        // Handle button press
                        print('Edit button pressed for ${clientDetail.firstName}');
                      },
                    ))
                  ],
                );
              }).toList(),
            );
          }
        },
      );
  }
}
