import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/http_exception.dart';
// import '../Server data/products_server.dart';
import 'products.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  //need to be private to not be used from outside:

  // var _showFavoritesOnly = false;
  final String authToken;
  final String userId;
  ProductsProvider(this.authToken, this._items, this.userId);

  List<Product> get items {
    return [..._items];
    // we need a newn list not to pointing to the _items list in memory
  }

  List<Product> get favProducts {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((prdct) => prdct.id == id);
  }

  // getting data from server :

  Future<void> fetchProductsData([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    var url = Uri.parse(
      'https://flutter-update-fe608-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString',
    );
    try {
      final response = await http.get(url);
      final decodedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      print(decodedResponse);
      List<Product> loadedproducts = [];
      if (decodedResponse == null) return;
      url = Uri.parse(
        'https://flutter-update-fe608-default-rtdb.firebaseio.com/products/favorite-products/$userId.json?auth=$authToken',
      );
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      decodedResponse.forEach((prodId, prodData) {
        loadedproducts.add(
          Product(
            id: prodId,
            price: prodData['price'] as double,
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            title: prodData['title'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
      });
      _items = loadedproducts.reversed.toList();
      notifyListeners();
      // print(decodedResponse);
    } catch (err) {
      print(' here line 5999');
      throw err;
    }
  }

  // posting data from server :

  Future<void> addProduct(Product product) {
    final url = Uri.parse(
      'https://flutter-update-fe608-default-rtdb.firebaseio.com/products.json?auth=$authToken',
    );
    return http
        .post(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'creatorId': userId,
            }))
        .then((response) {
      final newProduct = Product(
        id: json.decode(
            response.body)['name'], // to access the id value in firebase
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        title: product.title,
      );
      _items.add(newProduct);
      // items.insert(0, newProduct); // we can use this to insert by index
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  // updating method localy :

  Future<void> updateProduct(String productId, Product updatedProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == productId);
    if (prodIndex >= 0) {
      final url = Uri.parse(
        'https://flutter-update-fe608-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken',
      );
      try {
        await http.patch(
          url,
          body: json.encode({
            'title': updatedProduct.title,
            'description': updatedProduct.description,
            'price': updatedProduct.price,
            'imageUrl': updatedProduct.imageUrl,
          }),
        );
        _items[prodIndex] = updatedProduct;
      } catch (err) {
        print(err);
      }
      notifyListeners();
    } else {
      print('we dont have this product in our list !');
    }
  }

  // deleting method localy :

  Future<void> deleteProduct(String id) async {
    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[existingProductIndex];
    notifyListeners();
    final url = Uri.parse(
      'https://flutter-update-fe608-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken',
    );
    _items.removeWhere((product) => product.id == id);
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Failed to delete product !');
    }

    existingProduct = null;
    notifyListeners();
  }
}
