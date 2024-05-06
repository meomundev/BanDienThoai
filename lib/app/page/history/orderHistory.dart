import 'dart:convert';

import 'package:app_api/app/model/api.dart';
import 'package:app_api/app/model/order.dart';
import 'package:app_api/app/model/user.dart';
import 'package:app_api/app/page/history/orderHistoryDetail.dart';
import 'package:app_api/other/color.dart';
import 'package:app_api/other/config.dart';
import 'package:flutter/material.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  User user = User.userEmpty();
  OrderModel orderHistory = OrderModel(
    id: "DT02032",
    fullName: "Dinh Gia Lap",
    dateCreated: "39/03/2024",
    total: 716800000,
  );
  List<OrderModel> orders = [];

  @override
  void initState() {
    orders.add(orderHistory);
    super.initState();
  }

  Future<List<OrderModel>> _getBills() async {
    return await APIRepository().getBill();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: mainAppWhite,
        ),
        backgroundColor: blueDark,
        title: Text(
          'Purchase Order History',
          style: TextStyle(color: orangeLight, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _getBills(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 16, left: 12, bottom: 6),
                color: mainAppGrey,
                child: Text(
                  'Date: 04/05/2024',
                  style: TextStyle(
                    color: blueDark,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: mainAppGrey, // Set background color to white
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final order = snapshot.data![index];
                      return OrderWidget(order);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget OrderWidget(OrderModel order) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      elevation: 5.0,
      color: Colors.white,
      surfaceTintColor: transparentColor,
      child: ListTile(
        onTap: () {
          print('You selected order ${order.id}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetaile(
                orderModel: order,
              ),
            ),
          ).then((value) {
            if (value == true) {
              setState(() {
                print('Updated');
                setState(() {});
              });
            }
          });
        },
        title: Text(
          'Order ID: ${order.id}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.0),
            Text(
              'Order Date: ${order.dateCreated}',
              style: TextStyle(
                color: Color.fromARGB(255, 64, 61, 61),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              'Customer Name: Dinh Gia Lap',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              'Total: ${formatCurrency(order.total)}',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
            ),
            SizedBox(height: 10.0),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () async {
            print('You selected to delete order');
            bool check = await APIRepository().deleteBill(order.id);
            if (check) {
              setState(() {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      surfaceTintColor: transparentColor,
                      title: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 5),
                          Text(
                            "System Notification!",
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      content: Text(
                        "Order ${order.id} has been successfully deleted.",
                        style: TextStyle(color: mainAppBlack),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(color: blueDark),
                          ),
                        ),
                      ],
                    );
                  },
                );
              });
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red), // Error icon
                        SizedBox(width: 5),
                        Text(
                          "Unable to Delete!",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                    content: Text(
                      "Please check the server information!.",
                      style: TextStyle(color: Colors.black87),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close"),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
