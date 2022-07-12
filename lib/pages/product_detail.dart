import 'package:flutter/material.dart';
import '../provider/products_provider.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatelessWidget {
  // final title;
  static const routeName = '/product-details';
  // ProductDetails();
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments;

    // final product = Provider.of<ProductsProvider>(context).items.firstWhere(
    //       (prdct) => prdct.id == prodectId,
    // i can create this methods in provider as ( findById() ) and any method i need at the provider ##
    // );

    final product = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${product.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
