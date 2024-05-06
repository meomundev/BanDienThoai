import 'package:app_api/app/model/api.dart';
import 'package:app_api/app/model/product.dart';
import 'package:app_api/app/model/product_viewmodel.dart';
import 'package:app_api/other/color.dart';
import 'package:app_api/other/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class ProductCart extends StatefulWidget {
  const ProductCart({Key? key}) : super(key: key);

  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: mainAppGrey, // Set the background color here
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your cart',
                style: TextStyle(
                  color: blueDark,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Consumer<ProductVM>(
                  builder: (context, value, child) {
                    final totalQuantity = value.getTotalQuantity();
                    final totalPrice = value.getTotalPrice();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.shopping_bag_rounded,
                              color: orangeLight,
                              size: 32,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(
                              'Total Quantity:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '$totalQuantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.price_change_rounded,
                              color: orangeLight,
                              size: 32,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(
                              'Total Price:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${formatCurrency(totalPrice)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (value.lst.length > 0) {
                              bool check =
                                  await APIRepository().addBill(value.lst);
                              if (check) {
                                value.lst.clear();
                                print('Payment successful');
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: mainAppWhite,
                                      surfaceTintColor: transparentColor,
                                      title: const Row(
                                        children: [
                                          Icon(Icons.check_circle,
                                              color: Colors.green),
                                          SizedBox(width: 5),
                                          Text(
                                            "Payment Successful",
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        "Thank you for your payment.",
                                        style:
                                            TextStyle(color: greyColorForText),
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
                              } else {
                                print('Payment failed');
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: mainAppWhite,
                                    surfaceTintColor: transparentColor,
                                    title: const Row(
                                      children: [
                                        Icon(Icons.error, color: Colors.red),
                                        SizedBox(width: 5),
                                        Text(
                                          "Unable to Proceed!",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                    content: Text(
                                      "Please add at least one product before proceeding to payment.",
                                      style: TextStyle(color: greyColorForText),
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
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 30),
                            backgroundColor: orangeLight,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          icon: Icon(
                            Icons.payment_outlined,
                            color: mainAppWhite,
                          ),
                          label: Text(
                            'Proceed to Payment',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'The products you have selected',
                style: TextStyle(
                  color: blueDark,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: Consumer<ProductVM>(
                  builder: (context, value, child) => ListView.builder(
                    itemCount: value.lst.length,
                    itemBuilder: (context, index) {
                      return Card(
                        surfaceTintColor: transparentColor,
                        elevation: 4,
                        color: Colors.white,
                        shadowColor: blueDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.network(
                                value.lst[index].img!,
                                width: 130,
                                height: 110,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, StackTrace) =>
                                    Icon(Icons.image),
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      value.lst[index].name ?? '',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      value.lst[index].desc!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      formatCurrency(value.lst[index].price!),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon:
                                              Icon(Icons.remove_circle_outline),
                                          onPressed: () {
                                            if (value.lst[index].quantity ==
                                                1) {
                                              value.del(value.lst[index].id!);
                                            }
                                            value.remove(value.lst[index]);
                                          },
                                        ),
                                        Text(
                                          value.lst[index].quantity.toString(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.add_circle_outline,
                                          ),
                                          onPressed: () {
                                            value.add(value.lst[index]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
