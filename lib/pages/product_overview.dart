import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../pages/cart_page.dart';
import '../provider/cart.dart';
import '../widgets/badge.dart';
import '../provider/products_provider.dart';
import '../widgets/product.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverView extends StatefulWidget {
  @override
  State<ProductOverView> createState() => _ProductOverViewState();
}

class _ProductOverViewState extends State<ProductOverView> {
  var _showFavoritesOnly = false;
  var isInit = true;
  var isLoaded = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoaded = true;
      });
      Provider.of<ProductsProvider>(context).fetchProductsData().then((_) {
        setState(() {
          isLoaded = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context, listen: false);
    // we here establish connection to the ProductProvider class:
    final products =
        _showFavoritesOnly ? productsData.favProducts : productsData.items;
    // we here listening to items list if there is any change it will be submitted.
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions value) {
                setState(() {
                  if (value == FilterOptions.Favorites) {
                    _showFavoritesOnly = true;
                    print(_showFavoritesOnly);
                  } else {
                    _showFavoritesOnly = false;
                    print(_showFavoritesOnly);
                  }
                });
              },
              icon: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (context, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              // this is child of consumer passed to badge child as a (ch) by the (ch) consumer parameter
              // and this is defined outside to avoid rebuild for any changes .
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CartPage.routeName,
                );
              },
            ),
          )
        ],
        title: Text(
          'MyShop',
        ),
      ),
      body: isLoaded
          ? Center(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Loading',
                      style: TextStyle(
                          color: Colors.pink,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: products.length, //imported from server data
              itemBuilder: (BuildContext context, int index) =>
                  ChangeNotifierProvider.value(
                value: products[index],
                child: ProductItem(
                    // id: products[index].id,
                    // imageUrl: products[index].imageUrl,
                    // title: products[index].title,
                    ),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
      drawer: AppDrawer(),
    );
  }
}
