import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../provider/orders.dart';
import '../widgets/order_item.dart' as Ord;

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key key}) : super(key: key);
  static const routeName = '/orders';

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool isLoading = false;
  @override
  void initState() {
    triggerStateAsync();
    super.initState();
  }

  void triggerStateAsync() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<Orders>(context, listen: false).fechOrders();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (context, index) =>
                  Ord.OrderItem(orderData.orders[index]),
            ),
      drawer: AppDrawer(),
    );
  }
}
