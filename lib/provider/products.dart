import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final userId;
  bool isFavorite;
  Product({
    @required this.id,
    @required this.price,
    @required this.description,
    @required this.imageUrl,
    @required this.title,
    @required this.userId,
    this.isFavorite = false,
  });

  void toggleFavStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      var url = Uri.parse(
        'https://flutter-update-fe608-default-rtdb.firebaseio.com/products/favorite-products/$userId/$id.json?auth=$token',
      );
      final response = await http.put(
        url,
        body: json.encode(isFavorite),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (err) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
