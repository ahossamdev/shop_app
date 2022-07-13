import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/user_auth.dart';
import '../provider/cart.dart';
import '../provider/products.dart';
import '../pages/product_detail.dart';
// import '../provider/cart.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // ProductItem(
  // {this.id, this.imageUrl, this.title}
  // );

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final authData = Provider.of<UserAuth>(context);
    final cart = Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetails.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red[600],
              ),
              onPressed: () {
                product.toggleFavStatus(authData.token, authData.userId);
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Added Item to Cart !',
                ),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removingSingleCart(product.id);
                    }),
              ));
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.red[600],
            ),
          ),
        ),
      ),
    );
  }
}
