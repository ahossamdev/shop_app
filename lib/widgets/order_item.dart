import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../provider/orders.dart' as Ord;

class OrderItem extends StatefulWidget {
  final Ord.OrderItem order;
  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.order.amount}'),
          subtitle: Text(DateFormat.yMMMd().format(widget.order.dateTime)),
          trailing: IconButton(
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
                print(_expanded);
              });
            },
            icon:
                !_expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
          ),
        ),
        if (_expanded)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            height: min(widget.order.products.length * 20.0 + 70, 180),
            child: ListView(
              children: widget.order.products
                  .map((product) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${product.quantity}x \$${product.price}',
                            style: TextStyle(fontSize: 28, color: Colors.grey),
                          )
                        ],
                      ))
                  .toList(),
            ),
          )
      ]),
    );
  }
}
