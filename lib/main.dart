import 'package:flutter/material.dart';
import '../provider/user_auth.dart';
import '../pages/auth_screen.dart';
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
                    UserAuth(),
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<UserAuth, ProductsProvider>(
            update: (context, auth, previousProducts) => ProductsProvider(
                auth.token,
                previousProducts == null ? [] : previousProducts.items,
                auth.userId),
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<UserAuth, Orders>(
            update: (context, auth, previousOrders) => Orders(
                auth.token,
                previousOrders == null ? [] : previousOrders.orders,
                auth.userId),
          ),
          // ChangeNotifierProvider(
          //   create:
          //       (context) => // builder for version 3 of provider package & create for the latest version:
          //           ProductsProvider(),
          // ),
          // create:
          //
          // ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          // ChangeNotifierProvider(
          //   create: (context) => Orders(),
          // ),
        ],
        //create method return new instance of provider class:
        child: Consumer<UserAuth>(
          builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.pink,
              accentColor: Colors.amber,
            ),
            home: auth.isAuth ? ProductOverView() : AuthScreen(),
            routes: {
              ProductDetails.routeName: (context) => ProductDetails(),
              CartPage.routeName: (context) => CartPage(),
              OrdersPage.routeName: (context) => OrdersPage(),
              UserProducts.routeName: (context) => UserProducts(),
              EditProduct.routeName: (context) => EditProduct(),
            },
          ),
        ));
  }
}
