import 'package:flutter/material.dart';
import './pages/edit_products.dart';
import './pages/user_product.dart';
import './pages/order_page.dart';
import './provider/orders.dart';
import './pages/cart_page.dart';
import './provider/cart.dart';
import './pages/product_overview.dart';
import './pages/product_detail.dart';
import './provider/products_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // if we don't need the context with any thing we could use another syntax :-

    // return ChangeNotifierProvider.value(
    //   value: ProductsProvider(),
    //   child: MaterialApp(
    //     title: 'MyShop',
    //     theme: ThemeData(
    //       primarySwatch: Colors.pink,
    //       accentColor: Colors.amber,
    //     ),
    //     home: ProductOverView(),
    //     routes: {
    //       ProductDetails.routeName: (context) => ProductDetails(),
    //     },
    //   ),
    // );

    // this syntax for Provider (better to use with main dart to prevent unneccessary renders and avoiding less efficency)
    // It's the best practice  :--------------------

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (context) => // builder for version 3 of provider package & create for the latest version:
                  ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        ),
      ],
      //create method return new instance of provider class:
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.amber,
        ),
        home: ProductOverView(),
        routes: {
          ProductDetails.routeName: (context) => ProductDetails(),
          CartPage.routeName: (context) => CartPage(),
          OrdersPage.routeName: (context) => OrdersPage(),
          UserProducts.routeName: (context) => UserProducts(),
          EditProduct.routeName: (context) => EditProduct(),
        },
      ),
    );
  }
}
