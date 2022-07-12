import 'package:flutter/material.dart';
import '../pages/user_product.dart';
import '../pages/order_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text('hello friend !'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Orders'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersPage.routeName);
          },
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Mange Products'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(UserProducts.routeName);
          },
        ),
      ]),
    );
  }
}
